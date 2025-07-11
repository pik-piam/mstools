#' toolWriteMadratLog
#'
#' Tool function for writing madrat messages to a log file in the YAML format.
#' Useful after running madrat calculations which are performing checks via
#' \code{\link{toolExpectTrue}} or other toolExpect functions.
#' @param checkResults list of check results as returned by \code{\link[madrat]{getMadratMessage}}
#' @param logPath path to the log file to be written
#' @author Pascal Sauer
#' @export
toolWriteMadratLog <- function(checkResults = getMadratMessage("status"), logPath = "status.log") {
  writeLines(yaml::as.yaml(checkResults), logPath)
}
