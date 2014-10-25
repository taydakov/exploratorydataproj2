library(ggplot2)
library(sqldf)

# Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare data format
NEI$type <- factor(NEI$type)
SCC$EISector <- as.numeric(SCC$EI.Sector)

# Question #6:
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?
# I take SCCs where motor vehicles are. There are [43, 44, 45, 49, 50, 51, 52] factor levels of SCC$EI.Sector
# It includes:
# [43] "Mobile - Aircraft"
# [44] "Mobile - Commercial Marine Vessels"
# [45] "Mobile - Locomotives"
# [49] "Mobile - On-Road Diesel Heavy Duty Vehicles"
# [50] "Mobile - On-Road Diesel Light Duty Vehicles"
# [51] "Mobile - On-Road Gasoline Heavy Duty Vehicles"
# [52] "Mobile - On-Road Gasoline Light Duty Vehicles"
q6 <- sqldf('select NEI.year, NEI.fips, sum(NEI.Emissions) as total 
             from NEI
             join SCC on SCC.SCC = NEI.SCC
             where SCC.EISector in (43, 44, 45, 49, 50, 51, 52)
             and NEI.fips in ("24510", "06037")
             group by NEI.year, NEI.fips')
q6select <- q6
# Normalize data differently for different areas
q6 <- sqldf(c("update q6 set total = 100 * total / (select total from q6select where q6select.fips = q6.fips limit 1)", "select * from main.q6"))
# Let's make more understandable names for the areas
q6$Area <- factor(q6$fips, levels=c("06037", "24510"), labels=c("Los Angeles County", "Baltimore, MD"))

# Draw and save the graphics
png("plot6.png", width=480*2, height=480, units="px")
print(qplot(year, total, data = q6, geom = "line", color = Area, ylim = c(0, max(q6$total)), main = "Changes in emission from motor vehicle sources in Baltimore, MD vs Los Angeles County", xlab = "Year", ylab = "Change of emission of PM2.5, %"))
dev.off()