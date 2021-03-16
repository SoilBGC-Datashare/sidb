## ---
## title: "Example to fit the function 'multiSidbFit'"
## author: " "
## date: "03/15/2021"
## ---

## imports
packs <- c('SoilR', 'sidb', 'yaml', 'parallel','R.utils')
sapply(packs, require, character.only = TRUE) ## be sure all the outputs are TRUE

## Function uploading 
userLocation <- '/home/wilar/Documents' #Change location of the sidb folder
source.R <- file.path(userLocation, 'sidb/scripts/multiSidbFit')
sourceDirectory(source.R, modifiedOnly = TRUE, verbose = TRUE)

## Data-entry loading 
path <- "/home/wilar/Documents/sidb/data/" ## set a correct file path
load_entries <- loadEntries(path)
db <- load_entries[["Crow2019a"]]

## Example 1
twopsFit_model <- multiSidbFit(db,
                       model = 'twopsFit',
                       ic.col = 1,
                       ts.col = 15:20,
                       inipars=c(0.05, 0.00001, 0.1, 0.01))

## Example 2
threeppFit_model <- multiSidbFit(db,
                    model = 'threeppFit',
                    ts.col = 2:10,
                    inipars=c(0.05, 0.01, 0.001, 0.1, 0.1))
