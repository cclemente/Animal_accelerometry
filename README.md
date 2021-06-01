# Animal_accelerometry
Understanding animal movement using accelerometers

This readme should act as a guide for the animal accelerometer pipeline. 

Developed by Christofer Clemente and David Schoeman, University of the Sunshine Coast

# Step 1: Data collection.
Accelerometers should be attached to animals in a firm and secure fashion. The type of accelerometer is not very important. We have been using the AX3 accelerometer from axivity
https://axivity.com/product/ax3

You should have collected a series of videos which capture the behaviour of each of the key aspects you wish to record. The length of the videos should be kept relatively short ~1m long. Shorter videos will make allignment more difficult, longer videos will slow down processing. 

# [Step 2: Data allignment](https://github.com/cclemente/Animal_accelerometry/tree/main/Matlab_scripts)
Date should then be labelled onto the accelerometer trace. To do this we have custom build a Matlab script which will allow you to input the timestamp from a video and isolate the accelerometer trace which represents the movement. Go to the matlab_scripts folder to complete this step. 

# [Step 3: Build training data set](https://github.com/cclemente/Animal_accelerometry/tree/main/Build_training_dataset)
Now you should have a series of small files with behaviour and accelerometer traced linked together. We need to combine them into a larger file for the next step in our analysis.

# [Step 4: Testing training data set](https://github.com/cclemente/Animal_accelerometry/tree/main/testing_training)
Go to the testing_training subfolder. This will go through various aspects of testing the training data. And eventually will include a competitive SOM process. 

# Step 5: chunking data and creating predictor variables 
This step is similar to what we have done above with the training data set, but here we dont have any associated activities. The files sizes are often very large meaning we need to split them up into small sections.

# [Step 6: Use the SOM to label the unknown data](https://github.com/cclemente/Animal_accelerometry/tree/main/label_data)
This step will use the SOM created from the training data to label the chunked files we have built in step 5





