packs <- c('SoilR', 'sidb', 'R.utils', 'FME')
sapply(packs, require, character.only=TRUE)
devtools::install_github('SoilBGC-Datashare/sidb/Rpkg', build_vignettes = TRUE, force=TRUE)

rm(list=ls())

db=loadEntries(path="~/sidb/data/")
db_flat=flatterSIDb(db)

twopp_inipars= c(0.01, 0.001, 0.1)
twops_inipars= c(0.005, 0.00001, 0.1, 0.01)
twopf_inipars= c(0.005, 0.00001, 0.1, 0.01, 0.01)

iniC_C7.5=db[[4]]$initConditions[1, "carbonMean"]

source.R <- file.path('sidb/Rpkg/R/onepFitFlux.R')
sourceDirectory(source.R, modifiedOnly = TRUE, verbose = TRUE)


Mod0_42=onepFitFlux(timeSeries = db[[4]]$timeSeries[, c(1,2)], initialCarbon = iniC_C7.5*1e4)
Mod1_42=twoppFit(timeSeries = db[[4]]$timeSeries[, c(1,2)], initialCarbon =iniC_C7.5*1e4 , inipars = twopp_inipars)
Mod2_42=twopfFit(timeSeries = db[[4]]$timeSeries[, c(1,2)], initialCarbon =iniC_C7.5*1e4 , inipars = twopf_inipars)
Mod3_42=twopsFit(timeSeries = db[[4]]$timeSeries[, c(1,2)], initialCarbon =iniC_C7.5*1e4 , inipars = twops_inipars)

##########transitTime########
a=Mod1_42$SoilRmodel@mat@map()
gam=Mod1_42$FMEmodel$par[3]

gam=0.7
tt1= transitTime(A = a, u =c(gam, 1-gam), q = 0.5, a = 0)

a2=Mod2_42$SoilRmodel@mat@map()
tt2=transitTime(A = a2, u = c(1, 0), q=0.5, a=0)

a3=Mod3_42$SoilRmodel@mat@map()
tt3=transitTime(A=a3, u=c(1, 0), q=0.5, a=0)

tt1$meanTransitTime
tt2$meanTransitTime
tt3$meanTransitTime




ds=db[[4]]$timeSeries[, c(1,2)]
kk=-1*iniC_C7.5/ds[1,2]
kk


K1=length(Mod1_42$FMEmodel$par)
K2=length(Mod2_42$FMEmodel$par)
K3=length(Mod3_42$FMEmodel$par)
n=nrow(db[[4]]$timeSeries)

AICc1=Mod1_42$AIC+( (2*K1*(K1+1))/(n-K1-1))
AICc2=Mod2_42$AIC+( (2*K2*(K2+1))/(n-K2-1))
AICc3=Mod3_42$AIC+( (2*K3*(K3+1))/(n-K3-1))
AICc=c(AICc1, AICc2, AICc3)
min(AICc)

Delta1=AICc1-AICc1 
Delta2=AICc2-AICc1
Delta3=AICc3-AICc1
Delta=c(Delta1,Delta2, Delta3 )

w1= exp(-0.5*Delta1)/(exp(-0.5*Delta1) + exp(-0.5*Delta2) + exp(-0.5*Delta3))
w2= exp(-0.5*Delta2)/(exp(-0.5*Delta1) + exp(-0.5*Delta2) + exp(-0.5*Delta3))
w3= exp(-0.5*Delta3)/(exp(-0.5*Delta1) + exp(-0.5*Delta2) + exp(-0.5*Delta3))
w=c(w1, w2, w3)

days42=Mod1_42$SoilRmodel@times
Mlist42=list(Mod0_42 ,Mod1_42, Mod2_42, Mod3_42)

Rs42=sapply(Mlist42, function(x){rowSums(getReleaseFlux(x$SoilRmodel))})

modelNames42=c("One-pool","Two-pool parallel" ,"Two-pool feedback", "Two-pool series")
Rt42=lapply(Mlist42, function(x){getReleaseFlux(x$SoilRmodel)})

par(mfrow=c(2,2))
for(i in c(1:4)){
  matplot(days42, Rt42[[i]], type="l", lty = 1, ylab = db[[4]]$variables$V2$units, xlab="Day", 
          main=modelNames42[i])
  points(db[[4]]$timeSeries[, c(1,2)], pch=19, cex=0.5)
}
par(mfrow=c(1,1))


aic=sapply(Mlist42, function(x){AIC=x$AIC})
AIC_Weights=c(w1, w2, w3)
k1=sapply(Mlist42, function(x){x$FMEmodel$par[1]})
k2=sapply(Mlist42, function(x){x$FMEmodel$par[2]})

pC0= c(Mod1_42$FMEmodel$par[3], Mod2_42$FMEmodel$par[5], Mod3_42$FMEmodel$par[4])
a21=c(NA, Mod2_42$FMEmodel$par[3], Mod3_42$FMEmodel$par[3])
a12=c(NA, Mod2_42$FMEmodel$par[4], NA)
tbldb <- data.frame(model=modelNames42, AIC=aic, WeightedAIC=AIC_Weights, k1=k1, k2=k2, "Proportion of C0 in pool 1"=pC0, a21=a21, a12=a12)

