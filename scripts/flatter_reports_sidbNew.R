#####
# New template structure
# 26 June 2019
#####
# This script creates the following objects:
# 1) ts.l
#   - list containing each unique timeseries as a 2 column dataframe [,c('time','responseVar')]
#   - each element of ts.l is named according to the convention: responseVar_citationKey
# 2) vars.dfl
#   - list containing all data in incubationInfo and siteInfo tables
#   - each element contains data from one study
#####
devtools::install_github("SoilBGC-Datashare/sidb/Rpkg", ref="dev")
library(sidb)

idb <- loadEntries("/Users/jeff/sidb/data/")

# Work from bottom: extract list of timeSeries data
#####
ts <- lapply(idb, function(x) x$timeSeries)

# calculate rows per timeSeries dataframe (ts.rows) and number of timeseries per study (ts.cols)
ts.rows <- lapply(ts, function(x) nrow(x[1]))
ts.cols <- lapply(ts, function(x) ncol(x[-1]))

# make list of time columns for each timeseries, and one of response variables
ts.t <- lapply(ts, function(x) x[[1]])
ts.y <- lapply(ts, function(x) x[-1])

# Initialize list of timeseries dataframes, with each element a unique timeseries
ts.l <- list()
for(i in 1:length(ts)) {
  ts.l[[i]] = replicate(ts.cols[[i]], matrix(nrow=ts.rows[[i]], ncol=2), simplify = F)
}
for(i in 1:length(ts.l)) {
  for(j in 1:length(ts.l[[i]])) {
    ts.l[[i]][[j]][,1] = ts.t[[i]]
    ts.l[[i]][[j]][,2] = ts.y[[i]][[j]]
  }
}
ts.l <- unlist(ts.l, recursive=F)

# variables: make list of dataframes of variables from the 'variable' level
#####
vars.dfl <- lapply(idb, function(x) {
  plyr::rbind.fill(lapply(x$variables[-1], function(y) {
    df = data.frame(t(sapply(y,c)))
    return(df)
  }))
})

# define helper fx to collapse lists present in some dataframes (some yaml files read in differently despite visually identical structure)
collapse.df <- function(df) {
  nms = names(df)
  df = data.frame(matrix(unlist(lapply(df, function(x) { # replace NULL with NA
    lapply(x, function(y) {
      y[rlang::is_empty(y)] = NA
      return(y)
    }) 
  })), nrow=length(df[[1]]),
  ncol=length(df)), 
  stringsAsFactors = FALSE)
  colnames(df) = nms
  return(df)
}

# apply fx to vars.dfl
vars.dfl <- lapply(vars.dfl, function(x) {
  if(is.list(x[[1]])) {
    collapse.df(x)
  } else return(x)
})

# add citationKey col to vars.dfl and concatenate w/ variable 'name' to make unique ID col
vars.dfl <- Map(cbind, vars.dfl, citationKey = names(vars.dfl))
vars.dfl <- lapply(vars.dfl, function(x) {
  x$ID = paste(x$name, x$citationKey, sep="_")
  return(x)
})
#####

#####
# incubationInfo
incInfo <- lapply(idb, "[[", "incubationInfo")

# convert null to NA and unlist nested lists
incInfo <- lapply(incInfo, function(x) {
  d1 <- match(names(unlist(lapply(x, function(y) which(is.list(y))))),names(x))
  ix.1d <- x[-d1]
  ix.1d[sapply(ix.1d, is.null)] <- NA
  ix.2d <- x[d1]
  ix.2d <- lapply(ix.2d, function(y) {
    y[sapply(y, is.null)] <- NA
    return(y)
  })
  ix.2d.1d <- c(unlist(ix.2d, recursive=F),ix.1d)
  df <- do.call("data.frame",ix.2d.1d)
  return(df)
})

# expand incInfo elements to same nrow as vars.dfl elements
for(i in seq_along(incInfo)) {
  incInfo[[i]] <- incInfo[[i]][rep(1, each=nrow(vars.dfl[[i]])),]
}

# remove NA columns in incInfo elements
incInfo <- lapply(incInfo, function(x) x[ ,!apply(is.na(x),2,all)])

