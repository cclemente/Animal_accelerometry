

##### Set the main directory for all folders
setwd("F:/Gliding Project/Brushtail_Possums/Damien/processed_training_data")

#get list of filenames in subject directory
filenames <- (Sys.glob("*.csv"))

#build an empty data frame to store our data
data_out<-data.frame(file=NA, time=NA, meanX=NA, meanY=NA, meanZ=NA, 
                     maxx=NA, maxy=NA, maxz=NA, 
                     minx=NA, miny=NA, minz=NA,
                     sdx=NA,  sdy=NA, sdz=NA, 
                     SMA=NA,  minODBA=NA, maxODBA=NA, minVDBA=NA, maxVDBA=NA, 
                     sumODBA=NA, sumVDBA=NA, 
                     corXY=NA, corXZ=NA, corYZ=NA, 
                     skx=NA,  sky=NA, skz=NA, 
                     kux=NA,  kuy=NA, kuz=NA, 
                     act=NA)
data_out<-data_out[-1,]


for (ii in 1:length(filenames)){
  dat<-read.csv(filenames[ii])
  data_out<-rbind(data_out,dat)
}

write.csv(data_out, paste0('possum','_combined.csv'))



