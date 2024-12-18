[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3871263.svg)](https://doi.org/10.5281/zenodo.3871263)
[![Build Status](https://travis-ci.org/SoilBGC-Datashare/sidb.svg?branch=master)](https://travis-ci.org/SoilBGC-Datashare/sidb)

# Soil Incubation Database (SIDb)

## Introduction
This repository contains all the SIDb data files and source code.
The database contains information on laboratory soil incubation experiments, with emphasis on time series
of CO<sub>2</sub> release.

*Scroll down to learn how to work with SIDb data, contribute new data, properly cite the database, and get to know the inner workings of SIDb...*

## Structure

### Data
This folder contains all the data currently in SIDb. For each incubation study there is a [`yaml`](http://yaml.org/) file with metada and a time series data file in `.csv` format. A list of the studies currently in SIDb ([studies_list.csv](/data/template_metadata.yaml)), as well as a guide for entering new data ([Readme.md](/data/Readme.md)), an annotated blank template file ([template_metadata.yaml](/data/template_metadata.yaml)), and a blank [initConditions.csv](/data/initConditions.csv) file are also located in this folder. 

The data are stored in software agnostic formats (.yaml, .csv) to facilitate data access via your preferred workflow. A pre-compiled version of the database (v1) can be obtained by installing the R package. See the next section (Rpkg) for more information.

### Rpkg
This folder contains an R package for loading entries from the database as well as tools for data manipulation, querying the database, and generating reports. To install, open R and run:

```R
install.packages("devtools")
devtools::install_github('SoilBGC-Datashare/sidb/Rpkg', build_vignettes = TRUE)
```

### Scripts
This folder contains R code and other scripts useful for visualizing and analyzing the data.

### docs
Files for generating the [SIDb website](https://soilbgc-datashare.github.io/sidb/).

### Out
This folder contains specific reports of the database generated from scripts in the Scripts folder

### Demo
This folder contains R markdown files with reproducible code to demonstrate specific data analyses. (Currently out of date). For current examples and tutorials showing how to load SIDb data in R and work with it see: [vignettes](/Rpkg/vignettes/).

### Tests
This folder contains tests to guarantee the integrity of the database. Make sure that you can run all tests without errors before contributing to the database.

## Contribute
This database is public and everybody is welcome to use it for scientific research. Users are also
encouraged to contribute their own data and scripts to the dataset. To contribute please send a pull request. Pull requests will only be accepted if submitted code/data pass our code and data validation tests. Information on how to run these tests yourself can be found here: [QA/QC Readme](tests/Readme.md).  

## How to cite 
Schädel, C., Beem-Miller, J., Aziz Rad, M., Crow, S. E., Hicks Pries, C. E., Ernakovich, J., Hoyt, A. M., Plante, A., Stoner, S., Treat, C. C., and Sierra, C. A.: Decomposability of soil organic matter over time: the Soil Incubation Database (SIDb, version 1.0) and guidance for incubation procedures, Earth Syst. Sci. Data, 12, 1511–1524, https://doi.org/10.5194/essd-12-1511-2020, 2020.

