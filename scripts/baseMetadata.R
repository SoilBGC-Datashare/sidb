# This script reads the basic metadata from all studies and writes a csv file with all entries

source("~/sidb/scripts/readYaml.R")
source("~/sidb/scripts/loadEntries.R")

entryBaseMetadata=data.frame(citationKey, doi, entryAuthor, entryCreationDate)

write.csv(entryBaseMetadata,"~/sidb/out/baseMetadata.csv", row.names = FALSE)

