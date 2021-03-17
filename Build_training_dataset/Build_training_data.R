library(moments)

##### Set the main directory for all folders
setwd("F:/Gliding Project/Brushtail_Possums/Damien/Matlab_split_010820/accel output")

#get list of filenames in subject directory
filenames <- (Sys.glob("*.txt"))

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

#a for loop to run through all the files from each video
for (ii in 1:length(filenames)){
  #ii=1
  print(filenames[ii])
  
  data<-read.csv(filenames[ii], sep='', header=F, colClasses="numeric" )
  options("digits"=19)
  
  #define epoch length to be 50 samples long
  # at 50Hz this should be about 1sec per epoch
  st=1
  fn=50
  
  #a while loop to run through the accelerometer data which 
  #continues until it gets the the end of the accelerometer file
  
                  while(fn<nrow(data)){
                    
                    dat1=data[st:fn,]
                    
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
                    
                    
                    # ##Frequency peaks in each axis
                    # fs=50
                    # f.s=50 ##Accelerometer sampling rate (Hz)
                    # x=1:length(dat1$V2)/fs
                    # smoothingSplinex = smooth.spline(x, dat1$V2, spar=0.5)
                    # smoothingSpliney = smooth.spline(x, dat1$V3, spar=0.5)
                    # smoothingSplinez = smooth.spline(x, dat1$V4, spar=0.5)
                    # 
                    # #plot(smoothingSplinex$y,lty=1, type = "l",col= 'green')
                    # 
                    # fx_out<-fpeaks(spec(smoothingSplinex$y, f=f.s), nmax=1, plot=F) * 1000
                    # fy_out<-fpeaks(spec(smoothingSpliney$y, f=f.s), nmax=1, plot=F) * 1000
                    # fz_out<-fpeaks(spec(smoothingSplinez$y, f=f.s), nmax=1, plot=F) * 1000
                    
                    #Time of epoch
                    time=as.POSIXct((dat1$V1[1] - 719529)*86400, origin = "1970-01-01", tz = "UTC")
                    
                    #as.POSIXct((737444.36684 - 719529)*86400, origin = "1970-01-01", tz = "UTC")
                    
                    #find the most common behaviours from the 1 second epoch
                    act=as.numeric(names(which.max(table(dat1$V5))))
                    
                    dat_temp<-data.frame(file=filenames[ii], time=time, meanX=meanX, meanY=meany, meanZ=meanz,
                                         maxx=maxx, maxy=maxy, maxz=maxz, 
                                         minx=minx, miny=miny, minz=minz,
                                         sdx=sdx,  sdy=sdy, sdz=sdz, 
                                         SMA=SMA,  minODBA=minODBA, maxODBA=maxODBA, minVDBA=minVDBA, maxVDBA=maxVDBA, 
                                         sumODBA=sumODBA, sumVDBA=sumVDBA, 
                                         corXY=corXY, corXZ=corXZ, corYZ=corYZ, 
                                         skx=skx,  sky=sky, skz=skz, 
                                         kux=kux,  kuy=kuy, kuz=kuz,
                                         act=act)
                    
                    data_out<-rbind(data_out,dat_temp)
                    #increments the loop by one sample
                    #e.g. 1:50, then 2:51
                    st=st+1
                    fn<-fn+1
                    
                }#end while loop
  
  
}#ends for loop


write.csv(data_out, paste0(filenames[ii],'_processed.csv'))


}#ends directory change loop
