#' toolStatisticsOutput
#' @export

toolStatisticsOutput <- function(data, callString, nameOfStatistics = "summary") {
  statistics <- list()
  if (nameOfStatistics == "summary") {
    statistics <- as.list(summary(data))
    names(statistics) <- list("Min." = "min", "Max." = "max",
                              "1st Qu." = "firstQuantile", "Median" = "median",
                              "Mean" = "mean", "3rd Qu." = "thirdQuantile")[names(statistics)]
  } else if (nameOfStatistics == "sum") {
    statistics <- sum(data)
  }

  vcat(1, paste0("[statistics] ", nameOfStatistics, ": ", paste0(as.character(statistics), collapse = ", ")), show_prefix = FALSE)
  putMadratMessage("status",
                   list("function" = nameOfStatistics, "type" = "statistic", "data" = statistics),
                   fname = callString,
                   add = TRUE)
}
