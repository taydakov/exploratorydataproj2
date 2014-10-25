library(ggplot2)
library(sqldf)

# Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare data format
NEI$type <- factor(NEI$type)
SCC$EISector <- as.numeric(SCC$EI.Sector)

# Question #2:
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
# Use the base plotting system to make a plot answering this question.
q2 <- sqldf('select year, sum(Emissions) as total 
             from NEI 
             where fips = "24510"
             group by year')

# Draw and save the graphics
png("plot2.png", width=480, height=480, units="px")
plot(q2$year, q2$total, type="l", ylim = c(0, max(q2$total)), main = "Emission of PM2.5 in Baltimore, MD each year", xlab = "Year", ylab = "Emission of PM2.5")
dev.off()