# Join each element of incInfo with corresponding vars.dfl element
for(i in seq_along(vars.dfl)) {
  vars.dfl[[i]] <- cbind(vars.dfl[[i]], incInfo[[i]])
}

#####
# siteInfo
siteInfo <- lapply(idb, "[[", "siteInfo")

# flatten soilTax, coords, permafrost
siteInfo <- lapply(siteInfo, function(x) {
  latitude <- data.frame(latitude=unlist(x$coordinates$latitude))
  longitude <- data.frame(longitude=unlist(x$coordinates$longitude))
  soilOrder <- data.frame(soilOrder=unlist(x$soilTaxonomy$soilOrder))
  soilFamily <- data.frame(soilFamily=unlist(x$soilTaxonomy$soilFamily))
  soilSeries <- data.frame(soilSeries=unlist(x$soilTaxonomy$soilSeries))
  classificationSystem <- data.frame(classificationSystem=unlist(x$soilTaxonomy$classificationSystem))
  permafrostExist <- data.frame(permafrostExist=unlist(lapply(x$permafrost$permafrostExist, function(y) ifelse(is.null(y), FALSE, y))))
  activeLayer <- data.frame(activeLayer=unlist(x$permafrost$activeLayer))
  ix <- which(names(x)=="coordinates" | names(x)=="soilTaxonomy" | names(x)=="permafrost")
  x <- x[-ix]
  x <- c(x,latitude,longitude,soilOrder,soilFamily,soilSeries,classificationSystem,permafrostExist,activeLayer)
  return(x)
})

# unlist nested lists (works for some templates but not others, unclear why)
siteInfo <- lapply(siteInfo, function(x) {
  d1 <- match(names(unlist(lapply(x, function(y) which(is.list(y))))),names(and))
  if(!length(d1)==0) {
    ix.1d <- x[-d1]
    ix.2d <- x[d1]
    ix.2d <- lapply(ix.2d, function(y) {
      y[sapply(y, is.null)] <- NA
      return(y)
    })
    ix.2d <- lapply(ix.2d, function(y) {
      if(length(y[[1]])==1 && !is.na(y[[1]])) {
        y <- unlist(y)
      }
      return(y)
    })
    ix <- which(unlist(lapply(ix.2d, function(y) is.list(y))))
    ix.2d.1d <- ix.2d[-ix]
    ix.2d <- ix.2d[ix]
    ls <- c(unlist(ix.2d, recursive=F), ix.2d.1d, ix.1d)
  } else {
    ls<-x
  }
  return(ls)
})

# expand fields with single value to nrow of site array
siteInfo <- lapply(siteInfo, function(x) {
  nSite <- length(x$site)
  x <- lapply(x, function(y) {
    if(length(y)!=nSite && !is.list(y)) {
      y <- ifelse(is.null(y),NA,y)
      y <- rep(y,nSite)
    }
    return(y)
  })
  return(x)
})

# Replace NA "experimentalTreatment.value" names with "experimentalTreatment"
vars.dfl <- lapply(vars.dfl, function(x) {
  nms <- colnames(x)
  ix <- grep(".value", nms)
  nms[ix] <- substring(nms[ix], first=1,last=stringr::str_locate(nms[ix], ".value")[1]-1)
  colnames(x) <- nms
  return(x)
})

# add site name to vars.dfl elements with only one site
no.site<-Filter(Negate(length),lapply(vars.dfl, function(x) x$site))
ix<-match(names(no.site),names(siteInfo))
sites<-lapply(siteInfo[ix], function(x) x$site)
for(i in seq_along(vars.dfl[ix])) {
  vars.dfl[ix][[i]]["site"] <- sites[[i]]
}

# add siteInfo to vars.dfl
siteInfo <- lapply(siteInfo, function(x) as.data.frame(x))
# remove NA columns from siteInfo
siteInfo <- lapply(siteInfo, function(x) x[ ,!apply(is.na(x),2,all)])
for(i in seq_along(vars.dfl)) {
  vars.dfl[[i]] <- dplyr::right_join(as.data.frame(lapply(vars.dfl[[i]], as.character), stringsAsFactors=F), as.data.frame(lapply(siteInfo[[i]], as.character), stringsAsFactors=F), by="site")
}


