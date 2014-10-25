library(ggplot2)
library(sqldf)

# Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare data format
NEI$type <- factor(NEI$type)
SCC$EISector <- as.numeric(SCC$EI.Sector)

# Question #5:
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
# I take SCCs where motor vehicles are. There are [43, 44, 45, 49, 50, 51, 52] factor levels of SCC$EI.Sector
# It includes:
# [43] "Mobile - Aircraft"
# [44] "Mobile - Commercial Marine Vessels"
# [45] "Mobile - Locomotives"
# [49] "Mobile - On-Road Diesel Heavy Duty Vehicles"
# [50] "Mobile - On-Road Diesel Light Duty Vehicles"
# [51] "Mobile - On-Road Gasoline Heavy Duty Vehicles"
# [52] "Mobile - On-Road Gasoline Light Duty Vehicles"
q5 <- sqldf('select NEI.year, sum(NEI.Emissions) as total 
             from NEI
             join SCC on SCC.SCC = NEI.SCC
             where SCC.EISector in (43, 44, 45, 49, 50, 51, 52)
             and NEI.fips = "24510"
             group by NEI.year')

# Draw and save the graphics
png("plot5.png", width=480, height=480, units="px")
print(qplot(year, total, data = q5, geom = "line", ylim = c(0, max(q5$total)), main = "Emission from motor vehicle sources in Baltimore, MD", xlab = "Year", ylab = "Emission of PM2.5"))
dev.off()