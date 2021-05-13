# Training a SOM using the categorised data
# Written by Dave S
# For Nicole Galea
# June 2019
#editted by Josh G 09/04/2021

#This code steps you through the creation of your SOM from the 
#preparation of your DATA, to finding the appropriate SHAPE, and
#OPTIMISATION of your SOMs accuracy.

#using an 80:20 split in the data

### Packages ###
install.packages("tidyverse")
library(tidyverse)
install.packages("kohonen")
library(kohonen)
install.packages("RColorBrewer")
library(RColorBrewer)
install.packages("data.table")
library(data.table)
install.packages("sentimentr")
library(sentimentr)
install.packages("glue")
library(lattice)

##### PREPARE YOUR SOM DATA ###
##    This step loads in your SOM data and attaches the activities. You will
##    need your data, and a .csv with your behaviours numbered. If any of
##    variables are over-represented use the CODE on lines 52-54 to reduce 
##    them to an appropriate number. The code then uses the function trSamp2(ln 295)
##    to split the data into 80:20 for Training and Testing respectively.

#### DATA PREP #####

# Folders
dFold <- "G:/Gliding Project/Brushtail_Possums/Processed_Training_Data"
setwd(dFold)

gc()
# Prep the data for the SOM
#dat <- read.csv("Brushtail_Possum_Training_Combined.csv")
load("Brushtail_Possum_Training_Combined.rda")

##cleaning logic
J_Dat$corXY[which(J_Dat$sdx=='0' | J_Dat$sdy=='0')]=1
J_Dat$corXZ[which(J_Dat$sdx=='0' | J_Dat$sdz=='0')]=1
J_Dat$corYZ[which(J_Dat$sdy=='0' | J_Dat$sdz=='0')]=1

#removes the kutosis predictor
J_Dat2<-J_Dat[,-c(30:32)]

#set the skewedness to be zero if no variation in data
J_Dat2$skx[is.na(J_Dat2$skx)]=0
J_Dat2$sky[is.na(J_Dat2$sky)]=0
J_Dat2$skz[is.na(J_Dat2$skz)]=0


dat <- J_Dat2
dat <- na.omit(dat)
act <- unique(dat$act)
possum <- unique(dat$subject)
#Bib <- levels(dat$Bib)

aCodes <- read.csv("Possum_Behaviour_Act_Numbers.csv")
names(aCodes)[2] <- "act"
dat <- left_join(dat, aCodes) 
unique(dat$activity)
# Merge in the activity codes
 # We have loads of data...dump NAs
##Check how many NA's you have
#dat_NA <- na.omit(dat)

#remove all unknow activities
dat<-dat[which(dat$act!='0'),]

#Combine all jumping into one behaviour
ind<-which(dat$activity=='Bounding_Climb' | dat$activity=='Vertical_Jump_Up' | dat$activity=='Vertical_Jump_Down' | dat$activity=='Horizontal_Jump' )

levels(dat$activity) <- c(levels(dat$activity), "Jumping")
dat$activity[ind]<-'Jumping'
dat$activity<-droplevels(dat$activity)


##Check how many activities you have)
barplot(table(dat$activity))
head(dat)


## REMOVE excess data points for over-represented behaviours
## REMOVE 120000 random Sitting variables
# sit_ind <- which(dat$activity=='Sitting') ## find which data is the activity
# sit_ind_remove <- sit_ind[sample(length(sit_ind), 120000)] ## select random number
# dat2<-dat[-sit_ind_remove,] ## remove them
# 
# ## REMOVE 120000 random Lying.Resting variables
# res_ind <- which(dat2$activity=='Lying.Resting') #find which data is the activity
# res_ind_remove <- res_ind[sample(length(res_ind), 390000)]## select random number
# dat3<-dat2[-res_ind_remove,] ## remove them

#then the function cleans up the data for the SOM
ind <- dat %>% group_by(dat$act) %>% sample_frac(.8)
trDat<-trSamp2(ind)
barplot(table(trDat$act))


#remaining 20%
tstind<-subset(dat, !(dat$X.1 %in% ind$X.1))
tstDat<-trSamp2(tstind)
barplot(table(tstDat$act))

