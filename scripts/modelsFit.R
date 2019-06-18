
library(SoilR)
library(sidb)

db=loadEntries(path="~/sidb/clean/")
incubation=db[["Crow2019a"]]

M1=twoppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.01, 0.001, 0.1))
M2=twopsFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.005, 0.00001, 0.1, 0.01))
M3=twopfFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.005, 0.00001, 0.1, 0.01, 0.01))

M4=threeppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars = c(0.05, 0.01, 0.001, 0.1, 0.1))
M5=threepsFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.9,0.01, 0.000001, 0.01, 0.01, 0.01, 0.1))

M=M5

days=M$SoilRmodel@times

matplot(days,Ct, type="l",lty=1, col=1:3, ylab="Carbon stocks")

matplot(days,Rt,type="l", lty=1, col=1:3, ylab="Respiration flux")
legend("topright", c("Pool 1", "Pool 2", "Pool 3"), lty=1, col=1:3, bty="n")
points(incubation$timeSeries[,c(1,79)])
lines(days, rowSums(Rt), lwd=2)

Mlist=list(M1,M2,M3,M4,M5)
Rs=sapply(Mlist, function(x){rowSums(getReleaseFlux(x$SoilRmodel))})

modelNames=c("Two pool parallel", "Two pool series", "Two pool feedback", "Three pool parallel", "Three pool series")

plot(incubation$timeSeries[,c(1,79)], ylab="Respiration flux")
matlines(days, Rs, col=2:6, lty=1)
legend("topright", modelNames, lty=1, col=2:6, bty="n")

statistics=data.frame(npar=sapply(Mlist, function(x){length(x$FMEmodel$par)}), SSR=sapply(Mlist, function(x){x$FMEmodel$ssr}), MSR=sapply(Mlist, function(x){x$FMEmodel$ms}), AIC=sapply(Mlist, function(x){x$AIC}))

###
Rt=sapply(Mlist, function(x){getReleaseFlux(x$SoilRmodel)})

par(mfrow=c(2,2))
for(i in c(1,2,4,5)){
matplot(days,Rt[[i]], type="l",lty=1, col=4:2, ylab="Respiration flux",main=modelNames[i], ylim=c(0,500))
points(incubation$timeSeries[,c(1,79)])}
legend("topright", c("Pool 1", "Pool 2", "Pool 3"), lty=1, col=4:2, bty="n")
par(mfrow=c(1,1))

