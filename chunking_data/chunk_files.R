


##### Set the main directory for all folders
setwd("E:/projects/CATS/12 cats cleaned/Coco/Split files")

#get list of filenames in subject directory
filenames <- (Sys.glob("*.csv"))

#check the filename is correct
ii=1
filename[ii]

data<-read.csv(filenames[ii], header=F, colClasses="numeric" )

# Applying split() function
test<-split(data, ceiling(seq_along(data$V1) / 100000))

names1<-strsplit(filenames[ii], '.csv')

for (jj in 1:length(test)){
write.csv(test[[jj]],paste0(names1,'_',as.character(jj),'.csv'))
}


