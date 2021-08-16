#' @title toolHoldConstant
#' @description Holds a historical dataset constant for the entire period \code{years}.
#'
#' @param x MAgPIE object to be continued.
#' @param years years for which the data should exist (hold constant, if missing)
#' @return MAgPIE object with completed time dimensionality.
#' @author Benjamin Leon Bodirsky, Jan Philipp Dietrich
#' @importFrom magclass getYears getYears<-
#' @export

toolHoldConstant <- function(x, years) {
  if (is.integer(years)) years <- paste0("y", years)
  missingyears <- setdiff(years, getYears(x))
  if (length(missingyears) == 0) return(x)
  lastyear <- paste0("y", max(getYears(x, as.integer = TRUE)))
  out <- x[, c(getYears(x), rep(lastyear, length(missingyears))), ]
  getYears(out) <- c(getYears(x), missingyears)
  return(out)
}
