

Comparing a SOM to RF

```R

#read in your training data set, then separate into testing and training. 

#select 80% of the testing data
ind <- biboff %>% group_by(biboff$act) %>% sample_frac(.8)
training_cat<-ind[,c(4:31, 35)]
training_cat$activity<-as.factor(training_cat$activity)

#remaining 20%
tstind<-subset(biboff, !(biboff$X %in% ind$X))
validation1<-tstind[,c(4:31, 35)]


#import the package
install.packages('randomForest')
library(randomForest)

# Perform training:
ptm <- proc.time()
rf_classifier = randomForest(activity ~ ., data=training_cat, ntree=100, mtry=4, importance=TRUE)
proc.time() - ptm

user  system elapsed 
 169.70    0.53  171.54 

#we get results out directly from the RF

rf_classifier$confusion[,1:12]
          bite/hold eating galloping grooming jumping lying pouncing sitting swatting trotting walking
bite/hold      8577      0         0        0       0     5        0       1       13        0      12
eating            0  21527         0        0       1     0        0       1        1        1       5
galloping         0      0       437        0       2     0        0       1        3        0      10
grooming          0      0         0    16181       0     2        0       6        0        0      10
jumping           0      4         1        0    2812     0        1       5        9        0      27
lying             3      2         0        5       0 22962        1       5        8        0       8
pouncing          0      0         3        0       1     0     1930       0        7        1      13
sitting           1      2         0        6       5     2        1   23050        8        0      17
swatting          4      1         1        0       0     2        1       5    15590        0      23
trotting          0      1         0        0       0     0        0       0        1      913       3
walking           1      6         1        2       8     1        2      12       13        1   26306
watching          2      3         2        1      13     1        4      13       45        1      48
          watching
bite/hold        5
eating           6
galloping        4
grooming         3
jumping         11
lying            4
pouncing         7
sitting         14
swatting        39
trotting         4
walking         21
watching     29387

 
 bite/hold    eating galloping  grooming   jumping     lying  pouncing   sitting  swatting
SENS 0.9987191 0.9991182 0.9820225 0.9991355 0.9894441 0.9994342 0.9948454 0.9978787 0.9931201
PREC 0.9958203 0.9993037 0.9562363 0.9987039 0.9797909 0.9984346 0.9836901 0.9975764 0.9951487
SPEC 0.9997773 0.9998991 0.9998822 0.9998637 0.9996535 0.9997555 0.9998099 0.9996194 0.9995082
ACCU 0.9997239 0.9998003 0.9998355 0.9997944 0.9994831 0.9997122 0.9997533 0.9993832 0.9989191
      trotting   walking  watching
SENS 0.9956379 0.9933540 0.9960007
PREC 0.9902386 0.9974217 0.9954946
SPEC 0.9999468 0.9995270 0.9990549
ACCU 0.9999236 0.9985667 0.9985255

#we can also try to predict our testing data set (called validation1 here) 

varImpPlot(rf_classifier)

# Validation set assessment #1: looking at confusion matrix
prediction_for_table <- predict(rf_classifier,validation1[,-29])
ptab<-table(observed=validation1[,29],predicted=prediction_for_table)



#This was the output from R 

 #ptab
     predicted
observed    bite/hold eating galloping grooming jumping lying pouncing sitting swatting trotting
  bite/hold      2148      0         0        0       0     0        0       0        2        0
  eating            0   5385         0        0       0     0        0       0        0        0
  galloping         0      0       108        0       0     0        1       0        0        0
  grooming          2      0         0     4040       0     0        0       0        0        0
  jumping           0      2         0        0     708     0        0       1        1        0
  lying             1      0         0        0       0  5739        0       1        5        0
  pouncing          2      0         1        0       1     0      478       0        3        0
  sitting           0      0         0        2       0     0        0    5758        3        0
  swatting          2      0         0        0       0     2        1       1     3900        0
  trotting          0      0         0        0       0     0        0       0        0      227
  walking           0      1         0        0       4     0        0       0        2        0
  watching          0      0         1        0       1     1        0       4        5        0
           predicted
observed    walking watching
  bite/hold       2        1
  eating          0        1
  galloping       3        2
  grooming        8        0
  jumping         3        3
  lying           3        1
  pouncing        2        3
  sitting        10        3
  swatting        7        3
  trotting        3        1
  walking      6581        5
  watching       12     7356
  
  
  #Summarised...
  
 dat_out
     bite/hold    eating galloping  grooming   jumping     lying  pouncing   sitting  swatting
SENS 0.9967517 0.9994432 0.9818182 0.9995052 0.9915966 0.9994775 0.9958333 0.9987858 0.9946442
PREC 0.9976777 0.9998143 0.9473684 0.9975309 0.9860724 0.9980870 0.9755102 0.9968837 0.9959142
SPEC 0.9998762 0.9999731 0.9998586 0.9997404 0.9997610 0.9997012 0.9997148 0.9995108 0.9995859
ACCU 0.9997180 0.9999060 0.9998120 0.9997180 0.9996240 0.9996710 0.9996710 0.9994126 0.9991306
      trotting   walking  watching
SENS 1.0000000 0.9920109 0.9968830
PREC 0.9826840 0.9981799 0.9967480
SPEC 0.9999055 0.9996660 0.9993178
ACCU 0.9999060 0.9984726 0.9988956

 rowMeans(dat_out)
     SENS      PREC      SPEC      ACCU 
0.9955625 0.9893725 0.9997176 0.9994948 


```

