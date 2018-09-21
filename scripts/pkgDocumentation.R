# This script automatically generates the documentation of the sidb package

if(!require("devtools")) install.packages("devtools")

devtools::document("../Rpkg/")

