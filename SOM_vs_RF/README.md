

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

varImpPlot(rf_classifier)

# Validation set assessment #1: looking at confusion matrix
prediction_for_table <- predict(rf_classifier,validation1[,-29])
ptab<-table(observed=validation1[,29],predicted=prediction_for_table)



#This was the output from R 

 #ptab
           predicted
observed    bite/hold eating galloping grooming jumping lying pouncing sitting swatting trotting
  bite/hold       231      0         0        0       0     0        0       0        0        0
  eating            0    713         0        0       0     0        0       0        0        0
  galloping         0      0         2        0       0     0        0       0        0        0
  grooming          0      0         0     1072       0     0        0       0        0        0
  jumping           0      0         0        0      76     0        0       0        1        0
  lying             0      0         0        0       0  1062        0       1        0        0
  pouncing          0      0         0        0       0     0      133       0        0        0
  sitting           0      0         0        0       0     0        0     327        0        0
  swatting          0      0         0        0       0     0        0       0     1038        0
  trotting          0      0         0        0       0     0        0       0        0       87
  walking           0      0         0        0       0     0        0       0        0        0
  watching          0      0         0        0       0     0        0       0        2        1
           predicted
observed    walking watching
  bite/hold       0        0
  eating          0        0
  galloping       0        0
  grooming        1        0
  jumping         0        2
  lying           0        1
  pouncing        1        0
  sitting         1        0
  swatting        1        3
  trotting        0        0
  walking      1106        3
  watching        0     2292
  
  
  #Summarised...
  
  #dat_out
     bite/hold eating galloping  grooming   jumping     lying  pouncing   sitting  swatting  trotting
SENS         1      1         1 1.0000000 1.0000000 1.0000000 1.0000000 0.9969512 0.9971182 0.9886364
PREC         1      1         1 0.9990680 0.9620253 0.9981203 0.9925373 0.9969512 0.9961612 1.0000000
SPEC         1      1         1 0.9998589 0.9996288 0.9997181 0.9998754 0.9998723 0.9994379 1.0000000
ACCU         1      1         1 0.9998774 0.9996322 0.9997548 0.9998774 0.9997548 0.9991418 0.9998774
       walking  watching
SENS 0.9963964 0.9960887
PREC 0.9972949 0.9986928
SPEC 0.9995743 0.9994877
ACCU 0.9991418 0.9985289


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
  bite/hold      7869      0        19        0       1     0        6       0        0        0
  eating           12  21518        35        0       8     0        0       0        0        0
  galloping        36      0       167       35      32     8      147       2       96        0
  grooming          0      0         2    16071       0     0        0       0        0        0
  jumping           0      0        21        0    2395     0        0       0        0        0
  lying           451     14         2       26       7 22937       28     835       72        0
  pouncing          0      0         2        0       0     0     1297       0        0        0
  sitting          29      4        49       39       3     2        0   22258        9        0
  swatting        191      0        52       11     424    51      484      11    15489       16
  trotting          0      0         0        0       0     0        0       0        0      906
  walking           0      0        58        0       0     0        0       0        0        0
  watching         25      6        50       20       0     0        0       0        0        0
           activity
predictions walking watching
  bite/hold       0        0
  eating          0        0
  galloping      35        0
  grooming        0        0
  jumping         0        0
  lying          28      518
  pouncing        0        0
  sitting         4        0
  swatting      119      106
  trotting        0        0
  walking     26185        0
  watching        3    28896
  
  
  > dat_out_SOM
     bite/hold    eating galloping  grooming   jumping     lying  pouncing   sitting  swatting
SENS 0.9136189 0.9988859 0.3654267 0.9919146 0.8344948 0.9973476 0.6610601 0.9632996 0.9887016
PREC 0.9967068 0.9974505 0.2992832 0.9998756 0.9913079 0.9204992 0.9984604 0.9937938 0.9135897
SPEC 0.9998391 0.9996301 0.9976970 0.9999870 0.9998745 0.9865452 0.9999881 0.9990552 0.9905218
ACCU 0.9954768 0.9995359 0.9959996 0.9992187 0.9970863 0.9880046 0.9960818 0.9942020 0.9903543
      trotting   walking  watching
SENS 0.9826464 0.9928339 0.9788618
PREC 1.0000000 0.9977899 0.9964138
SPEC 1.0000000 0.9995968 0.9992609
ACCU 0.9999060 0.9985490 0.9957235


```



  




  
  

