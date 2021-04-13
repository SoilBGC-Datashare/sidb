## ---
## title: "Fitting of multiple time series using function 'multiFit'"
## author: " "
## date: "04/13/2021"
## output: 
## ---
packs <- c('SoilR', 'sidb', 'yaml', 'parallel','R.utils')
sapply(packs, require, character.only = TRUE) ## be sure all the outputs are TRUE

userLocation <- '/home/wilar/Documents' # Path to local sidb folder
source.R <- file.path(userLocation, 'sidb/scripts/multiSidbFit')
sourceDirectory(source.R, modifiedOnly = TRUE, verbose = TRUE)

## Data entry example: 
load_entries <- loadEntries(file.path(userLocation, 'sidb/data/'))
db <- load_entries[["Crow2019a"]]

tmp <- MultiFit(db, model = c('twoppFit',
                              'twopsFit',
                              'twopfFit',
                              'threeppFit',
                              'threepsFit'),
                inipars = list(c(0.01, 0.001, 0.1),
                               c(0.05, 0.00001, 0.1, 0.01),
                               c(0.005, 0.00001, 0.1, 0.01, 0.01),
                               c(0.05, 0.01, 0.001, 0.1, 0.1),
                               c(0.9,0.01, 0.000001, 0.01, 0.01, 0.01, 0.1)),
                ic.col = list(78),
                ts.col = list(75:79))
                ## ts.col = list(NULL)) # replace previous line with this one if you aim to evaluate the whole 'ts.col' instances

names(tmp)
names(tmp$'twoppFit')
names(tmp$'twoppFit'$'75')

## The example if based on the following routines
M1=twoppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.01, 0.001, 0.1))
M2=twopsFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.005, 0.00001, 0.1, 0.01))
M3=twopfFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.005, 0.00001, 0.1, 0.01, 0.01))

M4=threeppFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars = c(0.05, 0.01, 0.001, 0.1, 0.1))
M5=threepsFit(timeSeries = incubation$timeSeries[,c(1,79)], initialCarbon=incubation$initConditions[78,"carbonMean"]*10000, inipars=c(0.9,0.01, 0.000001, 0.01, 0.01, 0.01, 0.1))


names(tmp)


## twopsFit_model <- multiSidbFit(db,
##                        model = 'twopsFit',
##                        ic.col = 1,
##                        ts.col = 15:20,
##                        inipars=c(0.05, 0.00001, 0.1, 0.01))


## threeppFit_model <- multiSidbFit(db,
##                     model = 'threeppFit',
##                     ts.col = 2:10,
##                     inipars=c(0.05, 0.01, 0.001, 0.1, 0.1))




