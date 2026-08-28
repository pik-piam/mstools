mkSeries <- function(ncell, yrs, nb, vals) {
  a <- array(vals, dim = c(ncell, length(yrs), nb),
             dimnames = list(paste0("c", seq_len(ncell)), paste0("y", yrs), paste0("b", seq_len(nb))))
  as.magpie(a, spatial = 1, temporal = 2)
}

test_that("toolHarmonize2Baseline basic input checks still hold", {
  x <- mkSeries(2, 2000:2010, 1, runif(2 * 11))
  expect_error(toolHarmonize2Baseline(1, x), "not a MAgPIE object")
  expect_error(toolHarmonize2Baseline(x, x, ref_year = "y1999"), "reference year")
})

test_that("limited method matches a hand-computed value away from cancellation", {
  # base > x at ref, so lambda = sqrt(x[ref]/base[ref]) != 1
  base <- mkSeries(1, 2015, 1, 10)
  x    <- mkSeries(1, c(2015, 2016), 1, c(4, 6))
  expected <- 10 + (6 - 4) * (10 / 4)^sqrt(4 / 10)
  out <- toolHarmonize2Baseline(x, base, ref_year = "y2015")
  expect_equal(as.numeric(out[, "y2016", ]), expected, tolerance = 1e-12)
})

test_that("limited method matches the direct formula bit-for-bit when lambda != 1", {
  # base > x at ref everywhere -> never hits the cancellation-free rewrite
  set.seed(9)
  base <- mkSeries(20, 1995:2015, 2, runif(20 * 21 * 2, 2000, 5000))
  x    <- mkSeries(20, 2000:2100, 2, runif(20 * 101 * 2, 1, 100))
  out  <- toolHarmonize2Baseline(x, base, ref_year = "y2015")

  xa <- as.array(x)
  ba <- as.array(base)
  expect_true(all(ba[, "y2015", ] > xa[, "y2015", ]))
  afterRef <- paste0("y", 2016:2100)
  repYr <- rep("y2015", length(afterRef))
  lambda <- sqrt(xa[, repYr, ] / ba[, repYr, ])
  expected <- ba[, repYr, ] + (xa[, afterRef, ] - xa[, repYr, ]) * (ba[, repYr, ] / xa[, repYr, ])^lambda

  expect_equal(as.numeric(as.array(out[, afterRef, ])), as.numeric(expected))
})

test_that("the cancellation-free rewrite removes zero/nonzero nondeterminism under a 1-ULP input change", {
  # Regression test: a series decaying to exactly 0 after ref used to hit a
  # near-cancellation whose sign (and clamp-to-zero outcome) depended on the
  # last bit of x. A 1-ULP input perturbation must no longer flip that outcome.
  set.seed(2)
  ncell <- 2000
  nb <- 2
  yrsB <- 1995:2015
  yrsX <- 2000:2100
  lvl <- runif(ncell, 5, 3000)
  decay <- outer(runif(ncell, 0.3, 1.6), seq(0, 1, length.out = length(yrsX)))
  rawX <- pmax(0, rep(lvl, length(yrsX)) * (1 - as.vector(decay)))
  x <- mkSeries(ncell, yrsX, nb, rep(rawX, nb))
  base <- mkSeries(ncell, yrsB, nb, runif(ncell * length(yrsB) * nb, 1000, 5000))

  perturbed <- x
  perturbed[] <- as.array(x) *
    (1 + .Machine$double.eps * sample(c(-2, -1, 0, 1, 2), length(x), TRUE))

  r1 <- as.array(toolHarmonize2Baseline(x, base))
  r2 <- as.array(toolHarmonize2Baseline(perturbed, base))

  expect_identical(sum((r1 == 0) != (r2 == 0)), 0L)
})

test_that("limited method is continuous in base[ref] where x[ref] == 0", {
  # x[ref] == 0 used to be resolved two incompatible ways: base[ref] > 0 gave
  # base[ref] + x[after] via Inf^0 == 1 (which is the formula's continuous limit),
  # base[ref] == 0 gave NaN, zeroed by the is.na() cleanup. That single point let a
  # dust-sized base[ref] decide between 0 and a full-magnitude signal.
  x <- mkSeries(1, c(2015, 2016, 2017), 1, c(0, 5, 10))
  out <- function(baseRef) {
    as.numeric(toolHarmonize2Baseline(x, mkSeries(1, 2015, 1, baseRef),
                                      ref_year = "y2015")[, c("y2016", "y2017"), ])
  }
  expect_equal(out(1e-3), c(1e-3 + 5, 1e-3 + 10))
  expect_equal(out(0), c(5, 10))
  # a dust-sized base[ref] must move the output by at most itself, never amplify it
  expect_lte(max(abs(out(2^-59) - out(0))), 2^-59)
})

test_that("NA in x after ref_year propagates as NA with a warning, not an error or zero", {
  # An NA input used to be silently zeroed by a since-removed is.na() cleanup.
  # It must now come through as NA (with the existing "inconsistencies" warning),
  # and must not trip up the `negative` check that guards the zero-clamp below.
  # base[ref] <= x[ref], so lambda == 1 (multiplicative shortcut) and
  # y2016's expected value is simply base[ref] * x[y2016] / x[ref].
  base <- mkSeries(1, 2015, 1, c(1))
  x    <- mkSeries(1, c(2015, 2016, 2017), 1, c(7, 14, NA))

  expect_warning(
    out <- toolHarmonize2Baseline(x, base, ref_year = "y2015"),
    "inconsistencies"
  )
  expect_equal(as.numeric(out[, "y2016", ]), 1 * 14 / 7)
  expect_true(is.na(as.numeric(out[, "y2017", ])))

  # same, but with a genuine negative present elsewhere so `negative` is TRUE
  baseNeg <- mkSeries(1, 2015, 1, c(-1))
  expect_warning(
    outNeg <- toolHarmonize2Baseline(x, baseNeg, ref_year = "y2015"),
    "inconsistencies"
  )
  expect_true(is.na(as.numeric(outNeg[, "y2017", ])))
})

test_that("additive, multiplicative and hard_cut methods are unaffected", {
  set.seed(3)
  ncell <- 50
  nb <- 2
  base <- mkSeries(ncell, 1995:2015, nb, runif(ncell * 21 * nb, 1, 5000))
  x    <- mkSeries(ncell, 2000:2100, nb, runif(ncell * 101 * nb, 1, 5000))

  for (m in c("additive", "multiplicative")) {
    out <- toolHarmonize2Baseline(x, base, ref_year = "y2015", method = m)
    expect_true(all(is.finite(as.array(out))))
  }
  out <- toolHarmonize2Baseline(x, base, ref_year = "y2015", hard_cut = TRUE)
  expect_equal(as.array(out[, "y2100", ]), as.array(x[, "y2100", ]), ignore_attr = TRUE)
})
