## ---
## title: "Fitting of multiple data to models"
## author: " "
## date: "6/19/2019"
## output: word_document
## ---

packs <- c('SoilR', 'sidb', 'yaml', 'parallel','R.utils')
sapply(packs, require, character.only = TRUE) ## be sure all the outputs are TRUE

source.R <- '/home/wilar/Documents/sidb/scripts/multiSidbFit'
sourceDirectory(source.R, modifiedOnly = TRUE, verbose = TRUE)

## Data entry example 
path <- "/home/wilar/Documents/sidb/data/"
load_entries <- loadEntries(path)
db <- load_entries[["Crow2019a"]]


dts <- c('timeSeries','initConditions','carbonMean')
all(dts[1:2]%in%names(db))

twopsFit_model <- multiSibdFit(db,
                       model = 'twopsFit',
                       ic.col = 1,
                       ts.col = 15:20,
                       inipars=c(0.05, 0.00001, 0.1, 0.01))


threeppFit_model <- multiSibdFit(db,
                    model = 'threeppFit',
                    ts.col = 2:10,
                    inipars=c(0.05, 0.01, 0.001, 0.1, 0.1))




library(SoilR)
library(sidb)
require('yaml')
require('parallel')

?twopsFit

path <- "/home/wilar/Documents/sidb/data/"
load_entries <- loadEntries(path)
db <- load_entries[["Crow2019a"]]


tmp <- multi_fit(db, model = 'twopsFit',tsnr = 2:10, inipars=c(0.05, 0.00001, 0.1, 0.01))

multi_fit <- function(db, model = 'twoppFit', inicond = 1, tsnr = 2:3, inipars = c(0.01, 0.001, 0.1)){
    condf <- function(y, model, inicond, inipars){
        inp <- list(timeSeries = db$'timeSeries'[,c(1,y)],
                    initialCarbon = db$'initConditions'[inicond,"carbonMean"]*1E4,
                    inipars = inipars)
        mod <- tryCatch(do.call(model, inp),
                        error = function(e) return(NA))
        return(mod)}
    if(is.null(tsnr))
        tsnr <- 2:ncol(db$'timeSeries')
    ic <- Map(function(x)
        condf(x, model, inicond, inipars), tsnr)
    names(ic) <- tsnr
    return(ic)}



condf <- function(y, model = 'twoppFit', inicond = 1, inipars = c(0.01, 0.001, 0.1)){
    inp <- list(timeSeries = db$'timeSeries'[,c(1,y)],
                initialCarbon = db$'initConditions'[inicond,"carbonMean"]*1E4,
                inipars = inipars)
    mod <- tryCatch(do.call(model, inp),
                    error = function(e) return(NA))
    return(mod)}
ic <- Map(function(x)
    condf(x), 1:3)

ic <- parallel::mcmapply(FUN = function(x)
        condf(x, model, inipars),
        x = 1:nrow(db$'initConditions'), SIMPLIFY = FALSE,
        mc.cores = mc.cores)
  

ic <- Map(function(x)
    condf(x), 1:nrow(db$'timeSeries'))

