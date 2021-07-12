

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

