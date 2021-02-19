#' @title toolFertilizerDistribution
#' @description Disaggregates fertilizer usage, trying to best match a certain soil nitrogen uptake efficiency (SNUpE). Also used in magpie4 library
#' 
#'
#' @param iteration_max maximum iteration for downscaling
#' @param max_snupe the maximum level of nue or snupe
#' @param mapping mapping used for disaggregation
#' @param from name of from column in mapping
#' @param to name of to column in mapping
#' @param fertilizer total inorganic fertilizer to be distributed on regional leve
#' @param SNUpE Nitrogen use efficiency or SNUPE on regional level which should be matched best possible
#' @param withdrawals nitrogen withdrawals on cell level
#' @param organicinputs non-inroganic fertilizer inputs on cell level
#' @param threshold threshold in Tg Nr until when the distribution counts as converged
#' @return magpie object with fertilizer usage on cell level
#' @author Benjamin Leon Bodirsky
#' @importFrom madrat toolAggregate
#' @importFrom magclass getRegions
#' @export

toolFertilizerDistribution<-function(iteration_max=50, max_snupe=0.85, mapping, from, to, fertilizer, SNUpE, withdrawals, organicinputs, threshold=0.5) {
  
  withdrawals_reg = toolAggregate(withdrawals,dim = 1,rel = mapping,from=from,to=to)
  
  for (iteration in 1:iteration_max){
    cat(paste0(" iteration: ",iteration)," ")
    #cat(paste0(" NUE ",round(NUE["DEU",2010,],2))," ")
    SNUPE_disagg=toolAggregate(SNUpE,rel=mapping,from=to,to=from,partrel=T)
    requiredinputs=withdrawals/SNUPE_disagg
    requiredinputs[is.nan(requiredinputs)]<-0
    excessive_organic = organicinputs - requiredinputs
    excessive_organic[excessive_organic<0] = 0
    
    useable_organic = organicinputs - excessive_organic 
 
    '   
    # negative required fertilizers indicate that organic fertilizers are sufficent to satisfy the needs. 
    requiredfertilizer_nonnegative_country = toolAggregate(requiredfertilizer_nonnegative,rel=mapping,from=from,to=to,partrel=T)
    surplus_fertilizer=fertilizer[getRegions(requiredfertilizer_nonnegative),,]-requiredfertilizer_nonnegative_country
    '
'    message(paste0("  surplus_fertilizer in 2010:",round(sum(abs(surplus_fertilizer)),2),";"))
    cat(paste0("fert: ",fertilizer["SSA","y1995",]))
    cat(paste0("req: ",requiredfertilizer_nonnegative_country["SSA","y1995",]))
    cat(paste0("sur: ",surplus_fertilizer["SSA","y1995",]))
    cat(paste0("snupe: ",SNUpE["SSA","y1995",]))
'
    gap = sum(requiredinputs) - sum(useable_organic) - sum(fertilizer)
    message(paste0("  surplus_fertilizer in 2010:",round(gap, 2),";"))
    if (gap > threshold ){
      useable_organic_reg = toolAggregate(useable_organic,dim = 1,rel = mapping,from=from,to=to) 
      SNUpE = (
        withdrawals_reg
        /(useable_organic_reg + fertilizer)
      )
      SNUpE[is.na(SNUpE)]<-max_snupe
    } else {
      break
    }
  }
  if(gap > threshold){
    cat(1,"fertilizer distribution procedure found no equilibrium")
    cat(1,paste0("remaining gap of ",round(gap,5)))
  }
  #snupe_cell=withdrawals/(organicinputs+requiredfertilizer_nonnegative)
  
  fert = requiredinputs - useable_organic 
  if(abs(sum(fertilizer)-sum(fert))>threshold*1.01){stop("something went wrong")}
  return (fert)
}
