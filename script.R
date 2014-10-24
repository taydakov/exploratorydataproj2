# Load NEI data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare data format
NEI$type <- factor(NEI$type)

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