save(trDat, file = "new_trDat_11B.rda")
save(tstDat, file = "new_tstDat_11B.rda")


##### OPTOMISE SHAPE OF SOM ###
##    This test helps define the most accurate shape for your SOM. It uses
##    parallel processing to achieve this (packages listed below), and the 
##    function doSOM(line 255). Firstly, we set the shape of the SOMs to be
##    tested. Then run the foreach code(line 100, this will take some time).
##    Laslty, we will create a heat map which that represents how accurate 
##    each SOM shape is for your data. Adjust ehaviours on line 112 and 118.

#### SOM SHAPE TEST ####

library(parallel)
numCores <- detectCores()
numCores <- 6

#install.packages('foreach')
library(foreach)

#install.packages('doParallel')
library(doParallel)
registerDoParallel(numCores)  # use multicore, set to the number of our cores


##see which shape ios the best (10 times)
for (bb in 1:10) {
  

somsize<-rep(seq(4,9,1),6) #acc
somsize2<-rep(4:9, times=1, each=6)
somsize3<-cbind(somsize,somsize2)

acc3list <- matrix()
system.time(
  acc3list<-foreach(i = 1:36, .packages=c('kohonen'), .combine=rbind) %dopar% {
    #acc[i,] <- doSOM(biboff, samples[i])
    doSOMperf(trDat,tstDat, somsize3[i,1], somsize3[i,2])
    #print(i)
  }
)


acc3<-acc3list
#head(acc3)
#tail(acc3)

#boxplot(Bounds~shape.somsize, subset(acc3, test=='ACCU'))

#write.csv(acc3, 'SOMshape2.csv')
#acc3<-read.csv('SOMshape2.csv')


long_DF <- acc3 %>% gather(behaviour, acc, Bounding_Ground:Jumping)
#head(long_DF)
#boxplot(acc~shape.somsize, subset(long_DF, test=='ACCU'))
#boxplot(acc~shape.somsize+test, long_DF)

# Load the lattice package
#library("lattice")

acc4<-subset(long_DF, test=='PREC')

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
          main=list(label= paste0('PREC'), cex=1.0), 
          colorkey=list(labels=list(cex=1.0)),
          scales = list(cex=1.0),
          asp=1)
}
#####



##### OPTOMISE ACCURACY OF SOM ###
##    Create an Original(MASTER) SOM, and some additional testing variables.
##    RUN the for loop on line 172-236 that creates a NEW SOM and compares
##    the NEW SOM to the MASTER SOM, choosing the better SOM as the new
##    MASTER. On line 173 this is set to run for 200 iterations but less or
##    more can be used. Lastly, we can compare the original MASTER SOM to
##    our new MASTER SOM (ln 238-239), which iteration of the loop the new SOM 
##    was chosen(ln 236) and how many times the MASTER SOM was replaced(ln 237).

#### COMPETITIVE SOM TEST ####



system.time(
ssom <- supersom(trDat, grid = somgrid(7, 7, "hexagonal"))
)
system.time(
ssom.pred <- predict(ssom, newdata = tstDat)
)
ptab <- table(predictions = ssom.pred$predictions$activity, activity = tstDat$activity)


## Create Original Master SOM
acc5  <- doSOM(trDat,tstDat, 7, 7) ## outputs list(SOM, somperf)



MSPerf  <- acc5$somperf ## Retrieve performance from list
MSOM <- acc5$SOM ## Retrieve NEW SOM from list
Iter = 0 ## Check which Iteration of the loop produced the Optimised SOM
Chng = 0 ## Check how often the SOM has changed

