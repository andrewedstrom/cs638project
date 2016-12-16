#############################################
########### read in and explore #############
#############################################

d <- read.csv("labeled.csv")
varDescribe(d)
str(d)


# maxtrix?
chisq.test(as.matrix(d[,6,7]))
dMat <- as.matrix(d[,6:7])
chisq.test(d$ltable_genus,d$ltable_status) # this works

# table?
# see if we can use only rows with all data?
table(d[,c('ltable_family','ltable_genus')])
d$ltable_family
d$ltable_genus


chisq.test(table(d[,6,7]))
tableVersion <- table(d[,6:7])
str(tableVersion)
d[,7]
summary(tableVersion)
str(d)
# Univariate exploration
varPlot(d$rtable_country_count) 
chisq.test(d)

#############################################
########### correlate some shit #############
#############################################

#### feats to use?
# create numeric representation of factor variables
d$rtable_status_NUM <- as.numeric(d$rtable_status)
d$rtable_name_NUM <- as.numeric(d$rtable_name)
d$rtable_kingdom_NUM <- as.numeric(d$rtable_kingdom)
d$rtable_phylum_NUM <- as.numeric(d$rtable_phylum)
d$rtable_class_NUM <- as.numeric(d$rtable_class)
d$rtable_order_NUM <- as.numeric(d$rtable_order)
d$rtable_family_NUM <- as.numeric(d$rtable_family)
d$rtable_genus_NUM <- as.numeric(d$rtable_genus)
d$rtable_size_NUM <- as.numeric(d$rtable_size)
d$rtable_threat_keywords_NUM <- as.numeric(d$rtable_threat_keywords)
d$rtable_conservation_keywords_NUM <- as.numeric(d$rtable_conservation_keywords)
d$rtable_countries <- as.numeric(d$rtable_countries)
d$rtable_country_count
d$rtable_tCount

dNew <- cbind(d['rtable_status_NUM'],d['rtable_kingdom_NUM'])
str(dNew)
corr.test(d[,c('rtable_status_NUM','rtable_name_NUM','rtable_kingdom_NUM','rtable_phylum_NUM','rtable_class_NUM',
               'rtable_order_NUM','rtable_family_NUM','rtable_genus_NUM','rtable_size_NUM','rtable_threat_keywords_NUM','rtable_conservation_keywords_NUM',
               'rtable_countries','rtable_country_count','rtable_tCount')])

chisq.test(d) 
str(d)
# Order seems to predict conservation keywords (.55)
# Status predicted fairly well by conservation keywords
# Phylum predicts Kingdom at only 90%, showing us the matching rate of error
scatterplotMatrix(d[,c('income','education','women')])


# left
d$ltable_country_count
d$ltable_name_NUM <- as.numeric(d$ltable_name)
d$ltable_genus_NUM <- as.numeric(d$ltable_genus)
d$ltable_family_NUM <- as.numeric(d$ltable_family)
d$ltable_ecology_NUM <- as.numeric(d$ltable_ecology)
d$ltable_countries_NUM <- as.numeric(d$ltable_countries)
d$ltable_pop_trend_NUM <- as.numeric(d$ltable_pop_trend)
d$ltable_status_NUM <- as.numeric(d$ltable_status)

corr.test(d[,c('ltable_country_count','ltable_name_NUM','ltable_genus_NUM',
               'ltable_family_NUM','ltable_ecology_NUM','ltable_countries_NUM','ltable_pop_trend_NUM','ltable_status_NUM')])
scatterplotMatrix(d[,c('income','education','women')])



#################################################################
# Determine which order, class, phylum has most endangered status
#################################################################
varDescribeBy(d$rtable_status_NUM,d$rtable_phylum_NUM)
varDescribe(d$rtable_phylum_NUM)
varDescribe(d$rtable_status_NUM)
levels(d$rtable_phylum)
levels(d$rtable_status)


#################################################################
####### Run a model predicting status from most correlative vars
#################################################################

m <- 

#############################################
############## barplot code #################
#############################################
# FROM LAB 4
# Plotting using barplots ####

# Although we could technically use a scatterplot to graph the results,
# the general convention is to create a barplot instead of a scatterplot.

pY2 <- data.frame(Condition = c(0, 1))

# need to generate the mean of predicted values for each condition
# also need lower and upper standard error bounds for each condition
# SE bars represent standard error of point estimates
pY2 <- modelPredictions(m4, pY2)
pY2

