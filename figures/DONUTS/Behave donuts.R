#### FIGURE 3 #####
### Behavior Donut ###
######
#     Files for input into the for loop are in the format X(int), behaviors(char), 
#     subject(char), days(int), hours(int), count(int), sex(char). This data was 
#     collated by aggregating the sum or count of the predicted data over behavior, 
#     days and hours for each subject.
######
library(ggplot2)

### Female ####
setwd("H:/Chapter 3/Beh_Agg/Female") #Set working directory
filenames<- Sys.glob("*.csv") #load in filenames for processing
femdf <- data.frame() #create a temporary dataframe

## Loop that reads in files and binds them into a megafile ##
for (ii in 1:length(filenames)) {
  dat <- read.csv(filenames[ii])
  femdf <- rbind(femdf,dat)
}

## aggregate the count into a mean ##
totmean <- aggregate(femdf$x, by=list(behaviors = femdf$behaviors), FUN = mean)
levels(as.factor(totmean$behaviors)) # check levels to make sure all are represented

## order the behaviors to present nicely in the donut ##
totmean$behaviors <- factor(totmean$behaviors,
                            levels = c("Lying.Resting","Sitting","Vigilance","Standing Vig",
                                       "Vig Walking","Walking","Turning","Gallop","Bounds","Jumping"))

pie(totmean$x, totmean$behaviors) # preliminary pie chart

## GGplot code to produce the behavior donut ##
fempie <- ggplot(totmean, aes(x=2, y=x, fill = behaviors))+
  geom_bar(width = 1.9, stat = "identity", color = "#222222", size = 1.05) +# color and size of outlines
  coord_polar(theta = "y", start = 0, direction = 1)+ # direction of order
  theme_void()+
  theme(legend.title = element_blank(), legend.text = element_text(size = 12, color = "black"))+ # legend
  scale_fill_manual(values = c("#A08BDD","#829DED","#76cff2","#7addc1","#96ca71",
                               "#d4c974","#eeae79","#fa9088","#f887b2","#e48cce"))+ # colors of figure
  annotate("text", x=0,y=0,label=" ",colour="#000000", size=16)

plot(fempie) # Plot the figure created above
