####### Upload the libraries #######

packs <- c('SoilR', 'sidb', 'R.utils', 'dplyr')
sapply(packs, require, character.only=TRUE)
rm(list = ls())

####### Function uploading #######
source(file = "/Users/mina/sidb/manuscript/ModFitTS_DataSaving_Func.R")

###### Upload the database ######
db=loadEntries(path="~/sidb/data/")
#db_flat=flatterSIDb(db)
###############

######Dataset "Bracho2016SBB" ######
# Brach0_V2=modelFitTS(db = db[[4]], ts.col = 2, ic.col = 1, unitConverter = 1e3, 
#                                inipars=list(oneP=0.5,
#                                             parallel=c(0.01, 0.001, 0.1),
#                                             series=c(0.01, 0.001, 0.01, 0.1),
#                                             feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# 
# Brach0_V4=modelFitTS(db = db[[4]], ts.col = 4, ic.col = 2, unitConverter = 100, 
#                      inipars=list(oneP=0.5,
#                                   parallel=c(0.01, 0.001, 0.1),
#                                   series=c(0.01, 0.001, 0.01, 0.1),
#                                   feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# Brach0_V6=modelFitTS(db = db[[4]], ts.col = 6, ic.col = 3, unitConverter = 100, 
#                      inipars=list(oneP=0.5,
#                                   parallel=c(0.01, 0.001, 0.1),
#                                   series=c(0.01, 0.001, 0.01, 0.1),
#                                   feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# Brach0_V8=modelFitTS(db = db[[4]], ts.col = 8, ic.col = 4, unitConverter = 1000, 
#                      inipars=list(oneP=0.5,
#                                   parallel=c(0.01, 0.001, 0.1),
#                                   series=c(0.01, 0.001, 0.01, 0.1),
#                                   feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# Brach0_V10=modelFitTS(db = db[[4]], ts.col = 10, ic.col = 5, unitConverter = 1000, 
#                       inipars=list(oneP=0.5,
#                                    parallel=c(0.01, 0.001, 0.1),
#                                    series=c(0.01, 0.001, 0.01, 0.1),
#                                    feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# Brach0_V12=modelFitTS(db = db[[4]], ts.col = 12, ic.col = 6, unitConverter = 100, 
#                      inipars=list(oneP=0.5,
#                                   parallel=c(0.01, 0.001, 0.1),
#                                   series=c(0.01, 0.001, 0.01, 0.1),
#                                   feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# ###### ######## #########
# 
# ###### Dataset "Crow2019a" ######
# #Analysing each timeSerie of the entry Crow2019a. A file of the results will be saved in the folrder "~/sidb/manuscript/man2data/". I changed the inipars values whenever there was an error.  
# # db[[9]]$initConditions[1, 'carbonUnits']
# # db[[9]]$timeSeries[, c(2:79)]= db[[9]]$timeSeries[, c(2:70)]*1e-3
# 
# Crow_V2=modelFitTS(db = db[[9]], ts.col = 2, ic.col = 1, unitConverter = 1e3)
# 
# Crow_V3=modelFitTS(db = db[[9]], ts.col = 3, ic.col = 2, unitConverter = 1e3) #,
# #load("~/sidb/manuscript/man2data/Crow2019a_3.RData")             
# Crow_V4=modelFitTS(db = db[[9]], ts.col = 4, ic.col = 3, unitConverter = 1e3,
#               inipars=list(oneP=0.5,
#                            parallel=c(0.01, 0.001, 0.1), 
#                            series=c(0.05, 0.0001, 0.01, 0.1), 
#                            feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1))) 
# 
# Crow_V5=modelFitTS(db = db[[9]], ts.col = 5, ic.col = 4, unitConverter = 1e3)
# 
# Crow_V6=modelFitTS(db = db[[9]], ts.col = 6, ic.col = 5, unitConverter = 1e3,
#               inipars=list(oneP=0.5,
#                            parallel=c(0.01, 0.001, 0.1), 
#                            series=c(0.05, 0.0001, 0.01, 0.1), 
#                            feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))
# 
# Crow_V7=modelFitTS(db = db[[9]], ts.col = 7, ic.col = 6, unitConverter = 1e3,
#               inipars=list(oneP=0.5,
#                            parallel=c(0.01, 0.001, 0.1), 
#                            series=c(0.05, 0.0001, 0.01, 0.1), 
#                            feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))
# 
# Crow_V8=modelFitTS(db = db[[9]], ts.col = 8, ic.col = 7, unitConverter = 1e3,
#               inipars=list(oneP=0.5,
#                            parallel=c(0.01, 0.001, 0.1), 
#                            series=c(0.01, 0.0001, 0.01, 0.1), 
#                            feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)))
# 
# Crow_V9=modelFitTS(db = db[[9]], ts.col = 9, ic.col = 8, unitConverter = 1e3,
#               inipars=list(oneP=0.5,
#                            parallel=c(0.01, 0.001, 0.1), 
#                            series=c(0.01, 0.0001, 0.01, 0.1), 
#                            feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)))
# 
# Crow_V10=modelFitTS(db = db[[9]], ts.col = 10, ic.col = 9, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1), 
#                             series=c(0.01, 0.0001, 0.01, 0.1), 
#                             feedback=c(0.01, 0.001, 0.1, 0.01, 0.01)))
# 
# 
# Crow_V11=modelFitTS(db = db[[9]], ts.col = 11, ic.col = 10, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1), 
#                             series=c(0.01, 0.0001, 0.01, 0.1), 
#                             feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)))
# 
# Crow_V12=modelFitTS(db = db[[9]], ts.col = 12, ic.col = 11, unitConverter = 1e3)
# 
# Crow_V13=modelFitTS(db = db[[9]], ts.col = 13, ic.col = 12, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0005, 0.01, 0.1),
#                             feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)) )
# 
# Crow_V14=modelFitTS(db = db[[9]], ts.col = 14, ic.col = 13, unitConverter = 1e3 )
# 
# Crow_V15=modelFitTS(db = db[[9]], ts.col = 15, ic.col = 14, unitConverter = 1e3 )
# 
# Crow_V16=modelFitTS(db = db[[9]], ts.col = 16, ic.col = 15, unitConverter = 1e3 )
# 
# Crow_V17=modelFitTS(db = db[[9]], ts.col = 17, ic.col = 16, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.01, 0.0001, 0.05, 0.1),
#                             feedback=c(0.05, 0.0005, 0.1, 0.01, 0.01)))
# 
# Crow_V18=modelFitTS(db = db[[9]], ts.col = 18, ic.col = 17, unitConverter = 1e3 )
# 
# Crow_V19=modelFitTS(db = db[[9]], ts.col = 19, ic.col = 18, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.01, 0.0001, 0.05, 0.1),
#                             feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))
# 
# Crow_V20=modelFitTS(db = db[[9]], ts.col = 20, ic.col = 19, unitConverter = 1e3 )
# 
# Crow_V21=modelFitTS(db = db[[9]], ts.col = 21, ic.col = 20, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.01, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0001, 0.1, 0.01, 0.01)) )
# 
# Crow_V22=modelFitTS(db = db[[9]], ts.col = 22, ic.col = 11, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0001, 0.1, 0.01, 0.01)) )
# 
# Crow_V23=modelFitTS(db = db[[9]], ts.col = 23, ic.col = 22, unitConverter = 1e3 )
# 
# Crow_V24=modelFitTS(db = db[[9]], ts.col = 24, ic.col = 23, unitConverter = 1e3 )
# 
# Crow_V25=modelFitTS(db = db[[9]], ts.col = 25, ic.col = 24, unitConverter = 1e3 )
# 
# Crow_V26=modelFitTS(db = db[[9]], ts.col = 26, ic.col = 25, unitConverter = 1e3 )
# 
# Crow_V27=modelFitTS(db = db[[9]], ts.col = 27, ic.col = 26, unitConverter = 1e3 )
# 
# Crow_V28=modelFitTS(db = db[[9]], ts.col = 28, ic.col = 27, unitConverter = 1e3 )
# 
# Crow_V29=modelFitTS(db = db[[9]], ts.col = 29, ic.col = 28, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)) )
# 
# Crow_V30=modelFitTS(db = db[[9]], ts.col = 30, ic.col = 29, unitConverter = 1e3 )
# Crow_V31=modelFitTS(db = db[[9]], ts.col = 31, ic.col = 30, unitConverter = 1e3 )
# Crow_V32=modelFitTS(db = db[[9]], ts.col = 32, ic.col = 31, unitConverter = 1e3 )
# Crow_V33=modelFitTS(db = db[[9]], ts.col = 33, ic.col = 32, unitConverter = 1e3 )
# Crow_V34=modelFitTS(db = db[[9]], ts.col = 34, ic.col = 33, unitConverter = 1e3 )
# Crow_V35=modelFitTS(db = db[[9]], ts.col = 35, ic.col = 34, unitConverter = 1e3 )
# Crow_V36=modelFitTS(db = db[[9]], ts.col = 36, ic.col = 35, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.01, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)))
# 
# Crow_V37=modelFitTS(db = db[[9]], ts.col = 37, ic.col = 36, unitConverter = 1e2,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.1, 0.001, 0.05),
#                             series=c(0.1, 0.001, 0.05, 0.5),
#                             feedback=c(0.1, 0.001, 0.1, 0.01, 0.1)) )


