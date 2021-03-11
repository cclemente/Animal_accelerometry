#install.packages("moments")
library(moments)

########################parallel testing
#install.packages('parallel')
library(parallel)
numCores <- detectCores()
numCores

#install.packages('foreach')
library(foreach)

#install.packages('doParallel')
library(doParallel)
registerDoParallel(numCores)  # use multicore, set to the number of our cores

#########################end parrallel


##### Set the main directory for all folders
setwd("E:/projects/CATS/12 cats cleaned/Coco/Split files")

#cleans up memory
gc()

#get list of filenames in subject directory
filenames <- (Sys.glob("*.csv"))


  #for loop to run through all the files from each chunk
for (ii in 1:length(filenames)){
   
  #print the file names so we can see the progress
  print(filenames[ii])
  
  #clean up the data  
  options("digits"=19)
  data<-read.csv(filenames[ii], header=F, skip = 1)
  data<-data[,2:5]
  colnames(data)<-c('V1', 'V2', 'V3', 'V4')
  
  #define epoch length to be 50 samples long
  # at 50Hz this should be about 1sec per epoch

  acc2 <- matrix()
  
  #this is the main loop. You will need to run the doAccloop function below
  system.time(
    acc2<-foreach(jj = 1:(nrow(data)-50), .packages=c('moments'), .combine=rbind) %dopar% {
      doAccloop(jj,data)
    }
  )
  
  
  #give each file a unique name
  name<-substr(filenames[ii], 1, (nchar(filenames[ii])-4))
 write.csv(acc2, paste0(name,'_processed.csv'))

}#ends for loop for file names




#function that runs the analysis
#jj=1
doAccloop <- function(jj, data) { # Creates a traning or test matrix, from data frame x, using a sample of size n (default is all rows)			
  
  dat1=data[jj:(jj+50),]
  
  meanX=mean(dat1$V2)
  meany=mean(dat1$V3)
  meanz=mean(dat1$V4)
  
  maxx=max(dat1$V2)
  maxy=max(dat1$V3)
  maxz=max(dat1$V4)
  
  minx=min(dat1$V2)
  miny=min(dat1$V3)
  minz=min(dat1$V4)
  
  sdx=sd(dat1$V2)
  sdy=sd(dat1$V3)
  sdz=sd(dat1$V4)
  
  ##Signal Magnitude Area
  SMA<-(sum(abs(dat1$V2))+sum(abs(dat1$V3))+sum(abs(dat1$V4)))/nrow(dat1)
  
  ##Overall and Vectorial Dynamic Body Acceleration
  ODBA<-abs(dat1$V2)+abs(dat1$V3)+abs(dat1$V4)#vector
  VDBA<-sqrt(dat1$V2^2+dat1$V3^2+dat1$V4^2)#vector
  
  minODBA<-min(ODBA)
  maxODBA<-max(ODBA)
  
  minVDBA<-min(VDBA)
  maxVDBA<-max(VDBA)
  
  sumODBA<-sum(ODBA)
  sumVDBA<-sum(VDBA)
  
  ##Correlation between axes
  corXY<-cor(dat1$V2,dat1$V3)
  corXZ<-cor(dat1$V2,dat1$V4)
  corYZ<-cor(dat1$V3,dat1$V4)
  
  ##Skewness in each axis
  skx<-skewness(dat1$V2)
  sky<-skewness(dat1$V3)
  skz<-skewness(dat1$V4)
  
  ##kurtosis in each axis
  kux<-kurtosis(dat1$V2)
  kuy<-kurtosis(dat1$V3)
  kuz<-kurtosis(dat1$V4)
  
  #Time of epoch - this works for AX3 time input only
  time=as.POSIXct((dat1$V1[1] - 719529)*86400, origin = "1970-01-01", tz = "UTC")
  
  dat_temp<-data.frame(file=filenames[ii], time=time, meanX=meanX, meanY=meany, meanZ=meanz,
                       maxx=maxx, maxy=maxy, maxz=maxz, 
                       minx=minx, miny=miny, minz=minz,
                       sdx=sdx,  sdy=sdy, sdz=sdz, 
                       SMA=SMA,  minODBA=minODBA, maxODBA=maxODBA, minVDBA=minVDBA, maxVDBA=maxVDBA, 
                       sumODBA=sumODBA, sumVDBA=sumVDBA, 
                       corXY=corXY, corXZ=corXZ, corYZ=corYZ, 
                       skx=skx,  sky=sky, skz=skz, 
                       kux=kux,  kuy=kuy, kuz=kuz)
  
  return(dat_temp)
}
