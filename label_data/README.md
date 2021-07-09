
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

These should be available in the #beh_aggregator_example.R file

