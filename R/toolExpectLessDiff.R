#' toolExpectLessDiff
#'
#' tool function for status reporting. It performs a difference check between
#' two objects and returns either a message via \code{toolStatusMessage}, that
#' the test was successful or that it failed.
#'
#' @param x object 1
#' @param y object 2 which has the same format as object 1
#' @param maxdiff allowed maximum difference per element between x and y.
#' @param description a description of the check
#' @param level as the test result will be linked to a function call, the function
#' needs to know to which call it should be linked. by default (\code{level = 0}) the parent
#' function call is being used. Increasing the number by one will let the function go
#' up by one in the call stack, \code{level = -1} will use \code{toolExpectTrue} itself as
#' function call.
#' @param maxdiff2 optional additional threshold. If set it will serve as a second, critial threshold
#' which will throw a warning (instead of a simple note in case of \code{maxdiff}) if being surpassed.
#' @author Jan Philipp Dietrich
#' @seealso \code{\link{getMadratMessage}}, \code{\link{toolExpectTrue}}, \code{\link{toolStatusMessage}}
#' @examples
#' toolExpectLessDiff(1:3, 2:4, 10, "data is sufficiently close", level = -1)
#' getMadratMessage("status")
#' @export

toolExpectLessDiff <- function(x, y, maxdiff, description, level = 0, maxdiff2 = NULL) {
  value <- max(abs(x - y))
  descriptionFull <- paste0(description, " (maxdiff = ", format(value, digits = 2),
                        ", threshold = ", format(maxdiff, digits = 2), ")")
  passed <- toolExpectTrue(value <= maxdiff, descriptionFull, level = level + 1)
  if(!is.null(maxdiff2)) {
    descriptionFull <- paste0(description, " (maxdiff = ", format(value, digits = 2),
                          ", critical threshold = ", format(maxdiff2, digits = 2), ")")
    passed <- toolExpectTrue(value <= maxdiff2, descriptionFull, level = level + 1, falseStatus = "warn")
  }
}
