library(lubridate)
setwd('F:/Gliding Project/Possum Align')

file='AX4_Flip_090221_150221_S1.csv'

dat<-read.table(file, header = TRUE, sep=',')


x = as.POSIXlt(parse_date_time(dat$Timestamp, '%d/%m/%Y %I:%M:%S %p'), tz = "UTC")
days = as.numeric(as.Date(x)) #extract days since 1970-1-1
frac.day = (((x$hour)*3600) + ((x$min)*60) + x$sec)/86400
dat$datenum = 719529 + days + frac.day

dat_out<-data.frame(dat$datenum,dat$X,dat$Y,dat$Z)

newfile=paste0('reformat_',file)
write.table( dat_out, file=newfile, sep=",",  col.names=FALSE, row.names=FALSE)

#time=as.POSIXct((datenum[1] - 719529)*86400, origin = "1970-01-01", tz = "UTC")


