
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
Have a look at the 'Cat_SOM_2021_SOMshape.R' file or the possum_SOM.R file. 

I modified the doSOM function (doSOMperf) to allow different shape SOMs (though i kept them all symetrical) - luckily i found for my data set that ~ 7x7 works well. But we should be sure to test this for different data sets. The doSOMperf function can be found at the bottom of the possum_SOM.R file 

It now includes the code to sample 80% of the training data for each behaviour. And includes the code to vary the shape of the SOM allowing assymetrical SOM grids. 

```R
somsize<-rep(seq(4,9,1),6) #acc
somsize2<-rep(4:9, times=1, each=6)
somsize3<-cbind(somsize,somsize2)

acc3list <- matrix()
system.time(
  acc3list<-foreach(i = 1:36, .packages=c('kohonen'), .combine=rbind) %dopar% {
    #acc[i,] <- doSOM(biboff, samples[i])
    doSOMperf(trDat,tstDat, somsize3[i,1], somsize3[i,2])
    #print(i)
  }
)
```

The above code should build a matrix of possible SOM shapes and test each one. You can compare the results by making a heatmap of the output for each of the four tests. Below is the result of one. 

![alt text](https://github.com/cclemente/Animal_accelerometry/blob/main/testing_training/HeatMap_shape.jpeg)

# should we change the rlen function? 
the rlen value in the superSOM function changes the number of times the complete data set will be presented to the network. It defaults to 100, but presumably if the network gets to see the data more, then it should be able to make a good decision. However this appears not to be the case. 

![alt text](https://github.com/cclemente/Animal_accelerometry/blob/main/testing_training/Rlen_boxplot.jpeg)

nor does it appear to change with the behaviour. 

![alt text](https://github.com/cclemente/Animal_accelerometry/blob/main/testing_training/plot_rlen.jpeg)

So, i guess thats good news, other than being i giant waste of processing time on my poor laptop. rlen can be safely ignored, and left as the default. 


# Competitive SOMs
Once you have decided on a shape for your some you are ready to make a master SOM which will be used to predict our unlabelled behaviour. Because the SOMs vary each time we make them we wanted to find the most powerful som and keep this. The competitive some code below will create a master SOM, then run through a loop, building a new SOM and compare it to the original one. If the new SOM is better (more accurate) it will keep the new som and discard the old one. You can do this as many times as you like. ~20 times (~30minutes) seems to produce a reliable SOM.


```R
## Create Original Master SOM
acc5  <- doSOM(trDat,tstDat, 7, 7) ## outputs list(SOM, somperf)



MSPerf  <- acc5$somperf ## Retrieve performance from list
MSOM <- acc5$SOM ## Retrieve NEW SOM from list
Iter = 0 ## Check which Iteration of the loop produced the Optimised SOM
Chng = 0 ## Check how often the SOM has changed

#Loop to compare NEW SOMs to MASTER SOM
system.time(
  for (uu in 1:20){ #Run this for as many as is needed, 10 seems to produce high predictability?
    #uu=1
    
    # Creating our NEW SOM to compete against ORIGINAL MASTER SOM
    NS <-doSOM(trDat,tstDat, 7, 7) ## outputs list(SOM, somperf)
    
    NSPerf <- NS$somperf ## Retrieve performance from list
    NSOM <- NS$SOM ## Retrieve NEW SOM from list
    
    ## Comparison Variables
    comp95 <- sum(NSPerf[,2:12]<0.95) - sum(MSPerf[,2:12]<0.95) ## Compare how many variables are predicting below 95%
    comp90 <- sum(NSPerf[,2:12]<0.90) - sum(MSPerf[,2:12]<0.90) ## Compare how many variables are predicting below 90%
    comp80 <- sum(NSPerf[,2:12]<0.80) - sum(MSPerf[,2:12]<0.80) ## Compare how many variables are predicting below 80%
    
    
    ## Compare how many variables have improved in prediction
    compsom <- as.data.frame(NSPerf[,2:12])- as.data.frame(MSPerf[,2:12]) #Subrtacts MASTER SOM from NEW SOM
    CS <- (sum(compsom>0) - sum(compsom<0)) 
    #if cs is positive, New is better. If negative old is better
    
    ## Nested if statements to compare these variables and find the better SOM
    
    if (comp80 < 0){
      MSPerf <- NSPerf ## REPLACE SOM Performance statistics
      MSOM <- NSOM ## REPLACE Master SOM
      Iter = uu ## RECORD Iterations taken to get best SOM
      Chng = Chng+1 ## RECORD number of times SOM is replaced
      next ## NEW LOOP
    } else if (comp80 > 0){
      next ## NEW LOOP
    } else if (comp80 == 0){
      if (comp90 < 0){
        MSPerf <- NSPerf ## REPLACE SOM Performance statistics
        MSOM <- NSOM ## REPLACE Master SOM
        Iter = uu #RECORD Iterations taken to get best SOM
        Chng = Chng+1 ## RECORD number of times SOM is replaced
        next #NEW LOOP
      } else if (comp90 > 0){
        next #NEW LOOP
      } else if (comp90 == 0){
        if (comp95 < 0){
          MSPerf <- NSPerf ## REPLACE SOM Performance statistics
          MSOM <- NSOM ## REPLACE Master SOM
          Iter = uu #RECORD Iterations taken to get best SOM
          Chng = Chng+1 ## RECORD number of times SOM is replaced
          next #NEW LOOP
        } else if (comp95 > 0){
          next #NEW LOOP
        } else if (comp95 == 0){
          if (CS > 0){
            MSPerf <- NSPerf ## REPLACE SOM Performance statistics
            MSOM <- NSOM ## REPLACE Master SOM
            Iter = uu #RECORD Iterations taken to get best SOM
            Chng = Chng+1 ## RECORD number of times SOM is replaced
            next #NEW LOOP
          } else {next}
        }
      }
    } 
    
    
    
  }
)
#### Compare ORIGINAL SOM to NEW MASTER SOM
print(Iter)
print(Chng)
acc5$somperf[,2:12]
MSPerf[,2:12]
#####

```



# explore the data
For a first look at the training data you can download the 'cat_SOM.nb.html' file and open in a browser
This should give you a good indication for different visualisations
