#' Returns names of all treatments found in supplied database
#'
#' @param database a list with the SIDb structure
#' @return list of unique treatment names
#' @details This function looks for unique field names in the variables and
#'  incubationInfo lists in an object with a SIDb-like structure, e.g.
#'  \link[sidb]{sidb}. Fields that are not considered "treatments" are excluded.
#'   Specifically: "name", "varDesc", "site", "gasMeasured", "units", and
#'  "primaryVariable".
#' @export
#' @examples
#' # return temperature levels from all entries
#' treatmentLevels(sidb, "temperature")
#' # return moisture levels from all entries
#' treatmentLevels(sidb, "moisture")
#' # return moisture levels from all entries with units "percentFieldCapacity"
#' treatmentLevels(sidb, "moisture", "percentFieldCapacity")

treatmentNames <- function(database) {

  # exclude non-treatment missingFields
  base.vars <- c("name", "varDesc", "site", "gasMeasured", "units", "primaryVariable")
  # Return all unique treatments reported in variables list
  varTreat <- unique(unlist(lapply(database, function(z) {
    unique(unlist(lapply(z$variables[2:length(z$variables)], function(x) {
      names(x)[which(is.na(match(names(x), base.vars)))]
    })))
  })))

  # Return all unique treatments reported in incubationInfo list
  incInfoTreat <- unique(unlist(lapply(database, function(z) {
    names(z$incubationInfo)[-which(names(z$incubationInfo)=="incDesc")]
  })))

  return(sort(unique(c(varTreat,incInfoTreat))))
}