# Crow_V38=modelFitTS(db = db[[9]], ts.col = 38, ic.col = 37, unitConverter = 1e3 )
# Crow_V39=modelFitTS(db = db[[9]], ts.col = 39, ic.col = 38, unitConverter = 1e3 )
# Crow_V40=modelFitTS(db = db[[9]], ts.col = 40, ic.col = 39, unitConverter = 1e3 )
# Crow_V41=modelFitTS(db = db[[9]], ts.col = 41, ic.col = 40, unitConverter = 1e3 )
# Crow_V42=modelFitTS(db = db[[9]], ts.col = 42, ic.col = 41, unitConverter = 1e3 )
# Crow_V43=modelFitTS(db = db[[9]], ts.col = 43, ic.col = 42, unitConverter = 1e3 )
# Crow_V44=modelFitTS(db = db[[9]], ts.col = 44, ic.col = 43, unitConverter = 1e3 )
# Crow_V45=modelFitTS(db = db[[9]], ts.col = 45, ic.col = 44, unitConverter = 1e3 )
# Crow_V46=modelFitTS(db = db[[9]], ts.col = 46, ic.col = 45, unitConverter = 1e3 )
# Crow_V47=modelFitTS(db = db[[9]], ts.col = 47, ic.col = 46, unitConverter = 1e3 )
# Crow_V48=modelFitTS(db = db[[9]], ts.col = 48, ic.col = 47, unitConverter = 1e3 )
# Crow_V49=modelFitTS(db = db[[9]], ts.col = 49, ic.col = 48, unitConverter = 1e3 )
# Crow_V50=modelFitTS(db = db[[9]], ts.col = 50, ic.col = 49, unitConverter = 1e3 )
# Crow_V51=modelFitTS(db = db[[9]], ts.col = 51, ic.col = 50, unitConverter = 1e3 )
# Crow_V52=modelFitTS(db = db[[9]], ts.col = 52, ic.col = 51, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.01, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)))
# Crow_V53=modelFitTS(db = db[[9]], ts.col = 53, ic.col = 52, unitConverter = 1e3 ,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)))
# Crow_V54=modelFitTS(db = db[[9]], ts.col = 54, ic.col = 53, unitConverter = 1e3 )
# Crow_V55=modelFitTS(db = db[[9]], ts.col = 55, ic.col = 54, unitConverter = 1e3,
#                     inipars=list(oneP=0.5,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.05, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))
# Crow_V56=modelFitTS(db = db[[9]], ts.col = 56, ic.col = 55, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.1, 0.001, 0.1),
#                             series=c(0.1, 0.0001, 0.1, 0.1),
#                             feedback=c(0.1, 0.001, 0.1, 0.01, 0.1)) )

