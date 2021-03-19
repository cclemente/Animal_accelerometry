
# label Unknown data

Steps to follow to create a SOM

(1) create the SOM from the training data set. To do this we need to sample evenly from our data to make the training data set. 
Extract 50% (80% ? ) of the behaviours labelled with each activity. The remainder goes into the testing data set. 

(2) Make a SOM, but set the 'rlen' argument in the SOM function to a high number, say 10,000. 
This will control the number of times the SOM is sent back to the training camp. 

(3) Test the output of the SOM. Apply some sort of optimization function. For example how well do some very important behaviours get predicted? 

(4) Run the SOM workflow above in a competitive environment. Each time output the result of the SOM to an RDA file (function = saveRDS.R) - which should allow us to call it back in. 
Output the result of the optimization to a file, only keep the SOM if it was better than the last one. Let this run until the SOMs stop getting better. 
