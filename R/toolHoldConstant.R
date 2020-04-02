#' @title toolHoldConstant
#' @description Holds a historical dataset constant for the entire period \code{years}.
#'
#' @param x MAgPIE object to be continued.
#' @param years years for which the data should exist (hold constant, if missing)
#' @return MAgPIE object with completed time dimensionality.
#' @author Benjamin Leon Bodirsky, Jan Philipp Dietrich
#' @importFrom magclass getYears setYears add_columns
#' @export

toolHoldConstant <-function(x, years){
  missingyears <- setdiff(years,getYears(x))
  if(length(missingyears)==0) return(x)
  out <- add_columns(x = x,addnm = missingyears,dim = 2.1)
  lastyear <- paste0("y",max(getYears(x,as.integer = TRUE)))
  out[,missingyears,] <- setYears(out[,lastyear,],NULL)
  return(out)
}
