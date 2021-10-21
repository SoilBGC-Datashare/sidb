####### packages and plot themes########

rm(list=ls())
packs <- c('sidb', 'tidyverse', 'patchwork')
sapply(packs, require, character.only=TRUE)

theme_set(theme_bw(base_line_size = 0) )#+
            # theme(axis.text=element_text(size=14),
            #       axis.title=element_text(size=18), #,face="bold"
            #       legend.text=element_text(size=14),
            #       strip.text = element_text(size=14)) )
##############################################
# load the database of sidb
db=loadEntries(path="~/sidb/data/")

# # load the RData files
files <- list.files(path = "~/sidb/manuscript/RDataFiles", 
                    pattern="*.RData", full.names = TRUE)
myList<- lapply(files, function(x) {
  load(file = x)
  get(ls())
})

nameFile <- list.files(path = "~/sidb/manuscript/RDataFiles/", full.names = FALSE, recursive = FALSE)
names(myList) <- nameFile 
# There is problem with loading following RData files. The RData files are okay and we can load them manualy. But the lapply function missed the files.

#Therefore I would use a manual method to load the missing data and add it to myList.
## Following lines will be deleted asap I was able to find what is the problem.
load('~/sidb/manuscript/RDataFiles/Zhang2007_2.RData')
load('~/sidb/manuscript/RDataFiles/Zhang2007_3.RData')
load('~/sidb/manuscript/RDataFiles/Zhang2007_4.RData')
load('~/sidb/manuscript/RDataFiles/Zhang2007_5.RData')
load('~/sidb/manuscript/RDataFiles/Zhang2007_6.RData')
load('~/sidb/manuscript/RDataFiles/Zhang2007_7.RData')

mylist=list(myList[1:152], Zhang2007_2)
Zhang=list(Zhang2007_2,Zhang2007_3, Zhang2007_4, Zhang2007_5, Zhang2007_6, Zhang2007_7)
nameFile <- list.files(path = "~/sidb/manuscript/RDataFiles/", full.names = FALSE, recursive = FALSE)

names(Zhang) <- nameFile[153:158]
myList=c(myList[1:152], Zhang)
######## ##########
# Now all the RData files have been loaded as a large list

# Clean the Environment
rm(files, mylist ,nameFile, Zhang, Zhang2007_2,Zhang2007_3, 
   Zhang2007_4, Zhang2007_5, Zhang2007_6, Zhang2007_7)




##### Statistics #####

# A list of AIC for all entries
AIC=lapply(myList, function(x){x$AIC})

aic=as.data.frame(do.call(rbind, AIC))
names(aic) <- c("oneP", "twoPP", "twoSP", "twoFP")
aic$TimeSeries <- row.names(aic)

# Change the df from wide dataset to a longer
df_aic <- pivot_longer(data = aic, cols= c(oneP, twoPP, twoSP, twoFP), 
                   names_to = "Model", values_to = "AIC")

# return the table to the original shape
# df_wide <- pivot_wider(data = df, id_cols = TimeSeries, names_from = Model, values_from = AIC)

##### AICn ######
AICn=lapply(myList, function(x){x$AICn})
aicn=as.data.frame(do.call(rbind, AICn))
names(aicn) <- c("oneP", "twoPP", "twoSP", "twoFP")
aicn$TimeSeries <- row.names(aicn)
df_aicn <- pivot_longer(data = aicn, cols= c(oneP, twoPP, twoSP, twoFP), 
                       names_to = "Model", values_to = "AICn")

SidB_DF <- left_join(df_aic, df_aicn, by=c("TimeSeries", "Model"))
##### AICc ######
AICc=lapply(myList, function(x){x$AICc})
AICc=as.data.frame(do.call(rbind, AICc))
names(AICc) <- c("oneP", "twoPP", "twoSP", "twoFP")
AICc$TimeSeries <- row.names(AICc)
df_AICc <- pivot_longer(data = AICc, cols= c(oneP, twoPP, twoSP, twoFP), 
                        names_to = "Model", values_to = "AICc")

