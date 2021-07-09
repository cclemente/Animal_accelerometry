
# label Unknown data

Once you have created your SOM through [Step 4](https://github.com/cclemente/Animal_accelerometry/tree/main/testing_training) we will use that SOM to label your Unknown data from [Step 5](https://github.com/cclemente/Animal_accelerometry/tree/main/chunking_data). 


The first this we need to do is clean the data to make sure that it is in the same format as the training data set. 
This was shown in the previous step, but can also be done in a loop using the Clean_ProcDat_V2.R file. 

Make sure you check the number of columns you want to keep 

```R
(e.g. dat <- dat[,1:28] )
```


The resulting files should end with "_cleaned.csv"

Move these to a separate file without any other Csv files in it. 



Steps to follow to create a predicted data set 

These should be available in the **beh_aggregator_example.R** file


The first part of the file calls in the masterSOM we have built earlier, and then looks for the cleaned and chunked accel files. 

```R
#### Packages ####
library(kohonen)
library(lubridate)
library(tidyverse)
# library(hms)
# library(forcats)
library(dplyr)

#####
##### Aggregate Behaviors #####

## Working Directory of SOM ##
setwd('J:/cat code/master SOM cats/MSOMS_70')

#load the SOM
load(file = "Cat_SOM_Biboff_9by8.rda") # Load in SOM 

#check the SOM
plot(MSOM)


## Working Directory of files that have been cleaned ##
setwd("E:/projects/CATS/12 cats cleaned/Coco/Split files/Coco_1_processed/bibon")

# ii=1 ## For checking first file

filenames <- Sys.glob("*.csv") ## Load in files of one Subject
beh_agg <- data.frame() ## data frame for loop
Ttime<- matrix() ## variable for timing prediction

#add any important variables here (e.g. conditions) 
bib_status = 'OFF'

```

Next we have to run a function to convert the files into the format for the predict function. However, its important to check that we are gathering the right number of predictor variables into the 'd' matrix. If the tidyverse code doesn't work, you can specify the column numbers directly. 

```R
trSamp2 <- function(x) { # Creates a training or test matrix, from data frame x, using a sample of size n (default is all rows)			
  #d <- x[,5:29] # select only the data rows
  d <- dat %>% select(meanX:skz)
  act <- as.factor(x$activity)
  # Corresponding activities
  out <- list(measurements = as.matrix(d), activity = act)
  return(out)
}
```

Next we start a loop for predicting the data and putting the output into a suitable format. 

first we get out data into the right format, and run the predict function. 

```R
dat2 <- trSamp2(dat) ## coerce data into appropriate format for predict

ssom.pred <- predict(MSOM, newdata = dat2$measurements, whatmap = 1) # predict behaviors

```

Next we want to put the output into a suitable format for later analysis. 
In this example, we extract the subject from the file name - this will have to be edited for your filename structure. 

```R
### Create our new dataframe ###
dat3 <- dat[ , c( "file", "time")]
dat3$subject <- str_split(dat3$file, "_", simplify = TRUE)[1]## insert subject
```

Next we pull out some time variables like hour and day

```R
dat3$time<-as.character(dat3$time)
dat3$hours<- hour(dat3$time)## insert hour
dat3$days<-day(dat3$time)## insert day
```

Finally we insert out predicted behaviours

```R
dat3$behaviors <- ssom.pred$predictions$activity ##insert behaviors
dat3$behaviors <- fct_explicit_na(dat3$behaviors, "Unknown") ## change NA to factor unknown
```

Add in any custom variables (e.g. bib status)

```R
dat3$bib <- bib_status
```


























