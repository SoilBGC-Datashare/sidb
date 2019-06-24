[![Build Status](https://travis-ci.org/SoilBGC-Datashare/sidb.svg?branch=master)](https://travis-ci.org/SoilBGC-Datashare/sidb)
# Soil Incubation Database

## Introduction
This repository contains all data files and source code of the Soil Incubation Database.
The database contains information on soil incubation experiments, with emphasis on time series
of CO<sub>2</sub> release over incubation time.

## Structure

### Data
This folder contains both data and metadata. For each incubation study, there is a [`yaml`](http://yaml.org/) file with metada, and the data is stored in a comma separated file `csv`.

### Rpkg
This folder contains an R package that can load entries from the database. To install, open R and run

```R
install.packages("devtools")
devtools::install_github('SoilBGC-Datashare/sidb/Rpkg')
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
encouraged to contribute their own data and scripts to the dataset. To contribute please send a pull request.

