#############################################
########### read in and explore #############
#############################################

d <- read.csv("labeled.csv")
varDescribe(d)
str(d)

# convert popTrend to be a continuous var --> add order to levels so it makes sense
# first convert Unknown field to NA's for cleaner correlation values
levels(d$ltable_pop_trend)
d$new_pop_trend = d$ltable_pop_trend
d[d[,c('new_pop_trend')] == "Unknown",c('new_pop_trend')] = NA
d[d[,c('new_pop_trend')] == "",c('new_pop_trend')]= NA
d[d[,c('new_pop_trend')] == "" & !is.na(d[,c('new_pop_trend')]),c('new_pop_trend')] = NA
levels(d$new_pop_trend)

d$new_pop_trend = as.character(d$new_pop_trend)
str(d$new_pop_trend)
d[d[,c('new_pop_trend')] == "Unknown",c('new_pop_trend')]
d$new_pop_trend <- as.factor(d$new_pop_trend)
str(d$new_pop_trend)
#d$new_pop_trend <- ordered(d$new_pop_trend, levels = c("Unknown","Decreasing", "Increasing"))

# select ordinal vars for correlation matrix
ordinalVarKeysToLookAt <- c('length','ltable_status','new_pop_trend','ltable_country_count','rtable_tCount')
#install.packages("sjPlot")
library(sjPlot)

dSubset <- d[,ordinalVarKeysToLookAt]
# rename some columns for prettiness sake
colnames(dSubset) <- c("length","status","popTrend",'countryCount','threatCount')
dSubset[] <- lapply(dSubset,as.integer)
dSubset

# make things a bit prettier
sjp.setTheme(theme.font = NULL,
             title.color = "black", title.size = 1.2, title.align = "left",
             title.vjust = NULL, geom.outline.color = NULL, geom.outline.size = 0,
             geom.boxoutline.size = 0.5, geom.boxoutline.color = "black",
             geom.alpha = 1, geom.linetype = 1, geom.errorbar.size = 0.7,
             geom.errorbar.linetype = 1, geom.label.color = NULL,
             geom.label.size = 10, geom.label.alpha = 1, geom.label.angle = 0,
             axis.title.color = "grey30", axis.title.size = 1.1,
             axis.title.x.vjust = NULL, axis.title.y.vjust = NULL, axis.angle.x = 0,
             axis.angle.y = 0, axis.angle = NULL, axis.textcolor.x = "black",
             axis.textcolor.y = "black", axis.textcolor = NULL,
             axis.linecolor.x = NULL, axis.linecolor.y = NULL, axis.linecolor = NULL,
             axis.line.size = 0.5, axis.textsize.x = 1, axis.textsize.y = 1,
             axis.textsize = NULL, axis.tickslen = NULL, axis.tickscol = NULL,
             axis.ticksmar = NULL, axis.ticksize.x = NULL, axis.ticksize.y = NULL,
             panel.backcol = NULL, panel.bordercol = NULL, panel.col = NULL,
             panel.major.gridcol = NULL, panel.minor.gridcol = NULL,
             panel.gridcol = NULL, panel.gridcol.x = NULL, panel.gridcol.y = NULL,
             panel.major.linetype = 1, panel.minor.linetype = 1, plot.backcol = NULL,
             plot.bordercol = NULL, plot.col = NULL, plot.margins = NULL,
             legend.pos = "right", legend.just = NULL, legend.inside = FALSE,
             legend.size = 1, legend.color = "black", legend.title.size = 1,
             legend.title.color = "black", legend.title.face = "bold",
             legend.backgroundcol = "white", legend.bordercol = "white",
             legend.item.size = NULL, legend.item.backcol = "grey90",
             legend.item.bordercol = "white")

sjp.corr(dSubset)


### Next, I'll make a model of some of our most predictive IV's
m1 <- lm(status ~ popTrend, data = dSubset) # popTrend seems to have insufficient power (mostly decreasing, only a few increasing), F(1,89) = .429, p=.514
modelSummary(m1,t=F)

m2 <- lm(status ~ countryCount, data = dSubset) # approaching significance F(1,146) = 2.696, p = .103
modelSummary(m2,t=F)

m3 <- lm(status ~ threatCount, data = dSubset) 
modelSummary(m3,t=F)

modelSummary(m1,t=F)
dSubset$popTrend

# Now we'll look at categorical data - chisqare with...
rtable_conservation_keywords



#varsToLookAt <- c(d$ltable_status,d$ltable_pop_trend,d$ltable_country_count,d$ltable_ecology,d$rtable_tCount,d$rtable_kingdom,d$rtable_phylum,d$rtable_class,d$rtable_order,d$ltable_family)
chisq.test(varsToLookAt) # yep


# Individual chisq tests... these seem to work alright
chisq.test(d$ltable_status,d$rtable_phylum)


write.table(table(d$ltable_status,d$rtable_phylum),"eyooo.csv")

chisq.test(d$ltable_status,d$rtable_class) # nope!
chisq.test(d$ltable_status,d$rtable_order)
chisq.test(d$ltable_status,d$ltable_family)
chisq.test(d$ltable_status,d$genus)


levels(d$rtable_phylum)

chisq.test(d$ltable_status,d$ltable_family) # yep
chisq.test(d$ltable_pop_trend, d$ltable_status) # wow, doesn't predict... surprising
chisq.test(d$rtable_kingdom,d$rtable_phylum) # sanity check successful
chisq.test(d$ltable_country_count,d$rtable_kingdom) # cool, this is predictive
chisq.test(d$ltable_pop_trend,d$rtable_kingdom) # nope
chisq.test(d$ltable_pop_trend,d$rtable_phylum) # yep
chisq.test(d$length,d$rtable_phylum) # yep
chisq.test(d$length,d$ltable_status) # yep
chisq.test(d$weight,d$ltable_status) # yep
chisq.test(d$ltable_ecology,d$ltable_status) # nope
chisq.test(d$rtable_tCount,d$ltable_status) # nope, not even close
chisq.test(d$rtable_tCount,d$ltable_ecology) # yep
chisq.test(d$rtable_tCount,d$rtable_phylum) # yep
chisq.test(d$rtable_conservation_keywords,d$ltable_status) # yep
chisq.test(d$rtable_conservation_keywords,d$rtable_phylum) # yep
chisq.test(d$ltable_ecology,d$ltable_status) # nope

#try to make one whole correlation table
#varKeysToLookAt <- c('length','ltable_status','ltable_pop_trend','ltable_country_count','ltable_ecology','rtable_tCount','rtable_kingdom','rtable_phylum','rtable_class','rtable_order','ltable_family')







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