knitr::kable(tbldb)
#############################
K=sapply(Mlist42, function(x){length(x$FMEmodel$par)})
K=list(K1, K2, K3)
AIC=sapply(Mlist42, function(x) x$AIC)
AICc=list(NULL)
for (i in 1:length(Mlist42)){
  AICc[[i]]=AIC[[i]]+( (2*K[[i]]*(K[[i]]+1))/(n-K[[i]]-1))
  }
AICcmin=min(unlist(AICc) )
delta_i=list(NULL)
for(i in 1:length(AICc)){
  delta_i[[i]]=AICc[[i]]-AICcmin
}
exp(-0.5* delta_i[[1]])

wi=list(NULL)
for(i in 1:length(delta_i)){
  wi[[i]]=exp(-0.5 * delta_i[[i]])/(exp(-0.5* delta_i[[1]]) + exp(-0.5*delta_i[[2]]) + exp(-0.5*delta_i[[3]]) )
}

tbl= data.frame(model=modelNames42, AIC=AIC, AICc= unlist(AICc),w=w, wi=unlist(wi))
knitr::kable(tbl)

###########################
######Crow2019a######
Mod0_92=onepFitFlux(timeSeries = db[[9]]$timeSeries[, c(1,2)], initialCarbon =db[[9]]$initConditions[1, 'carbonMean']*1e4)
Mod1_92=twoppFit(timeSeries = db[[9]]$timeSeries[, c(1,2)], initialCarbon =db[[9]]$initConditions[1, 'carbonMean']*1e4 , inipars = twopp_inipars)
Mod2_92=twopfFit(timeSeries = db[[9]]$timeSeries[, c(1,2)], initialCarbon =db[[9]]$initConditions[1, 'carbonMean']*1e4 , inipars = twopf_inipars)
Mod3_92=twopsFit(timeSeries = db[[9]]$timeSeries[, c(1,2)], initialCarbon =db[[9]]$initConditions[1, 'carbonMean']*1e4 , inipars = twops_inipars)

K1_9=length(Mod1_92$FMEmodel$par)
K2_9=length(Mod2_92$FMEmodel$par)
K3_9=length(Mod3_92$FMEmodel$par)
n9=nrow(db[[9]]$timeSeries)

AICc1_9=Mod1_92$AIC+( (2*K1_9*(K1_9+1))/(n9-K1_9-1))
AICc2_9=Mod2_92$AIC+( (2*K2_9*(K2_9+1))/(n9-K2_9-1))
AICc3_9=Mod3_92$AIC+( (2*K3_9*(K3_9+1))/(n9-K3_9-1))
AICc_9=c(AICc1_9, AICc2_9, AICc3_9)
min(AICc_9)

Delta1_9=AICc1_9-AICc1_9  #AICc_i- AICc_min  
Delta2_9=AICc2_9-AICc1_9
Delta3_9=AICc3_9-AICc1_9

w19= exp(-0.5*Delta1_9)/(exp(-0.5*Delta1_9)+exp((-0.5*Delta2_9)+exp(-0.5*Delta3_9)))
w29= exp(-0.5*Delta2_9)/(exp(-0.5*Delta1_9)+exp((-0.5*Delta2_9)+exp(-0.5*Delta3_9)))
w39= exp(-0.5*Delta3_9)/(exp(-0.5*Delta1_9)+exp((-0.5*Delta2_9)+exp(-0.5*Delta3_9)))

days92=Mod1_92$SoilRmodel@times
Mlist92=list(Mod0_92, Mod1_92, Mod2_92, Mod3_92)

Rs92=sapply(Mlist92, function(x){rowSums(getReleaseFlux(x$SoilRmodel))})

modelNames92=c("Two-pool parallel" ,"Two-pool feedback", "Two-pool series")
Rt92=lapply(Mlist92, function(x){getReleaseFlux(x$SoilRmodel)})

par(mfrow=c(2,2))
for(i in c(1:3)){
  matplot(days92, Rt92[[i]], type="l", lty = 1, ylab = db[[9]]$variables$V2$units, xlab="Day", 
          main=modelNames92[i])
  points(db[[9]]$timeSeries[, c(1,2)], pch=19, cex=0.5)
}
par(mfrow=c(1,1))


aic_9=sapply(Mlist92, function(x){AIC=x$AIC})
AIC_Weights9=c(w19, w29, w39)
k19=sapply(Mlist92, function(x){x$FMEmodel$par[1]})
k29=sapply(Mlist92, function(x){x$FMEmodel$par[2]})

pC0_9= c(Mod1_92$FMEmodel$par[3], Mod2_92$FMEmodel$par[5], Mod3_92$FMEmodel$par[4])
a21_9=c(NA, Mod2_92$FMEmodel$par[3], Mod3_92$FMEmodel$par[3])
a12_9=c(NA, Mod2_92$FMEmodel$par[4], NA)
tbldb9 <- data.frame(model=modelNames92, AIC=aic_9, WeightedAIC=AIC_Weights9, k1=k19, k2=k29, "Proportion of C0 in pool 1"=pC0_9, a21=a21_9, a12=a12_9)

knitr::kable(tbldb9)