# Lets compare this to the SOM 


 ```R
 
 
# A custom function to make life easier
trSamp2 <- function(x) { # Creates a training or test matrix, from data frame x, using a sample of size n (default is all rows)			
  d <- x[,4:31] # Random sample of 10 000 rows of the data
  act <- as.factor(x$activity) # Corresponding activities
  out <- list(measurements = as.matrix(d), activity = act)
  return(out)
}

#gets data in SOM format
trDat<-trSamp2(ind)
tstDat<-trSamp2(ind)

## compare to SOM

system.time(
  ssom <- supersom(trDat, grid = somgrid(7, 7, "hexagonal"))
)

# user  system elapsed 
# 64.66    0.35   65.14 

ssom.pred <- predict(ssom, newdata = tstDat)
ptab_SOM <- table(predictions = ssom.pred$predictions$activity, activity = tstDat$activity)

> ptab_SOM
           activity
predictions bite/hold eating galloping grooming jumping lying pouncing sitting swatting trotting
  bite/hold      2055      0         0        0       0     0        0       0        0        0
  eating            0   5384         0        0       0     0        0       0        0        0
  galloping         5      0       105        9       4     2       25       1        5        0
  grooming          0      0         0     4036       0     0        0       0        0        0
  jumping           9      0         2        0     712     2        0       0        0        0
  lying            59      0         0        2       0  5738        7     212       10        0
  pouncing         15      0         4        0       2     6      458       1        0        0
  sitting           0      0         0        0       0     0        0    5560        0        0
  swatting          7      0         3        2       0     2        0       0     3901        0
  trotting          0      0         0        0       0     0        0       0        0      231
  walking           0      0         0        0       0     0        0       0        0        0
  watching          3      2         0        1       0     0        0       2        0        0
           activity
predictions walking watching
  bite/hold       0        0
  eating          0        0
  galloping       8        0
  grooming        0        0
  jumping        11       16
  lying           4       69
  pouncing        3        1
  sitting         0        0
  swatting        9        2
  trotting        0        0
  walking      6558        0
  watching        0     7292
  
  
  > dat_out_SOM
     bite/hold    eating galloping  grooming   jumping     lying  pouncing   sitting  swatting trotting
SENS 0.9544821 0.9996287 0.9210526 0.9965432 0.9916435 0.9979130 0.9346939 0.9626039 0.9961696        1
PREC 1.0000000 1.0000000 0.6402439 1.0000000 0.9468085 0.9405016 0.9346939 1.0000000 0.9936322        1
SPEC 1.0000000 1.0000000 0.9986099 1.0000000 0.9990440 0.9901377 0.9992393 1.0000000 0.9993530        1
ACCU 0.9976972 0.9999530 0.9984021 0.9996710 0.9989191 0.9911883 0.9984961 0.9949245 0.9990601        1
       walking  watching
SENS 0.9946913 0.9880759
PREC 1.0000000 0.9989041
SPEC 1.0000000 0.9997726
ACCU 0.9991776 0.9977442

     SENS      PREC      SPEC      ACCU 
0.9781248 0.9545653 0.9988464 0.9979361 


```



  




  
  

