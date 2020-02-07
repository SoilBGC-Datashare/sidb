#' Returns names of units associated with specified treatment
#'
#' @param database a list with the SIDb structure
#' @return list of unique treatment names
#' @export
#' @examples
#' # return moisture units from all entries
#' treatmentUnitNames(sidb, "moisture")
#' # return units of glucose additions from all entries
#' treatmentUnitNames(sidb, "glucose")

treatmentUnitNames <- function(database, treatment) {

  units <- unique(unlist(lapply(database, function(z) {
    ifelse(treatment %in% names(z$incubationInfo),
           ifelse("units" %in% names(z$incubationInfo[[which(names(z$incubationInfo)==treatment)]]),
                  z$incubationInfo[[which(names(z$incubationInfo)==treatment)]]["units"],
                  NA),
           NA)
    })))
  if(length(units[which(!is.na(units))]) == 0) {
    message("No units found\n")
  } else {
    return(units[which(!is.na(units))])
  }
}
