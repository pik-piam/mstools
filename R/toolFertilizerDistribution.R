#' @title toolFertilizerDistribution
#' @description Disaggregates fertilizer usage to best match soil nitrogen uptake efficiency (snupe).
#' @param iterMax Maximum number of iterations for downscaling
#' @param maxSnupe Maximum allowed snupe (used to cap NA's during iteration)
#' @param fertilizer Total inorganic fertilizer to distribute (regional level)
#' @param snupe Regional soil nitrogen uptake efficiency
#' @param withdrawals Nitrogen withdrawals at the cell level
#' @param organicinputs Non-inorganic fertilizer inputs at the cell level
#' @param threshold Tg N difference below which we consider convergence "good enough"
#' @return magpie object of fertilizer usage at cell level
#' @importFrom magclass getYears getRegions dimSums
#'
#' @export
toolFertilizerDistribution <- function(iterMax = 50, maxSnupe = 0.85, fertilizer,
                                       snupe, withdrawals, organicinputs, threshold = 0.5) {

  # - harmonize years
  yrs <- getYears(fertilizer)
  sameYears <- function(x) identical(yrs, getYears(x))
  if (!all(sameYears(withdrawals), sameYears(snupe), sameYears(organicinputs))) {
    stop("All inputs must share the same years.")
  }

  # - aggregate to region
  withdrawalsReg <- dimSums(withdrawals, dim = c(1.1, 1.2))
  regions <- getItems(withdrawalsReg, dim = 1)
  snupe <- snupe[regions, , ]
  fertilizerRegional <- fertilizer[regions, , ]
  fertilizerInitial <- fertilizerRegional

  gap <- Inf
  for (i in seq_len(iterMax)) {
    message(sprintf("Iteration %d/%d", i, iterMax))

    # - compute required inputs per cell
    required <- withdrawals / snupe
    required[is.nan(required)] <- 0

    # - split organic into usable vs. excessive
    excessiveOrganic <- pmax(0, organicinputs - required)
    usableOrganic <- organicinputs - excessiveOrganic

    # - compute surplus fertilizer gap
    gap <- sum(required) - sum(usableOrganic) - sum(fertilizerRegional)
    message(sprintf("  Surplus fertilizer: %.2f Tg N", gap))

    if (gap <= threshold) {
      break
    }

    # - update snupe based on new regional balance
    usableOrganicRegional <- dimSums(usableOrganic, dim = c(1.1, 1.2))
    snupe <- withdrawalsReg / (usableOrganicRegional + fertilizerRegional)
    snupe[is.na(snupe)] <- maxSnupe
  }

  if (gap > threshold) {
    warning(
      "Fertilizer distribution did not converge; remaining gap: ",
      round(gap, 5), " Tg N"
    )
  }

  # - final cell-level fertilizer
  fert <- required - usableOrganic

  # - sanity checks
  if (abs(sum(fertilizerRegional) - sum(fert)) > threshold * 1.01) {
    stop("Internal consistency error: cell sums don't match region total")
  }
  if (abs(sum(fertilizerInitial) - sum(fert)) > threshold * 1.05) {
    message("Note: incomplete country-to-cell mapping caused some info loss")
  }

  return(fert)
}
