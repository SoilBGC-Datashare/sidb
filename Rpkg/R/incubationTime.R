#' Returns the incubation time of the entries in the database
#'
#' @param database A list with the sidb
#' @return A data.frame of incubation times and their units
#' @export
#' @examples
#' sidb=loadEntries(path="~/sidb/data/")
#' incubTimes=incubationTime(database=sidb)
incubationTime <- function(database) {
  time=lapply(database, FUN=function(x){x$incubationInfo$incubationTime})
  return(unlist(time))
}


