library(ggplot2)
library(sqldf)

# Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare data format
NEI$type <- factor(NEI$type)
SCC$EISector <- as.numeric(SCC$EI.Sector)

# Question #1:
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
q1 <- sqldf('select year, sum(Emissions) as total 
             from NEI 
             group by year')

# Draw and save the graphics
png("plot1.png", width=480, height=480, units="px")
plot(q1$year, q1$total, type="l", ylim = c(0, max(q1$total)), main = "Total emission of PM2.5 each year", xlab = "Year", ylab = "Total emission of PM2.5")
dev.off()