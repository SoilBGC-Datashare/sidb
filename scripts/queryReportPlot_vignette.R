#####
# Vignette: Query, report, plotting workflow with SIDB
# 28 June 2019
#####

# install latest package and load relevant libraries
devtools::install_github("SoilBGC-Datashare/sidb/Rpkg", ref="dev")
library(sidb)
library(ggplot2)
library(plyr)
library(dplyr)

#####

# 0) Prepare data
#####
# load data
database <- loadEntries("~/sidb/data/")

# run "flatter" fx 
db <- flatterSIDB(database)

# join variables dataframes with initConditions
vars.ic <- lapply(seq_along(db), function(i) left_join(dbf$vars[[i]], db[[i]][["initConditions"]]))
names(vars.ic) <- names(db)

# create df object of timeseries list
ts.df <- do.call("rbind", db$timeseries)
#####

# 1) Filter vars.dfl to exclude SD and SE timeseries
#####
# add statistic column to entries missing it
vars.dfl.mean <- lapply(vars.ic, function(x) {
  if(is.null(x$statistic)) {
    x$statistic = NA
  } else {
    x$statistic = x$statistic
  }
  return(x)
})
vars.dfl.mean <- lapply(vars.dfl.mean, function(x) {
  x = x[which(x$statistic == "none" | is.na(x$statistic)),]
  return(x)
})
#####

# 2) Extract all timeseries with temperature between 10 and 20 degrees
#####
# list variables in vars.dfl by calling 'names' on each element of list and filtering to unique values
sort(unique(unlist(lapply(vars.dfl.mean, function(x) names(x)))))

# first extract indices of studies with timeseries that match conditions
ix.ls <- lapply(vars.dfl.mean, function(x) which(x$temperature >= 10 & x$temperature <= 20))

# then subset list with list of indices and convert to dataframe
t.10.20.df <- plyr::rbind.fill(lapply(seq_along(vars.dfl.mean), function(i) vars.dfl.mean[[i]][ix.ls[[i]],]))

# join your subset of the variables dataframes with the corresponding timeseries
t.10.20.df <- dplyr::left_join(t.10.20.df, ts.df, by="ID")
#####

# 3) Plot
#####
# examples:
# a) plot first 300 days, with latitude as color
ggplot(t.10.20.df, aes(time, response, color=abs(latitude))) +
  geom_path() +
  scale_x_continuous(limits=c(0,300)) +
  theme_bw() +
  theme(panel.grid = element_blank())

# b) plot sites >60N, with moisture as color, first 100 days of incubation
# filter based on moisture units
filter(t.10.20.df, latitude >= 60) %>% filter(moisture.units == "percentFieldCapacity") %>%
  ggplot(., aes(time, response, color=moisture)) +
  geom_path() +
  scale_x_continuous(limits=c(0,100)) +
  theme_bw() +
  theme(panel.grid = element_blank())

# c) plot first 30 days, with moisture as color
ggplot(t.10.20.df, aes(time, response, color=moisture)) +
  geom_path() +
  scale_x_continuous(limits=c(0,30)) +
  scale_y_continuous(limits=c(0,1.3e+05)) +
  scale_color_continuous(limits=c(0,100)) +
  theme_bw() +
  theme(panel.grid = element_blank())
