d <- read.csv('redlistTable.csv')
str(d)
barplot(table(d$KINGDOM))
