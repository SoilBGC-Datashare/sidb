###### libraries #######
rm(list=ls())
##################
##### load the results of model fitting######
df=read.csv(file = "~/SOIL-R/Theses/Mina/sidb/SidB_ModFit.csv")
############################
# str(df)
# levels(df$TimeSeries)

## filter the dataframe with lowest AIC 
bestMod=df %>% 
  group_by(TimeSeries) %>% 
  slice_min(AICn)

BM <- table(bestMod$Model)
BM
# oneP twoFP twoPP twoSP 
# 131     0    27     0 

chisq.test(BM)
p1 <- bestMod %>% 
  ggplot(aes(Model))+
  geom_bar(width = 0.1)

#Based on AIC there was only two models for each timeSeries that had the minimum. 
bestMod %>% filter(Model== "twoFP"& Model=="twoSP" ) #==> results 0 

bestMod_BIC=df %>%  
  group_by(TimeSeries) %>% 
  slice_min(BIC)

p2 <- bestMod_BIC %>% 
  ggplot(aes(Model))+
  geom_bar(width = 0.1)

p1 + p2
bestMod %>% 
  ggplot(aes(Model))+
  geom_histogram(binwidth = 0.1)



load("~/sidb/manuscript/RDataFiles/Bracho2016SBB_10.RData")
AIC=Bracho2016SBB_10$AIC
AICn=Bracho2016SBB_10$AICn
BIC=Bracho2016SBB_10$BIC
AIC
AICn
BIC
ms=Bracho2016SBB_10$`Mean squared residulas`
aic=n*log(ms) + 2*k
bic=n*log(ms) + K* log(n)
Bracho2016SBB_10$`one-pool`$FMEmodel$df.residual

lapply(Brach2016SBB_10, function(x){
  
})

nrow(db$Bracho2016SBB$timeSeries)
length(db$Bracho2016SBB$variables)
n=lapply(db, function(x){
  nrow(x$timeSeries)
})
n

n1=unlist(n)
rownames(as.data.frame(n1) )

names(db$Bracho2016SBB$variables)
br= paste0(db$Bracho2016SBB$citationKey, "_", names(db$Bracho2016SBB$variables))

flux=SoilR::getReleaseFlux(Bracho2016SBB_10$`one-pool`$SoilRmodel)
plot(flux)
Bracho2016SBB_10$`one-pool`$SoilRmodel@solverfunc

k1= lapply(myList, function(x){
  x$k1
})
k1=as.data.frame(do.call(rbind, k1))
names(k1) <- c("oneP", "twoPP", "twoSP", "twoFP")
k1$TimeSeries <- row.names(k1)
df_k1 <- pivot_longer(data = k1, cols= c(oneP, twoPP, twoSP, twoFP), 
                       names_to = "Model", values_to = "k1")
head(df_k1, n = 20)
