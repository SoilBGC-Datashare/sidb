#' Fits a two-pool microbial model to a time series of incubation data
#'
#' @param timeSeries A time series of respiration values
#' @param initialCarbon The initial amount of carbon in units that correspond to the time series data
#' @param inipars vector of parameter values for the initial search of the optimization algorithm
#' @return R list with an FME model object, a SoilR model object, and the AIC value
#' @export
#' @import FME
#' @examples
#' \donttest{
#' incubation=sidb[["Crow2019a"]]
#' a=twopMMFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000)
#' }
twopMMFit=function(timeSeries, initialCarbon, inipars=c(0.001, 0.005, 1, 0.5, 0.5)){
  complete=data.frame(time=timeSeries[complete.cases(timeSeries),1],Rt=timeSeries[complete.cases(timeSeries),2])
  n=nrow(complete)
  if(n < 8) stop("Time series is too short. No degrees of freedom")
  tt=seq(from=0, to=tail(complete[,1],1), length.out = 500)

  Func=function(pars){
    mod=SoilR::TwopMMmodel(t=tt,ks=pars[1], kb=pars[2], Km=pars[3], r=pars[4], Af=3, ival=initialCarbon*c(pars[5], 1-pars[5]), ADD=0)
#    Rt=SoilR::getAccumulatedRelease(mod)
    Rt=SoilR::getReleaseFlux(mod)
    return(data.frame(time=tt, Rt=rowSums(Rt)))
  }

  costFunc=function(pars){
    output=Func(pars)
    return(modCost(model=output, obs=complete))
  }

  Fit=modFit(f=costFunc, p=inipars, method="Marq", lower=rep(0,5), upper=c(1, 1, Inf, 1, 1))
  bestMod=Func(pars=Fit$par)
  plot(complete, ylim=c(0,1.2*max(complete[,2])))
  lines(bestMod)
  AIC=(2*length(Fit$par))+2*log(Fit$ms)
  SoilRmodel=SoilR::TwopMMmodel(t=tt,ks=Fit$par[1], kb=Fit$par[2], Km=Fit$par[3], r=Fit$par[4], Af=3, ival=initialCarbon*c(Fit$par[5], 1-Fit$par[5]), ADD=0)
  return(list(FMEmodel=Fit, SoilRmodel=SoilRmodel, AIC=AIC))
}
