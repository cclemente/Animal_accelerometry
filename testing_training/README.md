
# testing the training data set

First you should check your code to make sure that all behaviours are appoximately evenly represented in your training data. Too much of any one behaviour will result in over representation in the SOM grid. 

```R
barplot(table(dat$Activity))
```

# code to remove a behaviour which is over represented. 

sitting is overly represented. 
we can try to reduce the number 

```R
Sit_ind <- which(dat$Activity=='Sitting') #randomly selecting 10000 rows
sit_ind_remove <- Sit_ind[sample(length(Sit_ind), 120000)]
dat2<-dat[-sit_ind_remove,]
```
