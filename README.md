# Animal_accelerometry
Understanding animal movement using accelerometers

This readme should act as a guide for the animal accelerometer pipeline. 

Developed by Christofer Clemente and David Schoeman, University of the Sunshine Coast

# Step 1: Data collection.
Accelerometers should be attached to animals in a firm and secure fashion. The type of accelerometer is not very important. We have been using the AX3 accelerometer from axivity
https://axivity.com/product/ax3

You should have collected a series of videos which capture the behaviour of each of the key aspects you wish to record. The length of the videos should be kept relatively short ~1m long. Shorter videos will make allignment more difficult, longer videos will slow down processing. 

# Step 2: Data allignment
Date should then be labelled onto the accelerometer trace. To do this we have custom build a Matlab script which will allow you to input the timestamp from a video and isolate the accelerometer trace which represents the movement. Go to the matlab_scripts folder to complete this step. 

# Step 3: Build training data set
Now you should have a series of small files with behaviour and accelerometer traced linked together. We need to combine them into a larger file for the next step in our analysis. 





