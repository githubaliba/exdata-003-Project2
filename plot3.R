#plot3.R
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a 
# plot answer this question.

##Part 0: Download and Unzip Data
if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName1 = "NEIData.zip"
filePath1 = paste("./data/",fileName1,sep="")
if(!file.exists(filePath1)) 
{
  download.file(fileUrl1,destfile=filePath1)
  unzip("./data/NEIData.zip",exdir="./data")
}

## This first line will likely take a few seconds. Be patient!
if(!exists('NEI')) {
  NEI <- readRDS("data//summarySCC_PM25.rds")
  NEI <- NEI[,c(1,2,4,5,6)]
  NEI$year <- as.factor(NEI$year)
  NEI$type <- as.factor(NEI$type)
}
if(!exists('SCC')) {SCC <- readRDS("data//Source_Classification_Code.rds")}

##Generate Plot
plot3 <- aggregate(Emissions ~ year + type, NEI[NEI$fips=="24510",], sum)
gg3 <- qplot(year,Emissions,data=plot3,facets=.~type)
gg3 <- gg3 + ylab(expression("Total Emissions, Baltimore City, PM"[2.5]))
gg3 <- gg3 + xlab("Year of Observation")
gg3 <- gg3 + ggtitle(expression("Total Emissions, Baltimore City, By Emission Type, PM"[2.5]))
gg3 <- gg3 + geom_point(size=8,aes(color=type))
gg3

##Save Plot
if(!file.exists("./figs")){dir.create("./figs")}
png("./figs/plot3.png",height=600,width=800)
gg3
dev.off()