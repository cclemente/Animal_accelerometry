


##### Set the main directory for all folders
setwd("E:/projects/CATS/12 cats cleaned/Coco/Split files")

#get list of filenames in subject directory
filenames <- (Sys.glob("*.csv"))

#check the filename is correct
ii=1
filename[ii]

#used for formating the interger in the for loop
frmt <- "d"

data<-read.csv(filenames[ii], header=F, colClasses="numeric" )

# Applying split() function
test<-split(data, ceiling(seq_along(data$V1) / 100000))

#gets the name of the big accel file
names1<-strsplit(filenames[ii], '.csv')


#modified so the chunked files are now numbered with an interger padded with zeros e.g. 001, 002
#this way the files are in the correct order when read back into R in the next step. 
for (jj in 1:length(test)){
ij <- formatC(jj, width = 3, format = frmt, flag = "0")
write.csv(test[[jj]],paste0(names1,'_',ij,'.csv'))
}


