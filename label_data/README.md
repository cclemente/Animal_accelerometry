
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



Steps to follow to create a SOM

(1) create the SOM from the training data set. To do this we need to sample evenly from our data to make the training data set. 
Extract 50% (80% ? ) of the behaviours labelled with each activity. The remainder goes into the testing data set. 

(2) Make a SOM, but set the 'rlen' argument in the SOM function to a high number, say 10,000. 
This will control the number of times the SOM is sent back to the training camp. 

(3) Test the output of the SOM. Apply some sort of optimization function. For example how well do some very important behaviours get predicted? 

(4) Run the SOM workflow above in a competitive environment. Each time output the result of the SOM to an RDA file (function = saveRDS.R) - which should allow us to call it back in. 
Output the result of the optimization to a file, only keep the SOM if it was better than the last one. Let this run until the SOMs stop getting better. 
