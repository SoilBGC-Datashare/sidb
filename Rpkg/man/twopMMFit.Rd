% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/twopMMFit.R
\name{twopMMFit}
\alias{twopMMFit}
\title{Fits a two-pool microbial model to a time series of incubation data}
\usage{
twopMMFit(timeSeries, initialCarbon, inipars = c(0.001, 0.005, 1, 0.5, 0.5))
}
\arguments{
\item{timeSeries}{A time series of respiration values}

\item{initialCarbon}{The initial amount of carbon in units that correspond to the time series data}

\item{inipars}{vector of parameter values for the initial search of the optimization algorithm}
}
\value{
R list with an FME model object, a SoilR model object, and the AIC value
}
\description{
Fits a two-pool microbial model to a time series of incubation data
}
\examples{
\donttest{
incubation=sidb[["Crow2019a"]]
a=twopMMFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000)
}
}
