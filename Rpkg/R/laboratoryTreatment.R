#' Creates an aggregated vector with a specific laboratory treatment
#'
#' @param database A list with the sidb
#' @param treatment A character vector with the treatment to be extracted
#' @return A vector with all values of the treatment from the database
#' @export
#' @examples
#' temperature=laboratoryTreatment(database=sidb, treatment="temperature")
laboratoryTreatment <- function(database, treatment) {
  treatfunc=function(x){
  li=x$incubationInfo$laboratoryTreatment
  li[[as.character(treatment)]]
  }

  a=lapply(si, FUN=treatfunc)
 return(unlist(a))
}


