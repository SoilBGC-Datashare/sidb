#' Soil incubation data included in the R package
#'
#' A dataset containing the time series of respired carbon from incubation experiments and associeted metadata
#'
#' @format A list with metadata, time series, and initial conditions. Each database entry contains:
#' \describe{
#'   \item{metadata}{This is a list with metadata associated with the entry}
#'   \item{timeSeries}{A data.frame with time series of respiration fluxes}
#'   \item{initConditions}{A data.frame with details of the initial conditions of the experiment}
#' }
#' @source \url{https://github.com/SoilBGC-Datashare/sidb/tree/master/data}
"sidb"

