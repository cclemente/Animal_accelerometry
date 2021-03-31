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

#then the function cleans up the data for the SOM
ind <- biboff %>% group_by(biboff$act) %>% sample_frac(.8)
trDat<-trSamp2(ind)

#remaining 20%
tstind<-subset(biboff, !(biboff$X %in% ind$X))
tstDat<-trSamp2(ind)


library(parallel)
numCores <- detectCores()
numCores

#install.packages('foreach')
library(foreach)

#install.packages('doParallel')
library(doParallel)
registerDoParallel(numCores)  # use multicore, set to the number of our cores

somsize<-rep(seq(4,9,1),6) #acc
somsize2<-rep(4:9, times=1, each=6)
somsize3<-cbind(somsize,somsize2)


acc3 <- matrix()
system.time(
  acc3<-foreach(i = 1:36, .packages=c('kohonen'), .combine=rbind) %dopar% {
    #acc[i,] <- doSOM(biboff, samples[i])
    doSOM(trDat,tstDat, somsize3[i,1], somsize3[i,2])
    #print(i)
  }
)

head(acc3)

boxplot(swatting~shape, subset(acc3, test=='ACCU'))

write.csv(acc3, 'SOMshape2.csv')
acc3<-read.csv('SOMshape.csv')


long_DF <- acc3 %>% gather(behaviour, acc, 'bite/hold':watching)
head(long_DF)
boxplot(acc~shape, subset(long_DF, test=='ACCU'))
boxplot(acc~shape+test, long_DF)

# Load the lattice package
library("lattice")

acc4<-subset(long_DF, test=='ACCU')

#make heat map 
df1<-data.frame(acc=acc4$acc, width=acc4$width, height=acc4$height)

#creates a matrix
df2<-with(df1, tapply(acc, list(shape = width, height), FUN= mean, na.rm=TRUE))

#CREATE OWN COLOURMAP
colours_heat3 = c('#F4E119', '#F7C93B', '#C4BB5F', '#87BE76', '#59BD87', '#2CB6A0', '#00AAC1', '#1B8DCD', '#3D56A6', '#3A449C')

#LATTICE PLOT
levelplot(t(df2), cex.axis=1.0, cex.lab=1.0, col.regions=colorRampPalette(rev(colours_heat3)), 
          screen = list(z = -90, x = -60, y = 0),
          xlab=list(label='height', cex = 1.0),
          ylab=list(label='width', cex = 1.0),
          main=list(label='shape', cex=1.0), 
          colorkey=list(labels=list(cex=1.0)),
          scales = list(cex=1.0),
          asp=1)



#######
#### functions ####
#######



#SOM function
#SOM function
doSOM <- function(trDat, tstDat, z, zz) { # Draw a sample of size 10k from all biboff, build a SOM, predict to rest data and compute overall accuracy
  #ind <- sample(nrow(x), y) # Indices for training sample - random sample of y bib-off observations for cats
  #trDat <- trSamp(x, n = ind)
  #tstDat <- trSamp(x, n = -ind)
  time_out<-system.time(
    ssom <- supersom(trDat, grid = somgrid(z, zz, "hexagonal"))
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
  myDF <- cbind(test = rownames(dat_out), dat_out, time=time_out[3], width=z, height=zz)
  return(myDF)
}

# A custom function to make life easier
trSamp <- function(x, n = 1:nrow(x)) { # Creates a traning or test matrix, from data frame x, using a sample of size n (default is all rows)			
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