#Loop to compare NEW SOMs to MASTER SOM
system.time(
  for (uu in 1:20){ #Run this for as many as is needed, 10 seems to produce high predictability?
    #uu=1
    
    # Creating our NEW SOM to compete against ORIGINAL MASTER SOM
    NS <-doSOM(trDat,tstDat, 7, 7) ## outputs list(SOM, somperf)
    
    NSPerf <- NS$somperf ## Retrieve performance from list
    NSOM <- NS$SOM ## Retrieve NEW SOM from list
    
    ## Comparison Variables
    comp95 <- sum(NSPerf[,2:12]<0.95) - sum(MSPerf[,2:12]<0.95) ## Compare how many variables are predicting below 95%
    comp90 <- sum(NSPerf[,2:12]<0.90) - sum(MSPerf[,2:12]<0.90) ## Compare how many variables are predicting below 90%
    comp80 <- sum(NSPerf[,2:12]<0.80) - sum(MSPerf[,2:12]<0.80) ## Compare how many variables are predicting below 80%
    
    
    ## Compare how many variables have improved in prediction
    compsom <- as.data.frame(NSPerf[,2:12])- as.data.frame(MSPerf[,2:12]) #Subrtacts MASTER SOM from NEW SOM
    CS <- (sum(compsom>0) - sum(compsom<0)) 
    #if cs is positive, New is better. If negative old is better
    
    ## Nested if statements to compare these variables and find the better SOM
    
    if (comp80 < 0){
      MSPerf <- NSPerf ## REPLACE SOM Performance statistics
      MSOM <- NSOM ## REPLACE Master SOM
      Iter = uu ## RECORD Iterations taken to get best SOM
      Chng = Chng+1 ## RECORD number of times SOM is replaced
      next ## NEW LOOP
    } else if (comp80 > 0){
      next ## NEW LOOP
    } else if (comp80 == 0){
      if (comp90 < 0){
        MSPerf <- NSPerf ## REPLACE SOM Performance statistics
        MSOM <- NSOM ## REPLACE Master SOM
        Iter = uu #RECORD Iterations taken to get best SOM
        Chng = Chng+1 ## RECORD number of times SOM is replaced
        next #NEW LOOP
      } else if (comp90 > 0){
        next #NEW LOOP
      } else if (comp90 == 0){
        if (comp95 < 0){
          MSPerf <- NSPerf ## REPLACE SOM Performance statistics
          MSOM <- NSOM ## REPLACE Master SOM
          Iter = uu #RECORD Iterations taken to get best SOM
          Chng = Chng+1 ## RECORD number of times SOM is replaced
          next #NEW LOOP
        } else if (comp95 > 0){
          next #NEW LOOP
        } else if (comp95 == 0){
          if (CS > 0){
            MSPerf <- NSPerf ## REPLACE SOM Performance statistics
            MSOM <- NSOM ## REPLACE Master SOM
            Iter = uu #RECORD Iterations taken to get best SOM
            Chng = Chng+1 ## RECORD number of times SOM is replaced
            next #NEW LOOP
          } else {next}
        }
      }
    } 
    
    
    
  }
)
#### Compare ORIGINAL SOM to NEW MASTER SOM
print(Iter)
print(Chng)
acc5$somperf[,2:12]
MSPerf[,2:12]
#####

#make the plot
colsch <- colorRampPalette(c("#A6CEE3" ,"#1F78B4" ,"#B2DF8A" ,"#33A02C", "#FB9A99" ,"#E31A1C", "#FDBF6F" ,"#FF7F00" ,"#CAB2D6", "#6A3D9A", "#FFFF99"))
cols2<-brewer.pal(11, 'Set3')
plot(MSOM, heatkey = TRUE, palette.name=colsch, type = "codes", shape = "straight", ncolors = 11)
ssom
plot(ssom, heatkey = TRUE, palette.name=colsch, type = "codes", shape = "straight", ncolors = 14)

#outputting the data for later
save(MSOM, file="MSOM_7by7.rda")

ssom.pred <- predict(MSOM, newdata = tstDat)
ptab <- table(predictions = ssom.pred$predictions$activity, activity = tstDat$activity)

#Save SOM figure
#SAVE grid figures
save(ptab, file =  "MSOM_7by7_Confusion_Matrix.rda")
write.csv(ptab, "MSOM_7by7_Confusion_Matrix.csv")



#####
#### FUNCTIONS ####
#SOM function
#SOM function
  
z=7
zz=7

doSOMperf <- function(trDat, tstDat, z, zz) { 
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
  SOMout <- list(SOM = ssom, somperf = myDF)
  
  return(SOMout)
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
  d <- x[,5:29] # Random sample of 10 000 rows of the data
  act <- as.factor(x$activity) # Corresponding activities
  out <- list(measurements = as.matrix(d), activity = act)
  return(out)
}

str(trDat)
#####

