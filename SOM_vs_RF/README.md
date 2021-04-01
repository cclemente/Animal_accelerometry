

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
rf_classifier = randomForest(activity ~ ., data=training_cat, ntree=100, mtry=4, importance=TRUE)
varImpPlot(rf_classifier)

# Validation set assessment #1: looking at confusion matrix
prediction_for_table <- predict(rf_classifier,validation1[,-29])
ptab<-table(observed=validation1[,29],predicted=prediction_for_table)


```

This was the output from R 

 ptab
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
  
  
  Summarised...
  
  dat_out
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


  
  
  

