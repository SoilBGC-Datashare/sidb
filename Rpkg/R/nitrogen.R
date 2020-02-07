#' Creates a data frame with the nitrogen content of soil samples
#'
#' @param database A list with the SIDb structure
#' @return A data frame with the nitrogen content and the units of the soil samples from the database
#' @export
#' @examples
#' N=nitrogen(database=sidb)
nitrogen = function(database) {
  mean=lapply(database, FUN=function(x){x$initConditions$nitrogenMean})
  units=lapply(database, FUN=function(x){
  as.character(x$initConditions$nitrogenUnits)})
  return(data.frame(nitrogen=unlist(mean), units=unlist(units)
  ))
}
