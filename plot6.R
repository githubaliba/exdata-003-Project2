#plot6.R
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

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

##Save Plot
if(!file.exists("./figs")){dir.create("./figs")}
dev.copy(png,"./figs/plot6.png")
dev.off()