# Crow_V57=modelFitTS(db = db[[9]], ts.col = 57, ic.col = 56, unitConverter = 1e3 )
# Crow_V58=modelFitTS(db = db[[9]], ts.col = 58, ic.col = 57, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )
# Crow_V59=modelFitTS(db = db[[9]], ts.col = 59, ic.col = 58, unitConverter = 1e3 )
# Crow_V60=modelFitTS(db = db[[9]], ts.col = 60, ic.col = 59, unitConverter = 1e3 )
# Crow_V61=modelFitTS(db = db[[9]], ts.col = 61, ic.col = 59, unitConverter = 1e3 )
# Crow_V62=modelFitTS(db = db[[9]], ts.col = 62, ic.col = 61, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )
# Crow_V63=modelFitTS(db = db[[9]], ts.col = 63, ic.col = 62, unitConverter = 1e3 )
# Crow_V64=modelFitTS(db = db[[9]], ts.col = 64, ic.col = 63, unitConverter = 1e3 )
# Crow_V65=modelFitTS(db = db[[9]], ts.col = 65, ic.col = 64, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1))  )
# Crow_V66=modelFitTS(db = db[[9]], ts.col = 66, ic.col = 65, unitConverter = 1e3 ,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0001, 0.01, 0.1),
#                             feedback=c(0.05, 0.0005, 0.1, 0.01, 0.1)))
# Crow_V67=modelFitTS(db = db[[9]], ts.col = 67, ic.col = 66, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.05, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )
# 
# ##
# Crow_V68=modelFitTS(db = db[[9]], ts.col = 68, ic.col = 67, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.01, 0.001, 0.1),
#                             series=c(0.01, 0.0005, 0.01, 0.1),
#                             feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1))  )
# Crow_V69=modelFitTS(db = db[[9]], ts.col = 69, ic.col = 68, unitConverter = 1e3 )
# Crow_V70=modelFitTS(db = db[[9]], ts.col = 70, ic.col = 69, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.05, 0.001, 0.1),
#                             series=c(0.5, 0.0001, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )
# Crow_V71=modelFitTS(db = db[[9]], ts.col = 71, ic.col = 70, unitConverter = 1e3)
# Crow_V72=modelFitTS(db = db[[9]], ts.col = 72, ic.col = 71, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.05, 0.001, 0.1),
#                             series=c(0.01, 0.0005, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)))
# Crow_V73=modelFitTS(db = db[[9]], ts.col = 73, ic.col = 72, unitConverter = 1e3)
# Crow_V74=modelFitTS(db = db[[9]], ts.col = 74, ic.col = 73, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.05, 0.001, 0.1),
#                             series=c(0.01, 0.0005, 0.01, 0.1),
#                             feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))
# Crow_V75=modelFitTS(db = db[[9]], ts.col = 75, ic.col = 74, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.1, 0.005, 0.1),
#                             series=c(0.01, 0.005, 0.01, 0.1),
#                             feedback=c(0.01, 0.005, 0.01, 0.01, 0.1)))
# ##
# Crow_V76=modelFitTS(db = db[[9]], ts.col = 76, ic.col = 75, unitConverter = 1e3 ,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.5, 0.001, 0.1),
#                             series=c(0.01, 0.0005, 0.01, 0.1),
#                             feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))
# Crow_V77=modelFitTS(db = db[[9]], ts.col = 77, ic.col = 76, unitConverter = 1e3)
# Crow_V78=modelFitTS(db = db[[9]], ts.col = 78, ic.col = 77, unitConverter = 1e3,
#                inipars=list(oneP=0.5,
#                             parallel=c(0.05, 0.001, 0.1),
#                             series=c(0.01, 0.0005, 0.01, 0.1),
#                             feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)))
# Crow_V79=modelFitTS(db = db[[9]], ts.col = 79, ic.col = 78, unitConverter = 1e3)
# ############# End of Crow2019a ###################
# #
# #
# ######Dataset "Haddix2011SSSJA" ######
# db[[15]]$initConditions[1, "carbonUnits"]
# # g/kg
# db[[15]]$variables$V2$units
# #"mgC/gSoil/d"
# #** Note: ** the units of variable reported in the metadata are wrong. The CO2 measeured as microG/gsoil/day.
# db[[15]]$timeSeries[, c(2:37)]= db[[15]]$timeSeries[, c(2:37)]*1e-3
# 
# Haddix_V2=modelFitTS(db = db[[15]], ts.col = 2, ic.col = 1, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.001, 0.1), 
#                                   series=c(0.1, 0.001, 0.01, 0.1), 
#                                   feedback=c(0.1, 0.001, 0.1, 0.01, 0.01)) )
# 
# Haddix_V3=modelFitTS(db = db[[15]], ts.col = 3, ic.col = 1, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.0001, 0.1), 
#                                   series=c(0.1, 0.0001, 0.01, 0.1), 
#                                   feedback=c(0.1, 0.0001, 0.1, 0.005, 0.01)))
# Haddix_V4=modelFitTS(db = db[[15]], ts.col = 4, ic.col = 1, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.001, 0.1), 
#                                   series=c(0.1, 0.001, 0.01, 0.1), 
#                                   feedback=c(0.1, 0.001, 0.1, 0.01, 0.01)))
# Haddix_V5=modelFitTS(db = db[[15]], ts.col = 5, ic.col = 2, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.001, 0.1), 
#                                   series=c(0.1, 0.001, 0.01, 0.1), 
#                                   feedback=c(0.1, 0.001, 0.05, 0.01, 0.01)))
# 
# Haddix_V6=modelFitTS(db = db[[15]], ts.col = 6, ic.col = 2, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.01, 0.001, 0.1), 
#                                   series=c(0.01, 0.001, 0.01, 0.1), 
#                                   feedback=c(0.01, 0.0001, 0.1, 0.1, 0.01)))
# Haddix_V7=modelFitTS(db = db[[15]], ts.col = 7, ic.col = 2, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.01, 0.001, 0.1), 
#                                   series=c(0.01, 0.001, 0.01, 0.1), 
#                                   feedback=c(0.05, 0.001, 0.01, 0.1, 0.01)))
# Haddix_V8=modelFitTS(db = db[[15]], ts.col = 8, ic.col = 3, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.001, 0.1), 
#                                   series=c(0.1, 0.0001, 0.01, 0.1), 
#                                   feedback=c(0.1, 0.001, 0.1, 0.01, 0.01)))
# Haddix_V9=modelFitTS(db = db[[15]], ts.col = 9, ic.col = 3, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.001, 0.1), 
#                                   series=c(0.1, 0.0001, 0.01, 0.1), 
#                                   feedback=c(0.05, 0.001, 0.1, 0.01, 0.01)))
# Haddix_V10=modelFitTS(db = db[[15]], ts.col = 10, ic.col = 3, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.01, 0.001, 0.1), 
#                                   series=c(0.1, 0.0001, 0.01, 0.1), 
#                                   feedback=c(0.1, 0.001, 0.1, 0.01, 0.01)))
# Haddix_V11=modelFitTS(db = db[[15]], ts.col = 11, ic.col = 4, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.001, 0.1), 
#                                   series=c(0.1, 0.0001, 0.01, 0.1), 
#                                   feedback=c(0.1, 0.001, 0.1, 0.01, 0.01)))
# Haddix_V12=modelFitTS(db = db[[15]], ts.col = 12, ic.col = 4, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.001, 0.1), 
#                                   series=c(0.05, 0.0001, 0.01, 0.1), 
#                                   feedback=c(0.05, 0.001, 0.01, 0.01, 0.01)))
# Haddix_V13=modelFitTS(db = db[[15]], ts.col = 13, ic.col = 4, unitConverter = 0.1, 
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.001, 0.1), 
#                                   series=c(0.1, 0.001, 0.01, 0.1), 
#                                   feedback=c(0.1, 0.001, 0.1, 0.01, 0.01)))
# 
# 
# ###### Dataset "NeffHooper2002" #######
# db[[19]]$variables$V2$units
# # "mgC/gSoilC/d"
# db[[19]]$initConditions[1,"carbonUnits"]
# # percent
# Nethooper_V2= modelFitTS(db = db[[19]], ts.col = 2, ic.col = 2, unitConverter = 10, 
#                          inipars=list(oneP=0.5,
#                                       parallel=c(0.01, 0.001, 0.01), 
#                                       series=c(0.01, 0.00001, 0.01, 0.01), 
#                                       feedback=c(0.01, 0.00001, 0.01, 0.01, 0.05)))
# Nethooper_V3= modelFitTS(db = db[[19]], ts.col = 3, ic.col = 3, unitConverter = 10, 
#                          inipars=list(oneP=0.5,
#                                       parallel=c(0.01, 0.001, 0.1), 
#                                       series=c(0.05, 0.0001, 0.01, 0.1), 
#                                       feedback=c(0.01, 0.0001, 0.01, 0.01, 0.01)))
# 
# Nethooper_V4= modelFitTS(db = db[[19]], ts.col = 4, ic.col = 4, unitConverter = 10, 
#                          inipars=list(oneP=0.5,
#                                       parallel=c(0.01, 0.001, 0.1), 
#                                       series=c(0.05, 0.0001, 0.01, 0.1), 
#                                       feedback=c(0.01, 0.0001, 0.01, 0.01, 0.01)))
# Nethooper_V5= modelFitTS(db = db[[19]], ts.col = 5, ic.col = 7, unitConverter = 10)
# ##
# Nethooper_V6= modelFitTS(db = db[[19]], ts.col = 6, ic.col = 2, unitConverter = 10)
# Nethooper_V7= modelFitTS(db = db[[19]], ts.col = 7, ic.col = 3, unitConverter = 10)
# #so many miising values
# #Nethooper_V8= modelFitTS(db = db[[19]], ts.col = 8, ic.col = 4, unitConverter = 10)
# Nethooper_V9= modelFitTS(db = db[[19]], ts.col = 9, ic.col = 7, unitConverter = 10)
# 
# Nethooper_V10= modelFitTS(db = db[[19]], ts.col = 10, ic.col = 2, unitConverter = 10, 
#                           inipars=list(oneP=0.5,
#                                        parallel=c(0.01, 0.001, 0.1), 
#                                        series=c(0.01, 0.0001, 0.01, 0.1), 
#                                        feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# 
# Nethooper_V11= modelFitTS(db = db[[19]], ts.col = 11, ic.col = 1, unitConverter = 10, 
#                           inipars=list(oneP=0.5,
#                                        parallel=c(0.01, 0.001, 0.1), 
#                                        series=c(0.05, 0.0001, 0.01, 0.1), 
#                                        feedback=c(0.05, 0.0001, 0.01, 0.01, 0.1)))
# 
# Nethooper_V12= modelFitTS(db = db[[19]], ts.col = 12, ic.col = 4, unitConverter = 10,
#                           inipars=list(oneP=0.5,
#                                        parallel=c(0.01, 0.001, 0.1), 
#                                        series=c(0.05, 0.0001, 0.01, 0.1), 
#                                        feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# 
# Nethooper_V13= modelFitTS(db = db[[19]], ts.col = 13, ic.col = 6, unitConverter = 10,
#                           inipars=list(oneP=0.5,
#                                        parallel=c(0.01, 0.001, 0.1), 
#                                        series=c(0.05, 0.0001, 0.01, 0.1), 
#                                        feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# 
# Nethooper_V14= modelFitTS(db = db[[19]], ts.col = 14, ic.col = 5, unitConverter = 10,
#                           inipars=list(oneP=0.5,
#                                        parallel=c(0.01, 0.001, 0.1), 
#                                        series=c(0.01, 0.0001, 0.01, 0.1), 
#                                        feedback=c(0.01, 0.001, 0.01, 0.1, 0.1)))
# 
# 
# ######### End of Nethooper ###########
# 
# ###### Dataset "Rey2008EJSS" ######
# db[[22]]$variables$V2$units
# # "microgC/gSoil/d"
# db[[22]]$initConditions[1, "carbonUnits"]
# # percent
# 
# ## change the units and units label of measured flux from microgC/grSoil/d to mgC/grSoil/d
# db[[22]]$timeSeries[, c(2:25)]= db[[22]]$timeSeries[, c(2:25)]*1e-3
# 
# for(i in 2:length(db[[22]]$variables[1:25])){
#   db[[22]][["variables"]][[i]][["units"]]= "mgC/gSoil/d" }
# 
# # Check if the units is correct
# # units=list(NULL)
# # for(i in 1:length(db[[22]]$variables)){
# #   units[[i]]= db[[22]][["variables"]][[i]][["units"]]
# # }
# # View(units)
# 
# Rey_V2= modelFitTS(db = db[[22]], ts.col = 2, ic.col = 1, unitConverter = 1, 
#                    inipars=list(oneP=0.5,
#                                 parallel=c(0.05, 0.001, 0.01), 
#                                 series=c(0.05, 0.001, 0.01, 0.01), 
#                                 feedback=c(0.05, 0.001, 0.01, 0.01, 0.01)))
# Rey_V3= modelFitTS(db = db[[22]], ts.col = 3, ic.col = 2, unitConverter = 1, 
#                    inipars=list(oneP=0.01,
#                                 parallel=c(0.1, 0.001, 0.01), 
#                                 series=c(0.1, 0.001, 0.01, 0.1), 
#                                 feedback=c(0.01, 0.0001, 0.1, 0.01, 0.01)))
# Rey_V4= modelFitTS(db = db[[22]], ts.col = 4, ic.col = 3, unitConverter = 1, 
#                    inipars=list(oneP=0.01,
#                                 parallel=c(0.01, 0.001, 0.01), 
#                                 series=c(0.01, 0.001, 0.001, 0.01), 
#                                 feedback=c(0.01, 0.001, 0.01, 0.01, 0.01)))
# Rey_V5= modelFitTS(db = db[[22]], ts.col = 5, ic.col = 4, unitConverter = 1, 
#                    inipars=list(oneP=0.01,
#                                 parallel=c(0.01, 0.001, 0.01), 
#                                 series=c(0.01, 0.0001, 0.01, 0.01), 
#                                 feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# Rey_V6= modelFitTS(db = db[[22]], ts.col = 6, ic.col = 5, unitConverter = 1, 
#                    inipars=list(oneP=0.01,
#                                 parallel=c(0.01, 0.001, 0.01), 
#                                 series=c(0.01, 0.0001, 0.01, 0.1), 
#                                 feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# Rey_V7= modelFitTS(db = db[[22]], ts.col = 7, ic.col = 6, unitConverter = 1, 
#                    inipars=list(oneP=0.01,
#                                 parallel=c(0.1, 0.001, 0.01), 
#                                 series=c(0.01, 0.0001, 0.01, 0.1), 
#                                 feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# Rey_V8= modelFitTS(db = db[[22]], ts.col = 8, ic.col = 7, unitConverter = 1, 
#                    inipars=list(oneP=0.01,
#                                 parallel=c(0.1, 0.001, 0.01), 
#                                 series=c(0.1, 0.001, 0.01, 0.01), 
#                                 feedback=c(0.1, 0.001, 0.1, 0.01, 0.1)))
# 
# Rey_V9= modelFitTS(db = db[[22]], ts.col = 9, ic.col = 8, unitConverter = 1, 
#                    inipars=list(oneP=0.01,
#                                 parallel=c(0.1, 0.001, 0.1), 
#                                 series=c(0.1, 0.001, 0.1, 0.1), 
#                                 feedback=c(0.1, 0.001, 0.1, 0.01, 0.1)))
# Rey_V10= modelFitTS(db = db[[22]], ts.col = 10, ic.col = 9, unitConverter = 1, 
#                    inipars=list(oneP=0.1,
#                                 parallel=c(0.1, 0.001, 0.1), 
#                                 series=c(0.01, 0.0001, 0.01, 0.1), 
#                                 feedback=c(0.01, 0.001, 0.1, 0.01, 0.1)))
# 
# Rey_V11= modelFitTS(db = db[[22]], ts.col = 11, ic.col = 10, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.1, 0.001, 0.1), 
#                                  series=c(0.1, 0.001, 0.01, 0.1), 
#                                  feedback=c(0.1, 0.001, 0.1, 0.01, 0.1)))
# 
# Rey_V12= modelFitTS(db = db[[22]], ts.col = 12, ic.col = 11, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)))
# 
# Rey_V13= modelFitTS(db = db[[22]], ts.col = 13, ic.col = 12, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)))
# Rey_V14= modelFitTS(db = db[[22]], ts.col = 14, ic.col = 13, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.001, 0.1, 0.01, 0.1)))
# ### More NA value
# Rey_V15= modelFitTS(db = db[[22]], ts.col = 15, ic.col = 14, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)))
# Rey_V16= modelFitTS(db = db[[22]], ts.col = 16, ic.col = 15, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.001, 0.1, 0.01, 0.1)))
# Rey_V17= modelFitTS(db = db[[22]], ts.col = 17, ic.col = 16, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# Rey_V18= modelFitTS(db = db[[22]], ts.col = 18, ic.col = 17, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.001, 0.001, 0.01, 0.1)))
# Rey_V19= modelFitTS(db = db[[22]], ts.col = 19, ic.col = 18, unitConverter = 1, 
#                     inipars=list(oneP=0.01,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.001, 0.001, 0.01, 0.1)))
# Rey_V20= modelFitTS(db = db[[22]], ts.col = 20, ic.col = 19, unitConverter = 1, 
#                     inipars=list(oneP=0.1,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# Rey_V21= modelFitTS(db = db[[22]], ts.col = 21, ic.col = 20, unitConverter = 1, 
#                     inipars=list(oneP=0.1,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# Rey_V22= modelFitTS(db = db[[22]], ts.col = 22, ic.col = 21, unitConverter = 1, 
#                     inipars=list(oneP=0.1,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# Rey_V23= modelFitTS(db = db[[22]], ts.col = 23, ic.col = 22, unitConverter = 1, 
#                     inipars=list(oneP=0.1,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.001, 0.1), 
#                                  feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# Rey_V24= modelFitTS(db = db[[22]], ts.col = 24, ic.col = 23, unitConverter = 1, 
#                     inipars=list(oneP=0.1,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.0001, 0.01, 0.1), 
#                                  feedback=c(0.01, 0.001, 0.01, 0.01, 0.1)))
# Rey_V25= modelFitTS(db = db[[22]], ts.col = 25, ic.col = 24, unitConverter = 1, 
#                     inipars=list(oneP=0.1,
#                                  parallel=c(0.01, 0.001, 0.1), 
#                                  series=c(0.01, 0.001, 0.001, 0.5), 
#                                  feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# ###### End of Ray2008#########
# 
# 
# ############ Start with Sierra2017BG ############
# #All models needs to be revised
# # The respiration unit is microgr C/day
# # th unit of iniC is still unclear
db[[24]]$timeSeries[, c(2:17)]= db[[24]]$timeSeries[, c(2:17)]*1e-3

