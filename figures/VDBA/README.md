

This first part is just to combine multiple separate VDBA file together 

```R


##find number of files in folder
folder <- ("D:/cat code/Analysis 2021/VDBA_processed_data/cat VDBA data")#red USB
filenames <- list.files(folder, pattern = "*.rda")

agg_out<-data.frame()

#this step just groups all the OBDA data together
for (kk in 1:16){
test_str<-paste0(folder,'/',filenames[kk])
load(test_str)

dat3$time<-as.character(dat3$time)
dat3$hours<-hour(dat3$time)
dat3$days<-day(dat3$time)
dat_agg <- aggregate(dat3[,3:8], by=list(hour=dat3$hours, days=dat3$days, subject=dat3$subject, bib=dat3$bib), FUN = mean)
agg_out<-rbind(agg_out,dat_agg)
}

#write it out to make future analysis easier. 
write.csv(agg_out, 'agg_out2.csv')

setwd(folder)
agg_out<-read.csv('agg_out2.csv')

```

Some different figures to explore changes per hour 

```R


pal <- colorRampPalette(c('darkgrey', 'orange', "darkgrey"))
boxplot(maxVDBA~hour, agg_out, col=pal(24))

biboff<-agg_out[which(agg_out$bib=='OFF'),]
bibon<-agg_out[which(agg_out$bib=='ON'),]

boxplot(maxVDBA~hour, biboff, col=pal(24), main='Grey = BibON, Blue = BibOFF', xlab='hour')
boxplot(maxVDBA~hour, bibon, col=pal(24))


boxplot(maxVDBA~bib+hour, agg_out, col=c('grey','blue'), main='Grey = BibOFF, Blue = BibON', axes=FALSE, frame.plot=TRUE, xlab='hours')
Axis(side=1, labels=FALSE, xlab='hours')
Axis(side=2, labels=TRUE)

#try some statistics (basic at this stage) 
fit<-aov(maxVDBA~bib*subject, agg_out)
summary(fit)

#explore subject
boxplot(maxVDBA~bib+subject, agg_out, col=c('grey','blue'))

```


