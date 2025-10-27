#' @title toolFertilizerDistribution
#' @description Disaggregates fertilizer usage to best match soil nitrogen uptake efficiency (snupe).
#' @param iterMax Maximum number of iterations for downscaling. 10 iterations are done at least.
#' @param maxSnupe Maximum allowed snupe (used to cap NA's during iteration)
#' @param mapping mapping used for disaggregation
#' @param from name of from column in mapping
#' @param to name of to column in mapping
#' @param fertilizer Total inorganic fertilizer to distribute (regional level)
#' @param snupe Regional soil nitrogen uptake efficiency
#' @param withdrawals Nitrogen withdrawals at the cell level
#' @param organicinputs Non-inorganic fertilizer inputs at the cell level
#' @param threshold Tg N difference below which we consider convergence "good enough"
#' @param progress Logical, should progress messages be printed
#' @return magpie object of fertilizer usage at cell level
#' @author Benjamin Leon Bodirsky, Michael Crawford
#' @importFrom magclass getYears dimSums
#'
#' @export
toolFertilizerDistribution <- function(iterMax = 50, maxSnupe = 0.85, fertilizer,
                                       mapping = NULL, from = NULL, to = NULL,
                                       snupe, withdrawals, organicinputs, threshold = 0.5, progress = TRUE) {

  # - harmonize years
  yrs <- getYears(fertilizer)
  sameYears <- function(x) identical(yrs, getYears(x))
  if (!all(sameYears(withdrawals), sameYears(snupe), sameYears(organicinputs))) {
    stop("All inputs must share the same years.")
  }

  # - aggregate to region
  # this function will either work with simple `celliso` (e.g. -109p25.58p75.CAN) or
  # with a mapping file when it's provided. The clusterfile used by magpie4 is particularly relevant
  if (!is.null(mapping)) {
    withdrawalsReg <- toolAggregate(withdrawals, dim = 1, rel = mapping, from = from, to = to, partrel = TRUE)
    organicinputsReg <- toolAggregate(organicinputs, dim = 1, rel = mapping,
                                     from = from, to = to, partrel = TRUE)
  } else {
    withdrawalsReg <- dimSums(withdrawals, dim = c(1.1, 1.2))
    organicinputsReg <- dimSums(organicinputsReg, dim = c(1.1, 1.2))
  }

  regions <- getItems(withdrawalsReg, dim = 1)
  snupe <- snupe[regions, , ]
  snupeInitial <- snupe
  fertilizerRegional <- fertilizer[regions, , ]
  fertilizerInitial <- fertilizerRegional

  gap_accumulate <- 0
  for (i in seq_len(iterMax)) {
    if (progress) {
      message(sprintf("Iteration %d/%d", i, iterMax))
    }

    if (!is.null(mapping)) {
      snupeDisagg <- toolAggregate(snupe, rel = mapping, from = to, to = from, partrel = TRUE)
    } else {
      snupeDisagg <- snupe
    }

    # compute required inputs per cell
    required <- withdrawals / snupeDisagg
    required[is.nan(required)] <- withdrawals

    # compute requirements that cannot be filled with organic fertilizer
    inorganic_gap =  pmax(required - organicinputs, 0)
    inorganic_gap_reg = toolAggregate(inorganic_gap, dim = 1, rel = mapping,
                  from = from, to = to, partrel = TRUE)

    # compute excess fertilizer after closing the gap
    gap = inorganic_gap_reg - fertilizer

    if (progress) {
      message(sprintf("  Mean global fertilizer divergence per timestep: %.2f Tg N", mean(dimSums(abs(gap),dim = c(1,3)))))
    }

    if ((abs(mean(dimSums(-gap,dim = c(1,3)))) <= threshold) & (i > 10)) {
      break
    }

    gap_accumulate = gap_accumulate + gap / 3
    # - update snupe based on new regional balance
    snupe <- (withdrawalsReg + gap_accumulate) / (organicinputsReg + fertilizer)
    snupe[is.na(snupe)] <- maxSnupe
    snupe[snupe > maxSnupe] <- maxSnupe
    snupe[snupe < 0.05] <- 0.05

  }

  if (mean(dimSums(abs(gap),dim = c(1,3))) > threshold) {
    warning("Fertilizer distribution did not converge; remaining gap: ",
            round(mean(dimSums(abs(gap),dim = c(1,3))), 5), " Tg N")
  }

  # - final cell-level fertilizer. Disaggregate based on the weight of the inorganic fertilizer gap.
  # to speed up: first write regional values in gridded format to have matching formats, then proceed with calculation
  inorganic_gap_reg_disagg <- toolAggregate(inorganic_gap_reg, rel = mapping, from = to, to = from, partrel = TRUE)
  fertilizer_disagg <- toolAggregate(fertilizer, rel = mapping, from = to, to = from, partrel = TRUE)

  fert <- (inorganic_gap/inorganic_gap_reg_disagg)
  fert[is.nan(fert)] <- 0
  fert = fert * fertilizer_disagg

  # - sanity checks
  if (abs(mean(dimSums(fertilizerRegional,dim = c(1,3))) - mean(dimSums(fert,dim = c(1,3)))) > threshold * 1.01) {
    stop("Internal consistency error: cell sums don't match region total")
  }
  if (abs(mean(dimSums(fertilizerRegional,dim = c(1,3))) - mean(dimSums(fert,dim = c(1,3)))) > threshold * 1.05) {
    warning("Note: incomplete country-to-cell mapping caused some info loss")
  }

  return(fert)
}