# Sierra_V2=modelFitTS(db = db[[24]], ts.col = 2, ic.col = 1, unitConverter = 0.01,
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.5, 0.01, 0.5),
#                                   series=c(0.5, 0.01, 0.01, 0.5),
#                                   feedback=c(0.1, 0.01, 0.01, 0.1, 0.5)))
# 
# ##
# Sierra_V3=modelFitTS(db = db[[24]], ts.col = 3, ic.col = 1, unitConverter = 0.01,
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.5, 0.01, 0.5),
#                                   series=c(0.5, 0.01, 0.01, 0.5),
#                                   feedback=c(0.1, 0.01, 0.01, 0.1, 0.5)))
# Sierra_V4=modelFitTS(db = db[[24]], ts.col = 4, ic.col = 1, unitConverter = 0.01,
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.5, 0.01, 0.5),
#                                   series=c(0.5, 0.01, 0.01, 0.5),
#                                   feedback=c(0.5, 0.01, 0.1, 0.01, 0.1)))
# Sierra_V5=modelFitTS(db = db[[24]], ts.col = 5, ic.col = 1, unitConverter = 0.01,
#                      inipars=list(oneP=0.01,
#                                   parallel=c(0.1, 0.05, 0.5),
#                                   series=c(0.1, 0.01, 0.01, 0.5),
#                                   feedback=c(0.1, 0.01, 0.5, 0.01, 0.5)))
# Sierra_V6=modelFitTS(db = db[[24]], ts.col = 6, ic.col = 1, unitConverter = 0.1,
#                      inipars=list(oneP=0.5,
#                                   parallel=c(0.01, 0.001, 0.1),
#                                   series=c(0.01, 0.001, 0.01, 0.1),
#                                   feedback=c(0.01, 0.001, 0.1, 0.01, 0.1)))
# 
# Sierra_V7=modelFitTS(db = db[[24]], ts.col = 7, ic.col = 1, unitConverter = 0.1,
#                       inipars=list(oneP=0.5,
#                                    parallel=c(0.1, 0.001, 0.1),
#                                    series=c(0.1, 0.001, 0.01, 0.1),
#                                    feedback=c(0.01, 0.001, 0.1, 0.01, 0.1)))
# 
# Sierra_V8=modelFitTS(db = db[[24]], ts.col = 8, ic.col = 1, unitConverter = 0.1, 
#                       inipars=list(oneP=0.1,
#                                    parallel=c(0.1, 0.001, 0.01),
#                                    series=c(0.1, 0.001, 0.01, 0.1),
#                                    feedback=c(0.1, 0.001, 0.01, 0.1, 0.1)))
# Sierra_V9=modelFitTS(db = db[[24]], ts.col = 9, ic.col = 1, unitConverter = 0.1, 
#                      inipars=list(oneP=0.1,
#                                   parallel=c(0.1, 0.001, 0.01),
#                                   series=c(0.1, 0.001, 0.01, 0.1),
#                                   feedback=c(0.1, 0.001, 0.01, 0.1, 0.1)))
# 
# Sierra_V10=modelFitTS(db = db[[24]], ts.col = 10, ic.col = 1, unitConverter = 0.1, 
#                       inipars=list(oneP=0.1,
#                                    parallel=c(0.1, 0.01, 0.1),
#                                    series=c(0.05, 0.005, 0.01, 0.1),
#                                    feedback=c(0.05, 0.005, 0.01, 0.01, 0.1)))
# 
# Sierra_V11=modelFitTS(db = db[[24]], ts.col = 11, ic.col = 1, unitConverter = 0.01, 
#                       inipars=list(oneP=0.1,
#                                    parallel=c(0.1, 0.001, 0.01),
#                                    series=c(0.05, 0.0005, 0.01, 0.1),
#                                    feedback=c(0.05, 0.0005, 0.01, 0.01, 0.1)))
# 
# Sierra_V12=modelFitTS(db = db[[24]], ts.col = 12, ic.col = 1, unitConverter = 0.1, 
#                       inipars=list(oneP=0.5,
#                                    parallel=c(0.05, 0.005, 0.5),
#                                    series=c(0.05, 0.0005, 0.05, 0.5),
#                                    feedback=c(0.05, 0.0005, 0.5, 0.05, 0.5)))
# 
# Sierra_V13=modelFitTS(db = db[[24]], ts.col = 13, ic.col = 1, unitConverter = 0.01, 
#                       inipars=list(oneP=0.01,
#                                    parallel=c(0.5, 0.005, 0.5),
#                                    series=c(0.05, 0.005, 0.05, 0.5),
#                                    feedback=c(0.05, 0.005, 0.005, 0.05, 0.5)))
# 
# Sierra_V14=modelFitTS(db = db[[24]], ts.col = 14, ic.col = 1, unitConverter = 0.1, 
#                       inipars=list(oneP=0.01,
#                                    parallel=c(0.5, 0.005, 0.5),
#                                    series=c(0.5, 0.005, 0.05, 0.5),
#                                    feedback=c(0.1, 0.001, 0.01, 0.01, 0.1)))
# 
#revise
# Sierra_V15=modelFitTS(db = db[[24]], ts.col = 15, ic.col = 1, unitConverter = 0.01, 
#                       inipars=list(oneP=0.01,
#                                    parallel=c(0.5, 0.005, 0.5),
#                                    series=c(0.05, 0.005, 0.05, 0.5),
#                                    feedback=c(0.05, 0.005, 0.05, 0.05, 0.5)))
# 
# Sierra_V16=modelFitTS(db = db[[24]], ts.col = 16, ic.col = 1, unitConverter = 0.1, 
#                       inipars=list(oneP=0.01,
#                                    parallel=c(0.5, 0.005, 0.5),
#                                    series=c(0.05, 0.005, 0.05, 0.5),
#                                    feedback=c(0.05, 0.005, 0.005, 0.05, 0.5)))
# 
# Sierra_V17=modelFitTS(db = db[[24]], ts.col = 17, ic.col = 1, unitConverter = 0.1, 
#                       inipars=list(oneP=0.5,
#                                    parallel=c(0.5, 0.005, 0.5),
#                                    series=c(0.5, 0.005, 0.05, 0.5),
#                                    feedback=c(0.1, 0.001, 0.01, 0.01, 0.1)))

