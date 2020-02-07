#' Returns levels for specified experimental treatment
#'
#' @param database A list with the SIDb structure
#' @param treatment experimental treatment of interest. Must be entered in
#'  quotes.
#' @param units units for experimental treatment of interest
#' @return list of treatment levels for specified treatment
#' @details Recommended to run the functions \link[sidb]{treatmentNames} and
#'  \link[sidb]{treatmentUnitNames} first to view possible options for the
#'  "treatment" and "units" parameters.
#' @export
#' @examples
#' # return temperature levels from all entries
#' treatmentLevels(sidb, "temperature")
#' # return moisture levels from all entries
#' treatmentLevels(sidb, "moisture")
#' # return moisture levels from all entries with units "percentFieldCapacity"
#' treatmentLevels(sidb, "moisture", "percentFieldCapacity")

treatmentLevels <- function(database, treatment, units=NA) {

  # get values for specific treatment in variables list
  varTreatLevels <- function(database, treatment) {
    unique(unlist(lapply(database, function(z) {
    unique(unlist(lapply(z$variables[2:length(z$variables)], function(x) unlist(x[treatment]))))
  })))
  }

  # get values for specific treatment in incubationInfo list
  incInfoTreatLevels <- function(database, treatment) {
    li <- unique(unlist(lapply(database, function(z) {
      ifelse(length(z$incubationInfo[[which(names(z$incubationInfo)==treatment)]]) == 0, NA,
             ifelse(length(z$incubationInfo[[which(names(z$incubationInfo)==treatment)]]) == 1,
                    z$incubationInfo[[which(names(z$incubationInfo)==treatment)]],
                    z$incubationInfo[[which(names(z$incubationInfo)==treatment)]]["value"]))

      })))
    return(li[which(!is.na(li))])
  }

  # first filter database for units if needed
  if(is.na(units)) {
    return(sort(unique(c(varTreatLevels(database, treatment), incInfoTreatLevels(database, treatment)))))
  } else {
    # filter database by units before running varTreatLevels
    correctUnits <- names(Filter(function(z) is.list(z),
                                 lapply(database, function(x) {
                                   ifelse(is.na(x[["incubationInfo"]][[treatment]][["units"]]),
                                          character(),
                                          ifelse(x[["incubationInfo"]][[treatment]][["units"]]==units,
                                                 x,
                                                 character())
                                   )
                                 })
    ))

    filteredDatabase <- database[match(correctUnits, names(database))]
    return(sort(unique(c(varTreatLevels(filteredDatabase, treatment), incInfoTreatLevels(filteredDatabase, treatment)))))
  }
}
