#' Creates an aggregated vector with a specific laboratory treatment
#'
#' @param database A list with the SIDb structure
#' @param treatment A character vector with the name of the treatment to be extracted
#' @return A vector with all values of the specified treatment from the database
#' @export
#' @examples
#' temperature=laboratoryTreatment(database=sidb, treatment="temperature")
laboratoryTreatment <- function(database, treatment) {
  treatfunc=function(x){
  li=x$incubationInfo$laboratoryTreatment
  li[[as.character(treatment)]]$value
  }

  a=lapply(database, FUN=treatfunc)
 return(unlist(a))
}
