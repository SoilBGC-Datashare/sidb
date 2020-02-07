[![DOI](https://zenodo.org/badge/64746862.svg)](https://zenodo.org/badge/latestdoi/64746862)
[![Build Status](https://travis-ci.org/SoilBGC-Datashare/sidb.svg?branch=master)](https://travis-ci.org/SoilBGC-Datashare/sidb)

# Soil Incubation Database

## Introduction
This repository contains all data files and source code of the Soil Incubation Database.
The database contains information on soil incubation experiments, with emphasis on time series
of CO<sub>2</sub> release over incubation time.

## Structure

### Data
This folder contains both data and metadata. For each incubation study there is a [`yaml`](http://yaml.org/) file with metada and a time series data file in `.csv` format. A list of the studies currently in SIDB ("studies_list.csv"), as well as a guide for entering new data ("Readme.md"), an annotated blank template file ("template_metadata.yaml"), and a blank "initConditions.csv" file are also located in this folder.

### Rpkg
This folder contains an R package for loading entries from the database as well as tools for data manipulation, querying the database, and generating reports. To install, open R and run:

```R
install.packages("devtools")
devtools::install_github('SoilBGC-Datashare/sidb/Rpkg', build_vignettes = TRUE)
```

### Scripts
This folder contains R code and other scripts necessary to visualize and analyze the data.

### docs
Website of the project

### Out
This folder contains specific reports of the database generated from scripts in the Scripts folder

### Demo
This folder contains R markdown files with reproducible code to demonstrate specific data analyses.

### Tests
This folder contains tests to guarantee the integrity of the database. Make sure that you can run all tests without errors before contributing to the database.

## Contribute
This database is public and everybody is welcome to use it for scientific research. Users are also
encouraged to contribute their own data and scripts to the dataset. To contribute please send a pull request. Pull requests will only be accepted if code or data submitted pass our code and data validation tests. Information on how to run these tests yourself can be found here: [QAQC Readme](tests/Readme.md).  

## How to cite 
Schädel, C., Beem-Miller, J., Aziz Rad, M., Crow, S. E., Hicks Pries, C., Ernakovich, J., Hoyt, A. M., Plante, A., Stoner, S., Treat, C. C., and Sierra, C. A.: Decomposability of soil organic matter over time: The Soil Incubation Database (SIDb, version 1.0) and guidance for incubation procedures, Earth Syst. Sci. Data Discuss., https://doi.org/10.5194/essd-2019-184, in review, 2019. 

