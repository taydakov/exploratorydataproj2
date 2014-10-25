library(ggplot2)
library(sqldf)

# Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare data format
NEI$type <- factor(NEI$type)
SCC$EISector <- as.numeric(SCC$EI.Sector)

# Question #4:
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
# I take SCCs where EI.Sector contains COAL. There are [13, 18, 23] factor levels of SCC$EI.Sector
# It includes:
# [13] "Fuel Comb - Comm/Institutional - Coal", 
# [18] "Fuel Comb - Electric Generation - Coal",
# [23] "Fuel Comb - Industrial Boilers, ICEs - Coal"
q4 <- sqldf('select NEI.year, sum(NEI.Emissions) as total 
             from NEI
             join SCC on SCC.SCC = NEI.SCC
             where SCC.EISector in (13, 18, 23)
             group by NEI.year')

# Draw and save the graphics
png("plot4.png", width=480, height=480, units="px")
print(qplot(year, total, data = q4, geom = "line", ylim = c(0, max(q4$total)), main = "Emission of coal combustion-related sources", xlab = "Year", ylab = "Emission of PM2.5"))
dev.off()