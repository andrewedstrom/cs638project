d <- read.csv('redlistTable_countryCountAdded.csv') # read data in

# histogram of country count
hist(d$country_count,breaks=30, main="Histogram of country count", xlab="country count")
max(d$country_count)


# make barplot of poptrend
levels(d$POP_TREND)[levels(d$POP_TREND)==""] <- "NaN"
plot(d$POP_TREND, main="Population Trend Bar Plot")

# make barplot of ecology
levels(d$ECOLOGY)[levels(d$ECOLOGY)==""] <- "NaN"
plot(d$ECOLOGY, main="Ecologies",cex.names=1.5)
levels(d$ECOLOGY)

# make barplot of family
levels(d$FAMILY)[levels(d$FAMILY)==""] <- "NaN"
plot(d$FAMILY, main="FAMILY")
levels(d$ECOLOGY)

# Count name length (which sometimes includes commonname (about 25% of the time))
nameHist <- hist(nchar(as.character(d$animalName)), main="Histogram of name length",xlab="character count")
mean(nchar(as.character(d$animalName)))
max(nchar(as.character(d$animalName)))
min(nchar(as.character(d$animalName)))

# Count name length (which sometimes includes commonname (about 25% of the time))
nameHist <- hist(nchar(as.character(d$CONSERVATION_PARAGRAPH)), main="Histogram of conservation paragraph length",xlab="character count")
mean(nchar(as.character(d$CONSERVATION_PARAGRAPH)))
max(nchar(as.character(d$CONSERVATION_PARAGRAPH)))
min(nchar(as.character(d$CONSERVATION_PARAGRAPH)))

# Count name length (which sometimes includes commonname (about 25% of the time))
nameHist <- hist(nchar(as.character(d$THREAT_PARAGRAPH)), main="Histogram of threat paragraph length",xlab="character count")
mean(nchar(as.character(d$THREAT_PARAGRAPH)))
max(nchar(as.character(d$THREAT_PARAGRAPH)))
min(nchar(as.character(d$THREAT_PARAGRAPH)))
