
```R

### Plot behaviours with associated energy expenditure ###

##Load libraries##
library(tidyverse)
#install.packages("tidyverse")

##set working directory##
setwd("D:/")

##read in data
dat <- read.csv("Mahogany_Glider_Training_Combined_New.csv")
##read in rda file to save time 
load(file= "Possum_training_combined_new.rda")

##read in csv of behaviour activity codes###
aCodes <- read.csv("Mahog_Glider_Behaviour_Act_Number.csv")
names(aCodes)[2] <- "act"
dat <- left_join(dat, aCodes) 
unique(dat$activity)
#dat$activity <- dat$Activity

##Combine behaviours that can be grouped as the same behaviour if you need too###
ind<-which(dat$activity=='Vertical_Jump_Up' | dat$activity=='Horizontal_Jump' | dat$activity=='Vertical_Jump_Down'| dat$activity=='Bounding_Climb')
levels(dat$activity) <- c(levels(dat$activity), "Jumping")
dat$activity[ind]<-'Jumping'
dat$activity <- as.factor(dat$activity)
dat$activity<-droplevels(dat$activity)
unique(dat$activity)
## remove NAs
dat <- na.omit(dat)

##dat$activity[which(dat$activity == "Cllimbing")] <- "Climb"
##levels(dat$activity)

##Aggregate the mean maxVeDBA by activity###
agg_dat<-aggregate(dat$maxVDBA, by=list(dat$activity), FUN=mean)
##Reorder the code so that the behaviours are shown from low to high
agg_dat<-agg_dat[order(agg_dat$x),]
agg_dat$Group.1
dat$activity<-factor(dat$activity, levels=agg_dat$Group.1)
table(agg_dat$x)

##save the file 
write.csv(agg_dat, "glider_hi_low_activity.csv")


##Lets make the plot!
##install packages and load libraries
install.packages('colorRamp')
library(colorRamps)
library(RColorBrewer)

##save the colour pallete as an object
pal <- colorRampPalette(c("blue", "red"))
#par(mar=c(9,4,1,1))

##col=pal(12) is for how many behaviours you have, so change as you need to. 
boxplot(log10(maxVDBA) ~ activity, las = 2, dat, col=pal(12),
        ylab = "Log10(MaxVeDBA (g))", xlab = "")

```