######## End of Sierra2017 ########
#
#
#db=loadEntries(path="~/sidb/data/")
#
# # Winkler_V11=modelFitTS(db = db[[30]], ts.col = 11, ic.col = 1, unitConverter = 1,
# #                        inipars=list(oneP=0.05,
# #                                     parallel=c(0.01, 0.001, 0.1),
# #                                     series=c(0.01, 0.0001, 0.01, 0.1),
# #                                     feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))
# 
# # Winkler_V12=modelFitTS(db = db[[30]], ts.col = 12, ic.col = 3, unitConverter = 1,
# #                        inipars=list(oneP=0.05,
# #                                     parallel=c(0.01, 0.001, 0.1),
# #                                     series=c(0.01, 0.0001, 0.01, 0.1),
# #                                     feedback=c(0.01, 0.0001, 0.01, 0.01, 0.1)))

####### End of dataset Winkler1996 #######
#
#
####### Dataset "Zhang2007" ########
db[[31]]$variables$V2$units
# "mgC/gC/day"
db[[31]]$initConditions[1, "carbonUnits"]
# percent

Zhang_V2=modelFitTS(db = db[[31]], ts.col = 2, ic.col = 1, unitConverter = 10, 
                    inipars=list(oneP=0.5,
                                 parallel=c(0.1, 0.01, 0.1), 
                                 series=c(0.1, 0.01, 0.01, 0.1), 
                                 feedback=c(0.1, 0.01, 0.01, 0.1, 0.1)))


