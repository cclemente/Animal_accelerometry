## Set working Dir ##
setwd("")

## read in file names ## 
filenames<-Sys.glob("*.csv")
#ii=2 #check iterations
NaTot = 0 ## check How many NAs are left in files

## loop for cleaning
for (ii in 3:length(filenames)){
  
  dat <- read.csv(filenames[ii])
  
  
  dat$corXY[which(dat$sdx=="0")] = 1 ## set CorXY to 1 when sdx is 0
  dat$corXY[which(dat$sdy=="0")] = 1 ## set CorXY to 1 when sdy is 0
  
  dat$corXZ[which(dat$sdx=="0")] = 1 ## set CorXZ to 1 when sdx is 0
  dat$corXZ[which(dat$sdz=="0")] = 1 ## set CorXZ to 1 when sdz is 0
  
  dat$corYZ[which(dat$sdz=="0")] = 1 ## set CorYZ to 1 when sdz is 0
  dat$corYZ[which(dat$sdy=="0")] = 1 ## set CorYZ to 1 when sdy is 0
  
  dat$skx[is.na(dat$skx)] <- 0 ## set skx NAs to 0
  dat$sky[is.na(dat$sky)] <- 0 ## set sky NAs to 0
  dat$skz[is.na(dat$skz)] <- 0 ## set skz NAs to 0
  
  dat <- dat[,1:28] ## Trim off unwanted variables (kurtosis)
  
  NaTot <- NaTot+sum(is.na(dat)) ## Record number of NAs still present in files
  
  
  
  #write out file and print iteration for timing
  write.csv(dat, paste0(substr(filenames[ii],1, nchar(filenames[ii])-4),"_cleaned.csv"))
  print(ii)
}