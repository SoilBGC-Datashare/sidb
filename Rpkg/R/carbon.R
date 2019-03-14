#' Creates a data frame with the carbon content in soil samples
#'
#' @param database A list with the sidb
#' @return A data.frame with the carbon content and the units of the soil samples from the database
#' @export
#' @examples
#' C=carbon(database=sidb)
carbon= function(database){
  mean=lapply(database, FUN=function(x){x$initConditions$carbonMean})
  units=lapply(database, FUN=function(x){
    as.character(x$initConditions$carbonUnits)})
  return(data.frame(carbon=unlist(mean) , units=unlist(units) 
  ))
}