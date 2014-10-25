library(ggplot2)
library(sqldf)

# Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare data format
NEI$type <- factor(NEI$type)
SCC$EISector <- as.numeric(SCC$EI.Sector)

# Question #3:
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.
q3 <- sqldf('select year, type, sum(Emissions) as total 
             from NEI 
             where fips = "24510"
             group by year, type')

# Draw and save the graphics
png("plot3.png", width=480*2, height=480, units="px")
print(qplot(year, total, data = q3, facets = . ~ type, geom = "line", main = "Emission of PM2.5 in Baltimore, MD by emission type", xlab = "Year", ylab = "Emission of PM2.5"))
dev.off()