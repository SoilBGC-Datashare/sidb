#' Fits a one pool model to a time-series to obtain the vector of release fluxes out of the pools for all times
#'
#' @param timeSeries A time series of respiration values over time
#' @param initialCarbon The initial amount of carbon in units that correspond to the time series data
#' @return R list with an FME model object, a SoilR model object, and the AIC value
#' @export
#' @import FME
#' @import graphics
#' @importFrom utils tail
#' @importFrom stats complete.cases
#' @examples
#' a=onepFitFlux(timeSeries = sidb[[19]]$timeSeries[,1:2],
#' initialCarbon=sidb[[19]]$initConditions[1,"carbonMean"]*10)
onepFitFlux=function(timeSeries, initialCarbon){
  complete=data.frame(time=timeSeries[complete.cases(timeSeries),1],Rt=timeSeries[complete.cases(timeSeries),2])
  n=nrow(complete)
  if(n < 3) stop("Time series is too short. No degrees of freedom")
  tt=seq(from=0, to=tail(complete[,1],1), length.out = 500)
  
  Func=function(pars){
    mod=SoilR::OnepModel(t=tt,k=pars[1], C0=initialCarbon, In=0)
    Rt=SoilR::getReleaseFlux(mod)
    return(data.frame(time=tt, Rt=Rt))
  }
  
  costFunc=function(pars){
    output=Func(pars)
    return(modCost(model=output, obs=complete))
  }
  inipars=(complete[1,2]/initialCarbon)
  Fit=modFit(f=costFunc, p=inipars, method="Marq", lower= -Inf, upper=0)
  bestMod=Func(pars=Fit$par)
  print(paste("Best fit parameter: ",Fit$par))
  plot(complete, ylim=c(0,1.2*max(complete[,2])))
  lines(bestMod)
  AIC=2-2*log(Fit$ms)
  print(paste("AIC = ",AIC))
  SoilRmodel=SoilR::OnepModel(t=tt,k=Fit$par[1], C0=initialCarbon, In=0)
  return(list(FMEmodel=Fit, SoilRmodel=SoilRmodel, AIC=AIC))
}


