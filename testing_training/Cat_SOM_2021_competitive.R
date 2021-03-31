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
dFold <- "J:/cat code/Analysis 2021"
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

#sample only 80% of the training data
#then the function cleans up the data for the SOM
ind <- biboff %>% group_by(biboff$act) %>% sample_frac(.8)
trDat<-trSamp2(ind)

#remaining 20%
tstind<-subset(biboff, !(biboff$X %in% ind$X))
tstDat<-trSamp2(ind)


time_out<-system.time(
ssom2 <- supersom(trDat, grid = somgrid(7, 7, "hexagonal")) 		
)
time_out[3]

SOMout<-doSOM(trDat, tstDat, 7, 1000)


###run the doSOM loop in parallel

library(parallel)
numCores <- detectCores()
numCores

#install.packages('foreach')
library(foreach)

#install.packages('doParallel')
library(doParallel)
registerDoParallel(numCores)  # use multicore, set to the number of our cores


somsize<-rep(seq(1000,10000,1000),2) #acc

acc3 <- matrix()
system.time(
  acc3<-foreach(i = 1:10, .packages=c('kohonen'), .combine=rbind) %dopar% {
    doSOM(trDat, tstDat, 7, somsize[i])
    }
)

head(acc3)

boxplot(swatting~shape, subset(acc3, test=='ACCU'))

gc()


#######
#### functions ####
#######


#SOM function
doSOM <- function(trDat, tstDat, z, a) { # Draw a sample of size 10k from all biboff, build a SOM, predict to rest data and compute overall accuracy
  #ind <- sample(nrow(x), y) # Indices for training sample - random sample of y bib-off observations for cats
  #trDat <- trSamp(x, n = ind)
  #tstDat <- trSamp(x, n = -ind)
  time_out<-system.time(
  ssom <- supersom(trDat, rlen=a, grid = somgrid(z, z, "hexagonal"))
  )
  ssom.pred <- predict(ssom, newdata = tstDat)
  ptab <- table(predictions = ssom.pred$predictions$activity, activity = tstDat$activity)
  
  true_positives  <- diag(ptab)
  false_positives <- rowSums(ptab) - true_positives
  false_negatives <- colSums(ptab) - true_positives
  true_negatives  <- sum(ptab) - true_positives - false_positives - false_negatives
  
  SENS<-c(true_positives/(true_positives+false_negatives), shape=z)
  ##Precision - how often a model is right when it predicts a behaviour
  PREC<-c(true_positives/(true_positives+false_positives), shape=z)
  #Specifitity -how often the absense of the behaviour is correctly identified by the model
  SPEC<-c(true_negatives/(true_negatives+false_positives), shape=z)
  #Accuracy - How often the model is right
  ACCU<-c((true_positives+true_negatives)/(true_positives+true_negatives+false_positives+false_negatives), shape=z)
  
  dat_out<-as.data.frame(rbind(SENS,PREC,SPEC,ACCU))
  myDF <- cbind(test = rownames(dat_out), dat_out, time=time_out[3], rlen=a)
  return(myDF)
}

# A custom function to make life easier
trSamp <- function(x, n = 1:nrow(x)) { # Creates a training or test matrix, from data frame x, using a sample of size n (default is all rows)			
  d <- x[n, 4:31] # Random sample of 10 000 rows of the data
  act <- as.factor(x$activity[n]) # Corresponding activities
  out <- list(measurements = as.matrix(d), activity = act)
  return(out)
}

# A custom function to make life easier
trSamp2 <- function(x) { # Creates a training or test matrix, from data frame x, using a sample of size n (default is all rows)			
  d <- x[,4:31] # Random sample of 10 000 rows of the data
  act <- as.factor(x$activity) # Corresponding activities
  out <- list(measurements = as.matrix(d), activity = act)
  return(out)
}



