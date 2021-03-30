# Training a SOM using the categorised data
# Written by Dave S
# For Nicole Galea
# June 2019
#editted by Christofer 30/03/2021

#this code will hopefully build a competitive SOM. 
#using an 80:20 split in the data

library(tidyverse)
library(kohonen)
library(RColorBrewer)
library(data.table)

# Folders
dFold <- "D:/cat code/Analysis 2021"
setwd(dFold)

# Prep the data for the SOM
dat <- read.csv("allAct.csv")
act <- unique(dat$act)
Cat <- unique(dat$Cat)
Bib <- levels(dat$Bib)


aCodes <- read.csv("cat behaviour activity numbers.csv")
names(aCodes)[2] <- "act"
dat <- left_join(dat, aCodes) # Merge in the activity codes
dat <- na.omit(dat) # We have loads of data...dump NAs


biboff <- filter(dat, Bib == "of")
bibon <- filter(dat, Bib == "on")

##tester row
ind <- sample(nrow(biboff), 100000)
trDat <- trSamp(biboff, n = ind)
tstDat <- trSamp(biboff, n = -ind)
ssom <- supersom(trDat, grid = somgrid(7, 7, "hexagonal")) 				
ssom.pred <- predict(ssom, newdata = tstDat)
ptab <- table(predictions = ssom.pred$predictions$activity, activity = tstDat$activity)

true_positives  <- diag(ptab)
false_positives <- rowSums(ptab) - true_positives
false_negatives <- colSums(ptab) - true_positives
true_negatives  <- sum(ptab) - true_positives - false_positives - false_negatives

sum(c((true_positives+true_negatives)/(true_positives+true_negatives+false_positives+false_negatives)))/12

y=100000
##sENSITIVTY
SENS<-c(true_positives/(true_positives+false_negatives),samples=y)
##Precision - how often a model is right when it predicts a behaviour
PREC<-c(true_positives/(true_positives+false_positives),samples=y)
#Specifitity -how often the absense of the behaviour is correctly identified by the model
SPEC<-c(true_negatives/(true_negatives+false_positives),samples=y)
#Accuracy - How often the model is right
ACCU<-c((true_positives+true_negatives)/(true_positives+true_negatives+false_positives+false_negatives),samples=y)

sum(ACCU[1:12])/12


SOMout<-doSOM(biboff, 10000, 7)

library(parallel)
numCores <- detectCores()
numCores

#install.packages('foreach')
library(foreach)

#install.packages('doParallel')
library(doParallel)
registerDoParallel(numCores)  # use multicore, set to the number of our cores



somsize<-rep(seq(4,10,1),10) #acc

acc3 <- matrix()
system.time(
  acc3<-foreach(i = 1:length(somsize), .packages=c('kohonen'), .combine=rbind) %dopar% {
    #acc[i,] <- doSOM(biboff, samples[i])
    doSOM(biboff, 20000, somsize[i])
    #print(i)
  }
)

head(acc3)

boxplot(swatting~shape, subset(acc3, test=='ACCU'))

write.csv(acc3, 'SOMshape.csv')

long_DF <- acc3 %>% gather(behaviour, acc, 'bite/hold':watching)
head(long_DF)
boxplot(acc~shape, subset(long_DF, test=='SENS'))
boxplot(acc~shape+test, long_DF)


#######
#### functions ####
#######



#SOM function
doSOM <- function(x, y, z) { # Draw a sample of size 10k from all biboff, build a SOM, predict to rest data and compute overall accuracy
  ind <- sample(nrow(x), y) # Indices for training sample - random sample of y bib-off observations for cats
  trDat <- trSamp(x, n = ind)
  tstDat <- trSamp(x, n = -ind)
  ssom <- supersom(trDat, grid = somgrid(z, z, "hexagonal")) 				
  ssom.pred <- predict(ssom, newdata = tstDat)
  ptab <- table(predictions = ssom.pred$predictions$activity, activity = tstDat$activity)
  
  true_positives  <- diag(ptab)
  false_positives <- rowSums(ptab) - true_positives
  false_negatives <- colSums(ptab) - true_positives
  true_negatives  <- sum(ptab) - true_positives - false_positives - false_negatives
  
  SENS<-c(true_positives/(true_positives+false_negatives),samples=y, shape=z)
  ##Precision - how often a model is right when it predicts a behaviour
  PREC<-c(true_positives/(true_positives+false_positives),samples=y, shape=z)
  #Specifitity -how often the absense of the behaviour is correctly identified by the model
  SPEC<-c(true_negatives/(true_negatives+false_positives),samples=y, shape=z)
  #Accuracy - How often the model is right
  ACCU<-c((true_positives+true_negatives)/(true_positives+true_negatives+false_positives+false_negatives),samples=y, shape=z)
  
  dat_out<-as.data.frame(rbind(SENS,PREC,SPEC,ACCU))
  myDF <- cbind(test = rownames(dat_out), dat_out)
  return(myDF)
}

# A custom function to make life easier
trSamp <- function(x, n = 1:nrow(x)) { # Creates a traning or test matrix, from data frame x, using a sample of size n (default is all rows)			
  d <- x[n, 4:31] # Random sample of 10 000 rows of the data
  act <- as.factor(x$activity[n]) # Corresponding activities
  out <- list(measurements = as.matrix(d), activity = act)
  return(out)
}


