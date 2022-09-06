#' @title toolIsocode2Country
#' @description Translate iso country code to country names
#'
#' @param x Array of iso country codes
#' @return return array of country names
#' @author Kristine Karstens
#'
#' @importFrom utils read.csv2
#' @export

toolIsocode2Country <- function(x) {

  iso2Country <- read.csv2(system.file("extdata", "iso_country.csv",
                                       package = "madrat"), row.names = NULL,
                           encoding = "UTF-8")
  noIso       <- which(!(x %in% iso2Country[, 2]))

  if (length(noIso) != 0) {
    cat("Following items are no iso country code: ", x[noIso],
        ". They will be returned unmodifed.\n")
    toMod <- x[-noIso]

  } else {
    toMod <- x
  }

  for (i in noIso) {
    Mod <- append(Mod, x[i], i - 1)
  }

  if (length(x) == length(Mod)) return(Mod)
  else stop("Something went wrong.")
}
