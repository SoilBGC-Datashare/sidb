#' Fits a two pool model with parallel structure to a time-series
#'
#' @param timeSeries A time series of respiration values over time
#' @param initialCarbon The initial amount of carbon in units that correspond to the time series data
#' @param inipars vector of parameter values for the initial search of the optimization algorithm
#' @return R list with an FME model object, a SoilR model object, and the AIC value
#' @export
#' @import FME
#' @import SoilR
#' @examples
#' db=loadEntries(path="~/sidb/clean/")
#' a=twoppFit(timeSeries = db[[20]]$timeSeries[,1:2], initialCarbon=db[[20]]$initConditions[1,"carbonMean"]*10)
twoppFit=function(timeSeries, initialCarbon, inipars=c(1, 0.5, 0.5)){
#  complete=data.frame(time=timeSeries[complete.cases(timeSeries),1],Rt=cumsum(timeSeries[complete.cases(timeSeries),2]))
  complete=data.frame(time=timeSeries[complete.cases(timeSeries),1],Rt=timeSeries[complete.cases(timeSeries),2])
  n=nrow(complete)
  if(n < 5) stop("Time series is too short. No degrees of freedom")
  tt=seq(from=0, to=tail(complete[,1],1), length.out = 500)

  Func=function(pars){
    mod=TwopParallelModel(t=tt,ks=pars[1:2], C0=initialCarbon*c(pars[3], 1-pars[3]), In=0, gam=0)
#    Rt=getAccumulatedRelease(mod)
    Rt=getReleaseFlux(mod)
    return(data.frame(time=tt, Rt=rowSums(Rt)))
  }

  costFunc=function(pars){
    output=Func(pars)
    return(modCost(model=output, obs=complete))
  }

  Fit=modFit(f=costFunc, p=inipars, method="Marq", lower=rep(0,3), upper=c(Inf, Inf, 1))
  bestMod=Func(pars=Fit$par)
  print(paste(c("k1=", "k2=", "proportion of C0 in pool 1="),Fit$par))
  plot(complete, ylim=c(0,1.2*max(complete[,2])))
  lines(bestMod)
  AIC=(2*length(Fit$par))-2*log(Fit$ms)
  print(paste("AIC = ",AIC))
  SoilRmodel=TwopParallelModel(t=tt,ks=Fit$par[1:2], C0=initialCarbon*c(Fit$par[3], 1-Fit$par[3]), In=0, gam=0)
  return(list(FMEmodel=Fit, SoilRmodel=SoilRmodel, AIC=AIC))
}