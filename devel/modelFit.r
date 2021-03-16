## ---
## title: "Fitting of multiple time series using 'multiSidbFit'"
## author: " "
## date: "03/15/2021"
## output: word_document
## ---
packs <- c('SoilR', 'sidb', 'yaml', 'parallel','R.utils')
sapply(packs, require, character.only = TRUE) ## be sure all the outputs are TRUE
source.R <- '/home/wilar/Documents/sidb/scripts/multiSidbFit'
sourceDirectory(source.R, modifiedOnly = TRUE, verbose = TRUE)

## Data entry example 
path <- "/home/wilar/Documents/sidb/data/" ## set a correct file path
load_entries <- loadEntries(path)
db <- load_entries[["Crow2019a"]]


twopsFit_model <- multiSidbFit(db,
                       model = 'twopsFit',
                       ic.col = 1,
                       ts.col = 15:20,
                       inipars=c(0.05, 0.00001, 0.1, 0.01))


threeppFit_model <- multiSidbFit(db,
                    model = 'threeppFit',
                    ts.col = 2:10,
                    inipars=c(0.05, 0.01, 0.001, 0.1, 0.1))




