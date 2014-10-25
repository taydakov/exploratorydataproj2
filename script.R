library(ggplot2)
library(sqldf)

# Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare data format
NEI$type <- factor(NEI$type)
SCC$EISector <- as.numeric(SCC$EI.Sector)

# Question #1
q1 <- sqldf('select year, sum(Emissions) as total 
             from NEI 
             group by year')
plot(q1$year, q1$total, type="l", ylim = c(0, max(q1$total)), main = "Total emission of PM2.5 each year", xlab = "Year", ylab = "Total emission of PM2.5")

# Question #2
q2 <- sqldf('select year, sum(Emissions) as total 
             from NEI 
             where fips = "24510"
             group by year')
plot(q2$year, q2$total, type="l", ylim = c(0, max(q2$total)), main = "Emission of PM2.5 in Baltimore, MD each year", xlab = "Year", ylab = "Emission of PM2.5")

# Question #3
q3 <- sqldf('select year, type, sum(Emissions) as total 
             from NEI 
             where fips = "24510"
             group by year, type')
qplot(year, total, data = q3, facets = . ~ type, geom = "line", main = "Emission of PM2.5 in Baltimore, MD by emission type", xlab = "Year", ylab = "Emission of PM2.5")

# Question #4
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
qplot(year, total, data = q4, geom = "line", ylim = c(0, max(q4$total)), main = "Emission of coal combustion-related sources", xlab = "Year", ylab = "Emission of PM2.5")

# Question #5
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
qplot(year, total, data = q5, geom = "line", ylim = c(0, max(q5$total)), main = "Emission from motor vehicle sources in Baltimore, MD", xlab = "Year", ylab = "Emission of PM2.5")

# Question #6
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
qplot(year, total, data = q6, geom = "line", color = Area, ylim = c(0, max(q6$total)), main = "Changes in emission from motor vehicle sources in Baltimore, MD vs Los Angeles County", xlab = "Year", ylab = "Change of emission of PM2.5, %")