#' toolHarmonize2Baseline
#'
#' @param x magclass object that should be set on baseline
#' @param base magclass object for baseline
#' @param ref_year Reference year
#' @param method additive: x is harmonized to base by additive factor
#'               multiplicative: x is harmonized to base by multiplicative factor
#'               limited: multiplicative harmonization,
#'               but for an underestimated baseline the signal is
#'               limited to the additive term rather than the multiplicative factor
#' @param hard_cut Switch to TRUE for data that can not be harmonized, but have to be glued together
#'
#' @return the averaged data in magclass format
#' @author Kristine Karstens, Felicitas Beier
#'
#' @export

toolHarmonize2Baseline <- function(x,
  base,
  ref_year = "y2015", # nolint: object_name_linter
  method = "limited",
  hard_cut = FALSE # nolint: object_name_linter
) {
  if (!is.magpie(x) || !is.magpie(base)) stop("Input is not a MAgPIE object, x has to be a MAgPIE object!")

  # check for negative range of values; na.rm so an NA in x/base (which is meant to
  # propagate through to the output, not be treated as a sign) doesn't turn this NA
  negative <- (any(x < 0, na.rm = TRUE) | any(base < 0, na.rm = TRUE))

  # check if years are overlapping and refs is part of both time horizons
  if (!ref_year %in% intersect(getYears(x), getYears(base))) {
    stop("Overlapping time period of baseline and data is not including the reference year!")
  }

  # set years
  years <- sort(union(getYears(base), getYears(x)))
  tillRef <- getYears(base, as.integer = TRUE)
  tillRef <- paste0("y", tillRef[tillRef <= as.numeric(substring(ref_year, 2))])
  afterRef <- getYears(x, as.integer = TRUE)
  afterRef <- paste0("y", afterRef[afterRef > as.numeric(substring(ref_year, 2))])


  # check if x and base are identical in dimension except time
  if (!setequal(getCells(x), getCells(base)) || !setequal(getNames(x), getNames(base))) {
    stop("Dimensions of the MAgPIE objects do not match!")
  }

  # create new magpie object with full time horizon
  full <- new.magpie(getCells(x), years, getNames(x), sets = getSets(x))

  full <- as.array(full)
  x <- as.array(x)
  base <- as.array(base)

  # from start until ref_year, use the corresponding ref value
  full[, tillRef, ] <- base[, tillRef, ]

  repRefYear <- rep(ref_year, length(afterRef))

  if (hard_cut) {
    ###########################################
    ### Use GCM data after historical data  ###
    ### from reference year +1 on           ###
    ###########################################

    full[, afterRef, ] <- x[, afterRef, ]
  } else if (method == "multiplicative") {
    full[, afterRef, ] <- x[, afterRef, ] * (base[, repRefYear, ] / x[, repRefYear, ])

    # correct NAs and infinite
    fullNotFinite <- !is.finite(full[, afterRef, ])
    # does this make sense?
    full[, afterRef, ][fullNotFinite] <- (base[, repRefYear, ] + x[, afterRef, ])[fullNotFinite]
  } else if (method == "additive") {
    full[, afterRef, ] <- x[, afterRef, ] + (base[, repRefYear, ] - x[, repRefYear, ])
  } else if (method == "limited") {
    ###########################################
    ### Use DELTA-approach to put signal of ###
    ### GCM data on historical observation  ###
    ### data from reference year +1 on      ###
    ###########################################

    lambda <- sqrt(x[, ref_year, , drop = FALSE] / base[, ref_year, , drop = FALSE])
    lambda[base[, ref_year, ] <= x[, ref_year, ]] <- 1
    lambda[is.nan(lambda)] <- 1
    lambda <- lambda[, repRefYear, ]

    xRef <- x[, repRefYear, ]
    baseRef <- base[, repRefYear, ]
    xAfter <- x[, afterRef, ]

    # The basic formula in the following is
    # _ base + (xa-xr)*(base/xr)^lambda _
    #
    # For lambda == 1, we first use the algebraically identical form base*xa/xr,
    # as it is numerically more stable and does not result in floating point residuals.
    # We first fill it in everywhere since it's cheap, then only
    # the cells it doesn't apply to are overwritten below.
    full[, afterRef, ] <- baseRef * xAfter / xRef

    # We then continue to calculate the full formula for all other cells in which
    # xref != 0 (see below for details)
    fullCalc <- lambda != 1 & xRef != 0
    full[, afterRef, ][fullCalc] <-
      baseRef[fullCalc] + (xAfter[fullCalc] - xRef[fullCalc]) * (baseRef[fullCalc] / xRef[fullCalc])**lambda[fullCalc]

    # Now there are three edge cases, we need to handle:
    # - base[,ref_year,] == 0: In this case, we want to harmonize to the baseline zero as the two disagree what
    #   is happening in this cell, and therefore we want to use the multiplicative behavior which incidentally
    #   achieves this. We select the multiplicative behavior by setting lambda to 1 above when baseRef <= xRef,
    #   which holds directly when base[,ref_year,] == 0 and xRef >= 0; for xRef < 0, baseRef <= xRef is false,
    #   but baseRef / xRef is then non-real so lambda is NaN and gets forced to 1 by the is.nan() cleanup instead.
    # - x[,ref_year,] == 0 and base[,ref_year,] > 0: excluded from fullCalc above and handled by the direct
    #   assignment below instead, but would give the same result if it went through the formula: lambda is 0 in
    #   this case, baseRef / xRef => Inf, Inf**0 => 1, so additive behavior which we want.
    # - x[,ref_year,] == 0 == base[,ref_year,]: In this case, we want to remain open to any changes from the
    #   baseline in the future, and thus need to select the additive behavior, as there is nothing to apply a
    #   relative change to in x.
    #   As x[,ref_year,] == 0 also is additive, we can simply apply this to all xRef == 0 cases.
    xRefZeroCells <- xRef == 0
    full[, afterRef, ][xRefZeroCells] <- baseRef[xRefZeroCells] + xAfter[xRefZeroCells]

  } else {
    stop("Please select harmonization method (additive, multiplicative, limited (default))")
  }

  # check for nans and more
  if (any(is.infinite(full) | is.nan(full) | is.na(full))) {
    warning("Data containing inconsistencies.")
  }
  # na.rm here too, for the same reason: an NA in full must not make this NA and error
  # in the &&, it should just fall through with the warning above already raised.
  if (!negative && any(full < 0, na.rm = TRUE)) {
    vcat(2, paste0(
      "toolHarmonize2Baseline created unwanted negativities in the range of ",
      range(full[which(full < 0)]),
      ". They will be set to zero."
    ))
    full[which(full < 0)] <- 0
  }

  out <- as.magpie(full, spatial = 1)

  return(out)
}