Zhang_V3=modelFitTS(db = db[[31]], ts.col = 3, ic.col = 2, unitConverter = 10, 
                    inipars=list(oneP=0.5,
                                 parallel=c(0.1, 0.01, 0.1), 
                                 series=c(0.1, 0.001, 0.01, 0.1), 
                                 feedback=c(0.1, 0.01, 0.01, 0.01, 0.1)))

Zhang_V4=modelFitTS(db = db[[31]], ts.col = 4, ic.col = 3, unitConverter = 10, 
                    inipars=list(oneP=0.5,
                                 parallel=c(0.1, 0.01, 0.1), 
                                 series=c(0.1, 0.001, 0.01, 0.1), 
                                 feedback=c(0.1, 0.001, 0.01, 0.01, 0.1)))

Zhang_V5=modelFitTS(db = db[[31]], ts.col = 5, ic.col = 1, unitConverter = 10, 
                    inipars=list(oneP=0.5,
                                 parallel=c(0.1, 0.01, 0.1), 
                                 series=c(0.1, 0.01, 0.01, 0.1), 
                                 feedback=c(0.1, 0.01, 0.01, 0.1, 0.1)))

Zhang_V6=modelFitTS(db = db[[31]], ts.col = 6, ic.col = 2, unitConverter = 10, 
                    inipars=list(oneP=0.01,
                                 parallel=c(0.1, 0.01, 0.1), 
                                 series=c(0.1, 0.01, 0.01, 0.1), 
                                 feedback=c(0.1, 0.01, 0.01, 0.1, 0.1)))

Zhang_V7=modelFitTS(db = db[[31]], ts.col = 7, ic.col = 3, unitConverter = 10, 
                    inipars=list(oneP=0.01,
                                 parallel=c(0.1, 0.05, 0.1), 
                                 series=c(0.1, 0.01, 0.01, 0.1), 
                                 feedback=c(0.1, 0.01, 0.01, 0.1, 0.1)))




