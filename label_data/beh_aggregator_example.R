####Extract data for Behaviour Data #####

#### Packages ####
library(kohonen)
library(lubridate)
library(tidyverse)
# library(hms)
# library(forcats)
library(dplyr)

#####
##### Aggregate Behaviors #####

## Working Directory of SOM ##
setwd('J:/cat code/master SOM cats/MSOMS_70')

#load the SOM
load(file = "Cat_SOM_Biboff_9by8.rda") # Load in SOM 

#check the SOM
plot(MSOM)


## Working Directory of files that have been cleaned ##
setwd("E:/projects/CATS/12 cats cleaned/Coco/Split files/Coco_1_processed/bibon")

# ii=1 ## For checking first file

filenames <- Sys.glob("*.csv") ## Load in files of one Subject
beh_agg <- data.frame() ## data frame for loop
Ttime<- matrix() ## variable for timing prediction

#add any important variables here (e.g. conditions) 
bib_status = 'OFF'


##### Functions #####
trSamp2 <- function(x) { # Creates a training or test matrix, from data frame x, using a sample of size n (default is all rows)			
  #d <- x[,5:29] # select only the data rows
  d <- dat %>% select(meanX:skz)
  act <- as.factor(x$activity)
  # Corresponding activities
  out <- list(measurements = as.matrix(d), activity = act)
  return(out)
}
#####



### Loop for predicting data ###

for (ii in 1:length(filenames)){

sttime<-Sys.time() ### for timing 
dat <- read.csv(filenames[ii]) ## read in file

# ##clean the data
# ##cleaning logic

##################################################
### run file Clean_ProcDat_V2.R on the data first
#################################################


#######################################
### run function trSamp2 (line ~122) ###
#######################################

dat2 <- trSamp2(dat) ## coerce data into appropriate format for predict

ssom.pred <- predict(MSOM, newdata = dat2$measurements, whatmap = 1) # predict behaviors

### Create our new dataframe ###
dat3 <- dat[ , c( "file", "time")]
dat3$subject <- str_split(dat3$file, "_", simplify = TRUE)[1]## insert subject
dat3$time<-as.character(dat3$time)
dat3$hours<- hour(dat3$time)## insert hour
dat3$days<-day(dat3$time)## insert day
dat3$behaviors <- ssom.pred$predictions$activity ##insert behaviors
dat3$behaviors <- fct_explicit_na(dat3$behaviors, "Unknown") ## change NA to factor unknown
dat3$bib <- bib_status

#saves the raw behaviour
save(dat3, file=paste0(getwd(),'/raw_behaviour/', str_split(dat3$file[1], '.csv')[[1]][1],'behaviour','.rda'))

## aggregate behavior counts by behaviour, subject, days, and hours ##
temp_agg <- aggregate(dat3$behaviors, by=list(behaviors = dat3$behaviors, subject=dat3$subject, days=dat3$days, hours=dat3$hours, bib=dat3$bib), 
                     FUN = length)

beh_agg <- rbind(beh_agg,temp_agg) # store for total output of subject



### Output approximate time left ###
Ttime<- rbind(Ttime,(Sys.time()-sttime)) #store duration of iteration
jj = round(((mean(Ttime, na.rm = TRUE))*(length(filenames)-ii))/60, digits = 2) # average duration * remaining files; in minutes
message("\r", paste0("approx. ", jj, " minute/s remaining"), appendLF = FALSE) # code to overwrite console line


}

####END OF LOOP

getwd()

head(beh_agg, 20) #check columns
levels(beh_agg$behaviors) #check behaviors represented

## add in additional factors ##
beh_agg$sex <- "Male" ## Sex


setwd('F:/CATS/12 cats cleaned/Obi/split')#20/06/21
write.csv(beh_agg, "beh_agg_Obi_Biboff_10_by_10.csv") ##Write out .csv

#####


boxplot(x~behaviors, beh_agg)









#####
##### Functions #####
##old function

trSamp2 <- function(x) { # Creates a training or test matrix, from data frame x, using a sample of size n (default is all rows)			
  d <- x[,5:29] # select only the data rows
  act <- as.factor(x$activity)
  # Corresponding activities
  out <- list(measurements = as.matrix(d), activity = act)
  return(out)
}
#####















##### Random Plotting Stuff #####

pie(beh_agg$x[which(beh_agg$hour=='17')], labels = beh_agg$behaviours[which(beh_agg$hour=='17')])
levels(dat3$behaviors)


dat3 <- read.csv("beh_agg_Coco_Biboff.csv")
dat3<-dat3[,2:8]
head(dat3)

findat <-aggregate(dat3$x, by=list(behaviors = dat3$behaviors), FUN = sum)

pie(findat$x/sum(findat$x), labels = dat3$behaviors)


