# SIDb R Package
This package is an inteface to read and process data from the Soil Incubation Database SIDb. 
The package can be installed directly from CRAN as
```R
install.packages("sidb")
```

Alternatively, you can install the development version of the package directly from GitHub. In R, run:
```R
install.packages("devtools")
devtools::install_github('SoilBGC-Datashare/sidb/Rpkg', build_vignettes = TRUE)
```

To load the latest version of SIDb in R, use the function `loadEntries()`. To read individual entries, use the function `readEntry()`. You can also check other functions by consulting the help pages with `?sidb`.

