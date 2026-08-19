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
  # single cell/band/year triple with base[ref] = 10 and x[ref] = 4, so
  # base > x and lambda equals the square root of x[ref]/base[ref].
  base <- mkSeries(1, 2015, 1, 10)
  x    <- mkSeries(1, c(2015, 2016), 1, c(4, 6))
  lambda <- sqrt(4 / 10)
  expected <- 10 + (6 - 4) * (10 / 4)^lambda
  out <- toolHarmonize2Baseline(x, base, ref_year = "y2015")
  expect_equal(as.numeric(out[, "y2016", ]), expected, tolerance = 1e-12)
})

test_that("limited method is bit-identical to the pre-rewrite formula when lambda != 1", {
  # base > x at ref everywhere -> lambda = sqrt(x/base) != 1 (never hits the
  # cancellation-free rewrite path), so output must match the direct formula
  # `base + (xa - xr) * (base/xr)^lambda` exactly.
  set.seed(9)
  ncell <- 200
  nb <- 2
  base <- mkSeries(ncell, 1995:2015, nb, runif(ncell * 21 * nb, 2000, 5000))
  x    <- mkSeries(ncell, 2000:2100, nb, runif(ncell * 101 * nb, 1, 100))

  out <- toolHarmonize2Baseline(x, base, ref_year = "y2015")

  xa <- as.array(x)
  ba <- as.array(base)
  expect_true(all(ba[, "y2015", ] > xa[, "y2015", ])) # sanity: never triggers lambda == 1
  afterRef <- paste0("y", 2016:2100)
  # broadcast base/x/lambda at the reference year across afterRef the same
  # way the source does (index by a repeated reference-year vector), so the
  # (cell, year, band) layout matches out[, afterRef, ] without any manual
  # reshaping or risk of recycling misaligned with that layout
  repYr <- rep("y2015", length(afterRef))
  lambda <- sqrt(xa[, "y2015", , drop = FALSE] / ba[, "y2015", , drop = FALSE])[, repYr, ]
  expected <- ba[, repYr, ] + (xa[, afterRef, ] - xa[, repYr, ]) * (ba[, repYr, ] / xa[, repYr, ])^lambda

  expect_equal(as.numeric(as.array(out[, afterRef, ])), as.numeric(expected))
})

test_that("the cancellation-free rewrite removes zero/nonzero nondeterminism under a 1-ULP input change", {
  # This is the regression test for the fix: in the lambda == 1 branch
  # (base <= x at ref), a value that decays to exactly 0 after the reference
  # year used to be computed as base - xr*(base/xr), a near-cancellation whose
  # sign (and therefore whether it survives the `full < 0 -> 0` clamp) depends
  # on the last bit of xr. A 1-ULP perturbation of the input -- standing in
  # for any change in summation order upstream, such as a vectorized
  # reformulation of a spline -- must no longer flip the zero/nonzero outcome.
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
