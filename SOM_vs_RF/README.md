

Comparing a SOM to RF

```R

#import the package
install.packages('randomForest')
library(randomForest)
# Perform training:
rf_classifier = randomForest(Species ~ ., data=training, ntree=100, mtry=2, importance=TRUE)
rf_classifier = randomForest(activity ~ ., data=training_cat, ntree=100, mtry=4, importance=TRUE)
varImpPlot(rf_classifier)

```
