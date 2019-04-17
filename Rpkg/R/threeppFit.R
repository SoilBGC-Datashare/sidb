#' Fits a three pool model with parallel structure to a time-series
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
#' a=threeppFit(timeSeries = db[["Crow2019a"]]$timeSeries[,c(1,5)], initialCarbon=db[["Crow2019a"]]$initConditions[4,"carbonMean"]*10000)
threeppFit=function(timeSeries, initialCarbon, inipars=c(-1,-0.5, -0.5, 0.5, 0.5)){
  complete=data.frame(time=timeSeries[complete.cases(timeSeries),1],Rt=cumsum(timeSeries[complete.cases(timeSeries),2]))
  n=nrow(complete)
  if(n < 6) stop("Time series is too short. No degrees of freedom")
  tt=seq(from=0, to=tail(complete[,1],1), length.out = 500)

  Func=function(pars){
    mod=ThreepParallelModel(t=tt,ks=pars[1:3], C0=initialCarbon*c(pars[4], pars[4]*pars[5], 1-sum(pars[4:5])), In=0, gam1=0, gam2=0)
    Rt=getAccumulatedRelease(mod)
    return(data.frame(time=tt, Rt=rowSums(Rt)))
  }

  costFunc=function(pars){
    output=Func(pars)
    return(modCost(model=output, obs=complete))
  }
  #inipars=c(-1,-0.5, -0.5, 0.5, 0.5)
  Fit=modFit(f=costFunc, p=inipars, method="Marq", lower=c(-Inf,-Inf,-Inf,0,0), upper=c(0, 0, 0, 1, 1))
  bestMod=Func(pars=Fit$par)
  print(paste(c("k1=", "k2=", "k3=","proportion of C0 in pool 1=", "Proportion of C0 in pool 2="),c(Fit$par[1:4], Fit$par[4]*Fit$par[5])))
  plot(complete, ylim=c(0,1.2*max(complete[,2])))
  lines(bestMod)
  AIC=(2*5)-2*log(Fit$ms)
  print(paste("AIC = ",AIC))
  SoilRmodel=ThreepParallelModel(t=tt,ks=Fit$par[1:3], C0=initialCarbon*c(Fit$par[4], Fit$par[4]*Fit$par[5], 1-sum(Fit$par[4:5])), In=0, gam1=0, gam2=0)
  return(list(FMEmodel=Fit, SoilRmodel=SoilRmodel, AIC=AIC))
}
