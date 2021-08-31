df=db[[24]]$timeSeries[, 1:2]
iniC=db[[24]]$initConditions[1, "carbonMean"]*10

df=data.frame(time=df[complete.cases(df),1], Rt=df[complete.cases(df),2])
plot(df)
tt=seq(from=0, to=tail(df[,1],1), length.out = 500)
Func0=function(pars){
  mod=SoilR::OnepModel(t=tt, k=pars[1], C0=iniC, In=0)
  Rt=SoilR::getReleaseFlux(mod)
  return(data.frame(time=tt, Rt=Rt))
}
costFunc0=function(pars){
  output=Func(pars)
  return(modCost(model = output, obs = df))
}
Fit0=modFit(f=costFunc, p=-0.5, method="Marq", lower=-Inf, upper = 0)
bestMod0=Func(pars = Fit0$par)

par(mfrow=c(2,2))
plot(df,ylim=c(0,1.2*max(df[,2])), main="One-pool Model")
lines(bestMod)
###########################
Func1=function(pars){
  mod=SoilR::TwopParallelModel(t = tt, ks=pars[1:2], 
                               C0=iniC*c(pars[3], 1-pars[3]), 
                               In=0, gam=0)
  Rt=SoilR::getReleaseFlux(mod)
  return(data.frame(time=tt, Rt=rowSums(Rt)))
}
costFunc1=function(pars){
  output=Func(pars)
  return(modCost(model = output, obs=df) )
}
inipars=c(0.1, 0.05, 0.7)
Fit1=modFit(f=costFunc1, p=inipars, method="Marq", lower =rep(0,3), upper = c(Inf, Inf, 1))
bestmod1=Func1(pars = Fit1$par)
plot(df, ylim=c(0,1.2*max(df[,2])), main="Two-pool Parallel")
lines(bestmod1)
###########################
Func2=function(pars){
  mod=SoilR::TwopFeedbackModel(t = tt, ks=pars[1:2], 
                               a21=pars[1]*pars[3], 
                               a12=pars[2]*pars[4],
                               C0=iniC*c(pars[5], 1-pars[5]), 
                               In=0)
  Rt=SoilR::getReleaseFlux(mod)
  return(data.frame(time=tt, Rt=rowSums(Rt)) )
}
costFunc2=function(pars){
  output=Func2(pars)
  return(modCost(model = output, obs=df) )
}
inipars2= c(0.1, 0.01, 0.01,0.01, 0.1 )#c(1, 0.5, 0.5, 0.5, 0.1)
Fit2=modFit(f=costFunc2, p=inipars2, method="Marq", lower =rep(0,5), upper = c(Inf, Inf, 1,1,1))
bestmod2=Func2(pars = Fit2$par)
plot(df, ylim=c(0,1.2*max(df[,2])), main="Two-pool feedback")
lines(bestmod2)
###########################
# c(0.01, 0.001, 0.1),
# c(5e-03, 1e-05, 0.1, 0.01, 0.01), 
# c(5e-03, 1e-05, 0.1, 0.01))
####################
Func3=function(pars){
  mod=SoilR::TwopSeriesModel(t=tt,ks=pars[1:2], 
                             a21=pars[1]*pars[3], 
                             C0=iniC*c(pars[4], 1-pars[4]), In=0)
                             #    Rt=SoilR::getAccumulatedRelease(mod)
                             Rt=SoilR::getReleaseFlux(mod)
                             return(data.frame(time=tt, Rt=rowSums(Rt)))
}
costFunc3=function(pars){
  output=Func3(pars)
  return(modCost(model=output, obs=df))
}
inipars3=c(0.1, 0.01, 0.01, 0.1)
Fit3=modFit(f=costFunc3, p=inipars3, method="Marq", lower=rep(0,4), upper=c(Inf, Inf, 1,1))
bestMod3=Func3(pars=Fit3$par) 
plot(df, ylim=c(0,1.2*max(df[,2])), main="Two-pool series")
lines(bestMod3)


# list.files(".", pattern=".csv")
#############
# Workflow 24/08/2021
# solve the problem with one-pool model
# run the models and store the data in a list

onepool=function(timeSeries, initialCarbon){
  complete=data.frame(time=timeSeries[complete.cases(timeSeries),1],Rt=timeSeries[complete.cases(timeSeries),2])
  n=nrow(complete)
  if(n < 6) stop("Time series is too short. No degrees of freedom")
  tt=seq(from=0, to=tail(complete[,1],1), length.out = 500)
  
  Func=function(pars){
    mod=SoilR::OnepModel(t=tt,k=pars[1], C0=initialCarbon, In=0)
    Rt=SoilR::getReleaseFlux(mod)
    return(data.frame(time=tt, Rt=Rt))
  }
  
  costFunc=function(pars){
    output=Func(pars)
    return(FME::modCost(model=output, obs=complete))
  }
  
  # if(is.na(complete[1,2])){inipars=(complete[2,2]/initialCarbon)}
  # else
  #   inipars=(complete[1,2]/initialCarbon)
  #inipars=complete[1,2]/initialCarbon #c(-1*initialCarbon/complete[1,2])
  Fit=modFit(f=costFunc, p=-0.5, method="Marq", lower= -Inf, upper=100)
  bestMod=Func(pars=Fit$par)
  print(paste("Best fit parameter: ",Fit$par))
  plot(complete, ylim=c(0,1.2*max(complete[,2])))
  lines(bestMod)
  AIC=2-2*log(Fit$ms)
  print(paste("AIC = ",AIC))
  SoilRmodel=SoilR::OnepModel(t=tt,k=Fit$par[1], C0=initialCarbon, In=0)
  return(list(FMEmodel=Fit, SoilRmodel=SoilRmodel, AIC=AIC))
}


df <- db[[24]]
ts=df$timeSeries
time=seq(from=0 , to=tail(ts[,1],1), length.out = 500)
iniC=df$initConditions[1, 'carbonMean']

mod0=onepool(timeSeries = ts[,c(1,2)], initialCarbon = iniC*10)
mod1=twoppFit(timeSeries = ts[, c(1,2)], initialCarbon = iniC*10, inipars = c(0.05, 0.005, 0.1))
mod2=twopsFit(timeSeries = ts[, c(1,2)], initialCarbon = iniC*10, inipars = c(0.1, 0.0005, 0.1, 0.01) )
mod3=twopfFit(timeSeries = ts[, c(1,2)], initialCarbon = iniC*10, inipars =c(0.05, 0.001, 0.01, 0.01, 0.01))

days=mod1$SoilRmodel@times
Mlist=list(mod0, mod1, mod2, mod3)
modelNames=c("One-pool","Two-pool parallel" ,"Two-pool feedback", "Two-pool series")            
Rt=lapply(Mlist, function(x){getReleaseFlux(x$SoilRmodel)})
par(mfrow=c(2,2))
for(i in c(1:4)){
  matplot(days, Rt[[i]], type="l", lty = 1, 
          ylab=db[[24]]$variables$V2$units, xlab = "Day", main=modelNames[i])
  points(days, ts[,2], )
}
matplot(days, Rt[[4]], type = "l")
points(days, ts[, c(1,2)], pch=19, cex=0.5)
par(mfrow=c(1,1))

plot(ts[,2])

