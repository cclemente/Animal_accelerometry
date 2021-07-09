
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






