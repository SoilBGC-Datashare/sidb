#' Flattens SIDb database object for easier querying
#'
#' @param database A database with the SIDb structure
#' @return R list with two elements, linked by shared column "ID":\cr
#' 1) \emph{timeseries}, a list of unique timeseries, each a 2-column dataframe (time, response)\cr
#' 2) \emph{vars}, a list of all site, incubation and variables fields flattened into a dataframe for each entry
#' @export
#' @import dplyr
#' @import rlang
#' @import stringr
#' @examples
#' sidb.flatter <- flatterSIDb(sidb)
flatterSIDb <- function(database) {

  # timeseries: make list with each unique timeseries as its own 2-col dataframe (time, response)
  #####
  ts <- lapply(database, function(x) x$timeSeries)

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
  #####

  # variables: make list of dataframes of variables from the 'variable' level
  #####
  vars.dfl <- lapply(database, function(x) {
    dplyr::bind_rows(lapply(x$variables[-1], function(y) {
      df = data.frame(t(sapply(y,c)), stringsAsFactors = F)
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

  # add citationKey col to vars.dfl and concatenate w/ variable 'name' to make unique ID col to match to timeseries
  vars.dfl <- Map(cbind, vars.dfl, citationKey = names(vars.dfl))
  vars.dfl <- lapply(vars.dfl, function(x) {
    x$ID = paste(x$name, x$citationKey, sep="_")
    return(x)
  })
  #####

  # incubationInfo: flatten list, remove NA cols, and add data to vars.dfl
  #####
  incInfo <- lapply(database, "[[", "incubationInfo")

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

  # Remove depthInfo. prefix from depth fields
  incInfo <- lapply(incInfo, function(x) {
    nms <- colnames(x)
    ix <- grep("depthInfo.", nms)
    nms[ix] <- lapply(seq_along(nms[ix]), function(i) {
      substring(nms[ix][i], first=stringr::str_locate(nms[ix][i], "depthInfo.")[2]+1, last=nchar(nms[ix][i]))
    })
    colnames(x) <- nms
    return(x)
  })

  # Join each element of incInfo with corresponding vars.dfl element
  for(i in seq_along(vars.dfl)) {
    vars.dfl[[i]] <- cbind(vars.dfl[[i]], incInfo[[i]])
  }

  # Replace NA "experimentalTreatment.value" names with "experimentalTreatment"
  vars.dfl <- lapply(vars.dfl, function(x) {
    nms <- colnames(x)
    ix <- grep(".value", nms)
    nms[ix] <- lapply(seq_along(nms[ix]), function(i) {
      substring(nms[ix][i], first=1,last=stringr::str_locate(nms[ix][i], ".value")[1]-1)
    })
    colnames(x) <- nms
    return(x)
  })
  #####

  # siteInfo: flatten list and add unique data from siteInfo to vars.dfl
  #####
  siteInfo <- lapply(database, "[[", "siteInfo")

  # flatten soilTax, coords, permafrost
  siteInfo <- lapply(siteInfo, function(x) {
      null.na.fx <- function(z) {
        if(is.null(z)) {
          NA
        } else {
          z
        }
          }
      latitude <- data.frame(latitude=unlist(lapply(x$coordinates$latitude,null.na.fx)))
      longitude <- data.frame(longitude=unlist(lapply(x$coordinates$longitude,null.na.fx)))
      soilOrder <- data.frame(soilOrder=unlist(lapply(x$soilTaxonomy$soilOrder,null.na.fx)))
      soilFamily <- data.frame(soilFamily=unlist(lapply(x$soilTaxonomy$soilFamily, null.na.fx)))
      soilSeries <- data.frame(soilSeries=unlist(lapply(x$soilTaxonomy$soilSeries,null.na.fx)))
      classificationSystem <- data.frame(classificationSystem=unlist(lapply(x$soilTaxonomy$classificationSystem,null.na.fx)))
      permafrostExist <- data.frame(permafrostExist=unlist(lapply(x$permafrost$permafrostExist, function(y) ifelse(is.null(y), FALSE, y))))
      activeLayer <- data.frame(activeLayer=unlist(x$permafrost$activeLayer))
      ix <- which(names(x)=="coordinates" | names(x)=="soilTaxonomy" | names(x)=="permafrost")
      x <- x[-ix]
      x <- c(x,latitude,longitude,soilOrder,soilFamily,soilSeries,classificationSystem,permafrostExist,activeLayer)
      return(x)
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

  # add site name to vars.dfl elements with only one site
  no.site<-Filter(Negate(length),lapply(vars.dfl, function(x) x$site))
  ix<-match(names(no.site),names(siteInfo))
  sites<-lapply(siteInfo[ix], function(x) x$site)
  for(i in seq_along(vars.dfl[ix])) {
    vars.dfl[ix][[i]]["site"] <- sites[[i]]
  }

  # Convert siteInfo elmenents to df
  siteInfo <- lapply(siteInfo, function(x) as.data.frame(x))

  # remove NA columns from siteInfo and join to vars.dfl
  siteInfo <- lapply(siteInfo, function(x) x[ ,!apply(is.na(x),2,all)])
  for(i in seq_along(vars.dfl)) {
    vars.dfl[[i]] <- dplyr::left_join(as.data.frame(lapply(vars.dfl[[i]], as.character), stringsAsFactors=F), as.data.frame(lapply(siteInfo[[i]], as.character), stringsAsFactors=F), by="site")
  }

  # Convert all numeric data from factor or chr to numeric type
  vars.dfl<-lapply(vars.dfl, function(x) lapply(x, as.character))
  vars.dfl<-lapply(vars.dfl, function(x) lapply(x, utils::type.convert))
  vars.dfl<-lapply(vars.dfl, as.data.frame)

  #####
  # Add IDs from list of variable dataframes (vars.dfl) to timeSeries list (ts.l)
  names(ts.l) <- unlist(lapply(vars.dfl, function(x) x$ID), use.names=F)
  ts.l <- lapply(ts.l, function(x) {
    x = as.data.frame(x)
    colnames(x) = c("time","response")
    x$ID = NA
    return(x)
  })
  for(i in seq_along(ts.l)) {
    ts.l[[i]]["ID"] = names(ts.l)[i]
  }
  return(list(timeseries=ts.l, vars=vars.dfl))
}
