#' Returns the incubation time of the entries in the database
#'
#' @param database A list with the SIDb structure
#' @return A data frame of incubation times and their units
#' @export
#' @examples
#' incubTimes=incubationTime(database=sidb)
incubationTime <- function(database) {
  time=lapply(database, FUN=function(x){x$incubationInfo$incubationTime})
  return(unlist(time))
}