# Note how the predicted values are just the means within each group
varDescribeBy(d$Wk4IAT, d$Condition) 

# make a Condition variable that has a descriptive name for labels
d$ConditionStr <- varRecode(d$Condition,c(0,1),c('Control','Training'))
pY2$ConditionStr <- varRecode(pY2$Condition,c(0,1),c('Control','Training'))

# Starting plot, in which we plot bars
plot <- ggplot(d, aes(x = ConditionStr, y = Predicted)) +
  geom_bar(mapping = aes(fill = as.factor(ConditionStr)), # add colors and labels based on condition
           data = pY2, 
           stat = "identity", # using stat = "identity" because bars represent particular values in dataset
           width = 0.5) 
plot 

# add the raw data points with jittering so we can see them
plot <- plot + geom_point(data = d, aes(y = Wk4IAT, x = ConditionStr),colour='darkgrey',
                          position = position_jitter(w = 0.1, h = 0.1))
plot

# add error bars
plot <- plot + geom_errorbar(data = pY2, width=.25, # add error bars of width 0.25
                             aes(y = Predicted, x = ConditionStr, # set error bar aesthethics: x & y variables
                                 ymin = CILo, # define bottom (then top) of error bars
                                 ymax = CIHi), stat="identity", width=0.75) # heights of bars rep values of data
plot

# finally, add labels, a title and remove the legend since it is unnecessary
plot <- plot +labs(y = 'Week 4 IAT Score', x = 'Condition') + # set axis labels
  ggtitle('Week 4 IAT by Condition') + # set graph title
  theme_bw(base_size = 14) +  theme(legend.position="none") # remove the unnecessary legend
plot

# Everything at once (combining previous code into single plot)
barplot <- ggplot(d, aes(x = ConditionStr, y = Predicted)) +
  geom_bar(mapping = aes(fill = as.factor(ConditionStr)), data = pY2, stat = "identity", width = 0.5) +
  geom_point(data = d, aes(y = Wk4IAT, x = ConditionStr),colour='darkgrey', 
             position = position_jitter(w = 0.1, h = 0.1)) +
  geom_errorbar(data = pY2, width=.25, aes(y = Predicted, x = ConditionStr, ymin = CILo, 
                                           ymax = CIHi), stat="identity", width=0.75) + 
  labs(y = 'Baseline IAT Score', x = 'Condition') + 
  ggtitle('Baseline IAT by Condition') + theme_bw(base_size = 14) + theme(legend.position="none") 
barplot



#############################################
############## histogram code ###############
#############################################
hist(d$Cats1, xlab = "Number of cats (in thousands)", main =
       "Histogram of stray cat numbers at year one")

hist(d$Cats5, xlab = "Number of cats (in thousands)", main =
       "Histogram of stray cat numbers at year five")



#############################################
############ scatterplot code ###############
#############################################
m3cent <- lm(Wk4IAT ~ ConcernMC + SexC, data=d)
modelSummary(m3cent, t=F)
modelSummary(m3, t=F)


#####################################
#### Plotting predictions        ####
#####################################

# Step 1: Create a data frame using expand.grid() that specifies the values to pass to each variable
# in the model to generate each prediction. In this case, we have two variables,
# ConcernM and Sex. The data frame you create needs to contain variables
# that correspond exactly to the variables in your model.


?expand.grid
pX <- expand.grid(ConcernM=seq(1,10,length=100), Sex=c(0, 1))
pY <- modelPredictions(m3, pX)
some(pY)

# Lay down the skeleton of the graph
plot <- ggplot(data=pY, aes(x = ConcernM, y = Predicted, color = as.factor(Sex))) 
# Add scatterplot
plot <- plot + geom_point(data=d, aes(y = Wk4IAT))
plot
# Make scatterplot pretty
plot <- plot+scale_colour_manual(values=c("#AF7AC5","#66BB6A"),name ="Gender", 
                                 labels=c("Female", "Male")) # get creative with your colors! http://htmlcolorcodes.com/color-chart/
# Add regression lines and error bands
plot <- plot + geom_smooth(aes(ymin = CILo, ymax = CIHi), stat = "identity") +
  # make some final aesthetic changes
  labs(x = 'Concern (Mean)', y = 'Week 4 IAT Score', title = 'Effect of Concern on IAT Scores') +
  theme_bw(base_size = 14) +                        # removing background of graph, set font sizes
  theme(legend.position = c(0.8, 0.9),              # positioning legend (play around with values) 
        legend.background = element_blank())        # removing background of legend
plot