SidB_DF <- left_join(SidB_DF, df_AICc, by=c("TimeSeries", "Model"))
##### BIC ######
BIC=lapply(myList, function(x){x$BIC})
BIC=as.data.frame(do.call(rbind, BIC))
names(BIC) <- c("oneP", "twoPP", "twoSP", "twoFP")
BIC$TimeSeries <- row.names(BIC)
df_BIC <- pivot_longer(data = BIC, cols= c(oneP, twoPP, twoSP, twoFP), 
                       names_to = "Model", values_to = "BIC")
SidB_DF <- left_join(SidB_DF, df_BIC, by=c("TimeSeries", "Model"))
##### Weighted AIC ######
wi=lapply(myList, function(x){x$`Wighted AIC`})
wi=as.data.frame(do.call(rbind, wi))
names(wi) <- c("oneP", "twoPP", "twoSP", "twoFP")
wi$TimeSeries <- row.names(wi)
df_wi <- pivot_longer(data = wi, cols= c(oneP, twoPP, twoSP, twoFP), 
                        names_to = "Model", values_to = "wi")

SidB_DF <- left_join(SidB_DF, df_wi, by=c("TimeSeries", "Model"))
###### Mean transit time #####
MTT=lapply(myList, function(x){x$TransitTime})
MTT=as.data.frame(do.call(rbind, MTT))
names(MTT) <- c("oneP", "twoPP", "twoSP", "twoFP")
MTT$TimeSeries <- row.names(MTT)
df_MTT <- pivot_longer(data = MTT, cols= c(oneP, twoPP, twoSP, twoFP), 
                      names_to = "Model", values_to = "MTT")

###### Mean transit time #####
SSR=lapply(myList, function(x){x$`Sum of squared residuals`})
SSR=as.data.frame(do.call(rbind, SSR))
names(SSR) <- c("oneP", "twoPP", "twoSP", "twoFP")
SSR$TimeSeries <- row.names(SSR)
df_SSR <- pivot_longer(data = SSR, cols= c(oneP, twoPP, twoSP, twoFP), 
                       names_to = "Model", values_to = "SSR")




SidB_DF <- left_join(SidB_DF, df_SSR, by=c("TimeSeries", "Model"))



write.table(SidB_DF, file = "~/SOIL-R/Theses/Mina/sidb/SidB_ModFit.csv",
            row.names=FALSE, 
            na="NA",col.names=TRUE, sep=",")
##### plots #########

p1 <- ggplot(SidB_DF, aes(Model, AIC))+
  geom_boxplot()
p2 <- ggplot(SidB_DF, aes(Model, AICn))+
  geom_boxplot()
p3 <- ggplot(SidB_DF, aes(Model, AICc))+
  geom_boxplot()
p4 <- ggplot(SidB_DF, aes(Model, BIC))+
  geom_boxplot()


(p1 + p2) / (p3 + p4)

##########
## Looking at some more data
SidB_DF %>% 
  #filter(!MTT>1e3) %>% 
  ggplot(aes(Model, MTT))+
  geom_boxplot()

SidB_DF %>% 
  ggplot(aes(Model, wi))+
  geom_boxplot()+
  ylab("Weighted AIC")

RayV10 <- myList$Rey2008EJSS_9.RData
RayV10$`Sum of squared residuals`


# 
# ggplot(SidB_DF, aes(x=as.numeric(rownames(SidB_DF)),y=AIC, color=Model))+
#   geom_point()
# 
# 
# 
# plot(aic$twoFP, type = "p", pch=20, ylim = c(-5, 16))
# points(aic$twoPP, pch=20, col="red")
# points(aic$twoSP, pch=22, col="green")
# points(aic$oneP, pch=23, col="blue")

####
# What is next: looking at the selected model for each time serie and find out which model has been selected. and also if a model has been selected, how often this is the case. ==> the frequency in percentage. 

