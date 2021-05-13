
# Example using the possom_SOM.R file

This file runs through a few steps in preparing the data and running a competitive SOM. Not all steps are in the file. 
You should load in the labelled training data file. First we are going to clean up the data a little to make it more user friendly for the SOM

# Checking the data

First you should check your data to make sure that all behaviours are appoximately evenly represented in your training data. Too much of any one behaviour will result in over representation in the SOM grid. 

```R
barplot(table(dat$Activity))
```

# code to remove a behaviour which is over represented. 

sitting is overly represented. 
we can try to reduce the number 

```R
Sit_ind <- which(dat$Activity=='Sitting') #find which data is the activity
sit_ind_remove <- Sit_ind[sample(length(Sit_ind), 120000)]
dat2<-dat[-sit_ind_remove,]
```

# cleaning the NA's out of the data

NA values in the predictor sets will cause the SOM to perform badly, so we will need to remove these from the training and testing data. However, we cannot just use Naomit, since many of the NA's appear to come from the animal laying very still - therefore if we removed all of these then we may under represent some of the behaviours in our unlabelled data (e.g. sleeping). We solved this by changing some predictors to be set values when they are NA. The remaining NA's need to be removed. We also removed the predictors called Kutosis as this was problematic. 

```R
##cleaning logic
J_Dat$corXY[which(J_Dat$sdx=='0' | J_Dat$sdy=='0')]=1
J_Dat$corXZ[which(J_Dat$sdx=='0' | J_Dat$sdz=='0')]=1
J_Dat$corYZ[which(J_Dat$sdy=='0' | J_Dat$sdz=='0')]=1

#removes the kutosis predictor
J_Dat2<-J_Dat[,-c(30:32)]

#set the skewedness to be zero if no variation in data
J_Dat2$skx[is.na(J_Dat2$skx)]=0
J_Dat2$sky[is.na(J_Dat2$sky)]=0
J_Dat2$skz[is.na(J_Dat2$skz)]=0
```



# what shape to make the SOM? 
i got a reviewer ask me to run a sensitivty analysis on the shape of the SOM. So we should try this out. I have written some code to do this and have uploaded it. 
Have a look at the 'Cat_SOM_2021_SOMshape.R' file. 
I modified the doSOM function to allow different shape SOMs (though i kept them all symetrical) - luckily i found for my data set that ~ 7x7 works well. But we should be sure to test this for different data sets. 

Updated the SOMshape.R file above. It now includes the code to sample 80% of the training data for each behaviour. And includes the code to vary the shape of the SOM allowing assymetrical SOM grids. 

![alt text](https://github.com/cclemente/Animal_accelerometry/blob/main/testing_training/HeatMap_shape.jpeg)

# should we change the rlen function? 
the rlen value in the superSOM function changes the number of times the complete data set will be presented to the network. It defaults to 100, but presumably if the network gets to see the data more, then it should be able to make a good decision. However this appears not to be the case. 

![alt text](https://github.com/cclemente/Animal_accelerometry/blob/main/testing_training/Rlen_boxplot.jpeg)

nor does it appear to change with the behaviour. 

![alt text](https://github.com/cclemente/Animal_accelerometry/blob/main/testing_training/plot_rlen.jpeg)

So, i guess thats good news, other than being i giant waste of processing time on my poor laptop. rlen can be safely ignored, and left as the default. 


# explore the data
For a first look at the training data you can download the 'cat_SOM.nb.html' file and open in a browser
This should give you a good indication for different visualisations
