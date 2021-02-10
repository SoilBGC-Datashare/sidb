## ---
## title: "Fitting data to models"
## author: " "
## date: "6/19/2019"
## output: word_document
## ---

## ```{r setup, include=FALSE}
## knitr::opts_chunk$set(echo = TRUE)
library(SoilR)
library(sidb)
## ```

## Fitting time series data to pool models
## SIDB can be easily integrated with other R packages for further analyses. For instance, it is possible to integrate soil pool modeling from the SoilR package (Sierra et al. 2012) with parameter optimization from the FME package (Soetaert and Petzoldt 2010). We illustrate this functionality with a simple example.

## The entry `Crow2019a` in the database contains a large number of long-term incubations. We selected data from an incubation performed with soil from a native forest in Hawaii, and fitted a set of first order models with two or three pools. Following the procedure described in Sierra et al. (2015), we optimized two- and three-pool models with parallel, series, and feedback connections among them. 


## ```{r, include=FALSE}
## db=loadEntries(path="~/sidb/data/")

path. <- "/home/wilar/Documents/sidb/data"
## db=loadEntries(path=path.)


entryNames=list.dirs(path., full.names=FALSE, recursive=FALSE)
pathentry <- paste(path., entryNames, sep = '/')

csvImp <- function(pth.){
dir. <- dir(pth.)[grepl('.csv', dir(pth.))]
csv. <- Map(function(x)
            read.csv(x), file.path(pth.,dir.))
names(csv.) <- dir.
return(csv.)}

csvAll <- Map(function(x)
    csvImp(x), pathentry) 
names(csvAll) <- entryNames

incubation <- csvAll[["Crow2019a"]]

rfit <- function(y){
condf <- function(x){
    mod <- tryCatch(twoppFit(timeSeries = incubation$timeSeries[,c(1,y)],
                    initialCarbon=incubation$initConditions[x,"carbonMean"]*10000,
                    inipars=c(0.01, 0.001, 0.1))$AIC, error = function(e) NA)
    nm <- incubation$initConditions[x,1]
    dtf <- data.frame(cond = nm, AIC = mod)
    return(dtf)}
tmp <- Map(function(x)
    tryCatch(condf(x), error = function(e) NA),
    1:nrow(incubation$initConditions))
aics <- do.call('rbind', tmp)
return(aics)}


bs <- Map(function(y)
          rfit(y), 2:ncol(incubation$timeSeries))


nmst <- c('cond',paste0(names(incubation$timeSeries)[-1L],'_AIC'))

system.time(
mrg <- Reduce(function(...)merge(..., by = 'cond'), bs)
)

colnames(mrg) <- nmst
head(mrg,3)

write.csv(mrg, 'Crow2019a_AIC.csv')

getwd()



## notes to work on:
## mean-transit time
## transit-time function
## oneppFit

## this example ends here <------------------------------------------------------------------

M1=twoppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.01, 0.001, 0.1))
M2=twopsFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.05, 0.00001, 0.1, 0.01))
M4=threeppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars = c(0.05, 0.01, 0.001, 0.1, 0.1))
M5=threepsFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.9,0.01, 0.000001, 0.01, 0.01, 0.01, 0.1))


## M1=twoppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.01, 0.001, 0.1))
M1=twoppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.01, 0.001, 0.1))
M2=twopsFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.05, 0.00001, 0.1, 0.01))
## M3=twopfFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.005, 0.00001, 0.1, 0.01, 0.01))
M4=threeppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars = c(0.05, 0.01, 0.001, 0.1, 0.1))
M5=threepsFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.9,0.01, 0.000001, 0.01, 0.01, 0.01, 0.1))

days=M1$SoilRmodel@times
Mlist=list(M1,M2,M3,M4,M5)
Rs=sapply(Mlist, function(x){rowSums(getReleaseFlux(x$SoilRmodel))})

modelNames=c("Two-pool parallel", "Two-pool series", "Two-pool feedback", "Three-pool parallel", "Three-pool series")
Rt=sapply(Mlist, function(x){getReleaseFlux(x$SoilRmodel)})
```
*Figure 4.* Results from a parameter optimization procedure to soil incubation data from a native tropical forest of Hawaii. The parallel model structures do not consider transfers of carbon among pools, while the series model structures transfer carbon sequentially from fast to slow cycling pools. 


In all cases, the models fitted the data relatively well (Figure 4, Table 1), and identified the relative contribution of the different pools to the overall respiration flux. 

*Table 1.* Summary statistics from the parameter optimization procedure. npar: number of optimized parameters, SSR: sum of squared residuals, MSR: mean sum of squared residuals, AIC: Akaike information criterion. 
```{r, echo=FALSE}
par(mfrow=c(2,2), mar=c(4,4.5,1,0.5))
for(i in c(1,2,4,5)){
  matplot(days,Rt[[i]], type="l",lty=1, col=4:2, ylab=expression(paste("Respiration (",mu, "gC g soi", l^-1, "da", y^-1, ")")),
          main=modelNames[i], ylim=c(0,500), bty="n", font.main=1)
  points(incubation$timeSeries[,c(1,79)], pch=19, cex=0.5)
  lines(days, Rs[,i])
}
legend("topright", c("Total","Fast", "Intermediate", "Slow"), lty=1, col=c(1,4:2), bty="n")
par(mfrow=c(1,1))
```

According to the Akaike information criterion (AIC), the two-pool model with parallel structure is the most parsimoniuos model (lowest AIC). However, the three-pool models show a long-term behavior consistent with our understanding of soil carbon dynamics (Figure 1). A persimoniuos model structure that combines low AIC and theoretical understanding of soil carbon dynamics would be the three-pool model with parallel structure, for which five parameters were optimized with a reasonable mean square error and AIC (Table 1).

```{r, echo=FALSE}
statistics=data.frame(npar=sapply(Mlist, function(x){length(x$FMEmodel$par)}), SSR=sapply(Mlist, function(x){x$FMEmodel$ssr}), MSR=sapply(Mlist, function(x){x$FMEmodel$ms}), AIC=sapply(Mlist, function(x){x$AIC}))
row.names(statistics)<-modelNames
knitr::kable(statistics)
```

SIDB offers the opportunity to perform parameter identification analyses for a large number of incubations, and to identify the effects of environmnetal variables on soil decomposition.

