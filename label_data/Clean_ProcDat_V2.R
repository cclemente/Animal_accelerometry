## Set working Dir ##
setwd("E:/projects/CATS/12 cats cleaned/Maple test #2/Split files/Maple_processed/bibon")
setwd("E:/projects/CATS/12 cats cleaned/Coco/Split files/Coco_1_processed/biboff/uncleaned")#17/06/21
setwd('E:/projects/CATS/12 cats cleaned/Coco/Split files/Coco_1_processed/bibon')#17/06/21

setwd('E:/projects/CATS/12 cats cleaned/Freddie/Split files/Freddie processed/biboff')#17/06/21
setwd('E:/projects/CATS/12 cats cleaned/Freddie/Split files/Freddie processed/bibon')#17/06/21

setwd('F:/CATS/12 cats cleaned/Jett/split')#18/06/21
setwd('F:/CATS/12 cats cleaned/Max/split')#18/06/21
setwd('F:/CATS/12 cats cleaned/Obi/split')#18/06/21


## read in file names ## 
filenames<-Sys.glob("*.csv")
#ii=1 #check iterations
NaTot = 0 ## check How many NAs are left in files


## loop for cleaning
for (ii in 1:length(filenames)){
  
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
  
  
  ##Check for the right columns
  ## 31 columns , x, file, time, data....
  dat <- dat[,1:28] ## Trim off unwanted variables (kurtosis)
  #dat <- dat[,2:29] ## Trim off unwanted variables (kurtosis)
  
  NaTot <- NaTot+sum(is.na(dat)) ## Record number of NAs still present in files
  
  
  
  #write out file and print iteration for timing
  write.csv(dat, paste0(substr(filenames[ii],1, nchar(filenames[ii])-4),"_cleaned.csv"))
  print(ii)
  
  if (ii == length(filenames)){
    beep()
  }
  
}





beep <- function(n = 3){
  for(i in seq(n)){
    system("rundll32 user32.dll,MessageBeep -1")
    Sys.sleep(1.5)
  }
}


