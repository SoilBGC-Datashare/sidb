#' Fits a three pool model with parallel structure to a time series
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
#' a=threeppFit(timeSeries = incubation$timeSeries[,c(1,79)],
#' initialCarbon=incubation$initConditions[78,"carbonMean"]*10000,
#' inipars = c(0.05, 0.01, 0.001, 0.1, 0.1))
#' }
threeppFit=function(timeSeries, initialCarbon, inipars=c(1, 0.5, 0.5, 0.5, 0.5)){
#  complete=data.frame(time=timeSeries[complete.cases(timeSeries),1],Rt=cumsum(timeSeries[complete.cases(timeSeries),2]))
  complete=data.frame(time=timeSeries[complete.cases(timeSeries),1],Rt=timeSeries[complete.cases(timeSeries),2])
  n=nrow(complete)
  if(n < 6) stop("Time series is too short. No degrees of freedom")
  tt=seq(from=0, to=tail(complete[,1],1), length.out = 500)

  Func=function(pars){
    mod=SoilR::ThreepParallelModel(t=tt,ks=pars[1:3], C0=initialCarbon*c(pars[4], pars[5], 1-sum(pars[4:5])), In=0, gam1=0, gam2=0)
#    Rt=SoilR::getAccumulatedRelease(mod)
    Rt=SoilR::getReleaseFlux(mod)
    return(data.frame(time=tt, Rt=rowSums(Rt)))
  }

  costFunc=function(pars){
    output=Func(pars)
    return(modCost(model=output, obs=complete))
  }

  Fit=modFit(f=costFunc, p=inipars, method="Marq", lower=rep(0,5), upper=c(3, 3, 3, 1, 1))
  bestMod=Func(pars=Fit$par)
  print(paste(c("k1=", "k2=", "k3=","proportion of C0 in pool 1=", "Proportion of C0 in pool 2="),Fit$par[1:4]))
  plot(complete, ylim=c(0,1.2*max(complete[,2])))
  lines(bestMod)
  AIC=(2*length(Fit$par))+2*log(Fit$ms)
  print(paste("AIC = ",AIC))
  SoilRmodel=SoilR::ThreepParallelModel(t=tt,ks=Fit$par[1:3], C0=initialCarbon*c(Fit$par[4], Fit$par[5], 1-sum(Fit$par[4:5])), In=0, gam1=0, gam2=0)
  return(list(FMEmodel=Fit, SoilRmodel=SoilRmodel, AIC=AIC))
}