fn_to_iter <- function(y){
    lst2 <- list(y, model = model, inipars = inipars)
    return(lst2)
}
        args <- Map(function(m)
            fn_to_iter(m), 1:nrow(db$'initConditions'))
        marg <- list(FUN = function(x)
            do.call('condf', x),



modelEntry <- function(db,
                       ts.nr = 2,
                       model = 'twoppFit',
                       inipars = c(0.01, 0.001, 0.1)){
                       ## mc.cores = round(detectCores()*0.5,0)){
    ## db <- entry
    rfit <- function(y, model, inipars){
## rfit <- function(y, model, inipars, mc.cores){
    condf <- function(x, model, inipars){
        inp <- list(timeSeries = db$'timeSeries'[,c(1,y)],
                    initialCarbon = db$'initConditions'[x,"carbonMean"]*1E4,
                    inipars = inipars)
        mod <- tryCatch(do.call(model, inp),
                        error = function(e) return(NA))
        return(mod)}
    ic <- Map(function(x)
          condf(x, model, inipars), 1:nrow(db$'initConditions'))
    ## ic <- parallel::mcmapply(FUN = function(x)
    ##     condf(x, model, inipars),
    ##     x = 1:nrow(db$'initConditions'), SIMPLIFY = FALSE,
    ##     mc.cores = mc.cores)
    names(ic) <- db$'initConditions'$'site'
    return(ic)}
## bs <- parallel::mcmapply(FUN = function(y)
##     ## rfit(y, model = model,inipars = inipars,mc.cores = mc.cores),
##     rfit(y, model = model,inipars = inipars),
##     y = ts.nr, SIMPLIFY = FALSE,
##     mc.cores = mc.cores)
bs <- Map(function(y)
     rfit(y, model = model,inipars = inipars), ts.nr)
names(bs) <- ts.nr
    return(bs)}

st <- modelEntry(db, model = 'two'ts.nr = 2:nrow(db$'timeSeries'), inipars = c())

head(db$'initConditions')

tms <- as.list(db$'timeSeries')
tmc <- as.list(db$'initConditions'[,"carbonMean"]*1E4)


split()db$'timeSeries'[2:ncol(db$'timeSeries')]



init <- function(x){
    list(initialCarbon = db$'initConditions'[x,"carbonMean"]*1E4)}
lsini <- Map(function(x)
             init(x), 1:nrow(db$'initConditions'))


head(db$'initConditions')



fn. <- function(x){
    twoppFit(db$'timeSeries'[,1:x], db$'initConditions'[1,"carbonMean"]*1E4, inipars = c(0.01, 0.001, 0.1)) 
}
cr <- tryCatch(apply(db$'timeSeries'[,2:5], 1, function(x)fn.(x)),
               error = function(e)return(NA))

fn_to_iter <- function(y){
    lst2 <- list(y, model = model, inipars = inipars)
    return(lst2)
}
args <- Map(function(m)
    fn_to_iter(m), 1:nrow(db$'initConditions'))
marg <- list(FUN = function(x)
    do.call('condf', x),



twoppFit(db$'timeSeries'[,1:2], db$'initConditions'[1,"carbonMean"]*1E4, inipars = c(0.01, 0.001, 0.1))

fn <- do.call('twoppFit')


modelEntry <- function(db,
                       ts.nr = 2,
                       model = 'twoppFit',
                       inipars = c(0.01, 0.001, 0.1),#{
                       mc.cores = round(detectCores()*0.5,0)){
rfit <- function(y, model = model, inipars = inipars, mc.cores = mc.cores){
    condf <- function(x, model, inipars){
        inp <- list(timeSeries = db$'timeSeries'[,c(1,y)],
                    initialCarbon = db$'initConditions'[x,"carbonMean"]*1E4,
                    inipars = inipars)
        mod <- tryCatch(do.call(model, inp),
                        error = function(e) return(NA))
        return(mod)}
        fn_to_iter <- function(y){
            lst2 <- list(y, model = model, inipars = inipars)
            return(lst2)
}
        args <- Map(function(m)
            fn_to_iter(m), 1:nrow(db$'initConditions'))
        marg <- list(FUN = function(x)
            do.call('condf', x),
            x = args, SIMPLIFY = FALSE,
            mc.cores = mc.cores)
ic <- do.call('mcmapply', marg)
    names(ic) <- db$'initConditions'$'site'
    return(ic)}
bs <- Map(function(b)
     rfit(b, model = model,inipars = inipars, mc.cores = mc.cores), b = ts.nr)
names(bs) <- ts.nr
return(bs)}
st <- modelEntry(db, ts.nr = 2:3)

modelEntry <- function(db,
                       ts.nr = 2,
                       model = 'twoppFit',
                       inipars = c(0.01, 0.001, 0.1)){
                       ## mc.cores = round(detectCores()*0.5,0)){
    ## db <- entry
    rfit <- function(y, model, inipars){
## rfit <- function(y, model, inipars, mc.cores){
    condf <- function(x, model, inipars){
        inp <- list(timeSeries = db$'timeSeries'[,c(1,y)],
                    initialCarbon = db$'initConditions'[x,"carbonMean"]*1E4,
                    inipars = inipars)
        mod <- tryCatch(do.call(model, inp),
                        error = function(e) return(NA))
        return(mod)}
    ic <- Map(function(x)
          condf(x, model, inipars), 1:nrow(db$'initConditions'))
    ## ic <- parallel::mcmapply(FUN = function(x)
    ##     condf(x, model, inipars),
    ##     x = 1:nrow(db$'initConditions'), SIMPLIFY = FALSE,
    ##     mc.cores = mc.cores)
    names(ic) <- db$'initConditions'$'site'
    return(ic)}
## bs <- parallel::mcmapply(FUN = function(y)
##     ## rfit(y, model = model,inipars = inipars,mc.cores = mc.cores),
##     rfit(y, model = model,inipars = inipars),
##     y = ts.nr, SIMPLIFY = FALSE,
##     mc.cores = mc.cores)
bs <- Map(function(y)
     rfit(y, model = model,inipars = inipars), ts.nr)
names(bs) <- ts.nr
return(bs)}
st <- modelEntry(db, ts.nr = 2:3)



## <------------------
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
          rfit(y), 1)



bs <- Map(function(y)
          rfit(y), 2:ncol(incubation$timeSeries))

nmst <- c('cond',paste0(names(incubation$timeSeries)[-1L],'_AIC'))

system.time(
mrg <- Reduce(function(...)merge(..., by = 'cond'), bs)
)

## colnames(mrg) <- nmst
## head(mrg,3)
## write.csv(mrg, 'Crow2019a_AIC.csv')
## getwd()


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

