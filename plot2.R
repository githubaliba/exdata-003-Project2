#plot2.R
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
# from 1999 to 2008? Use the base plotting system to make a plot answering this question.

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
plot2 <- aggregate(Emissions ~ year, NEI[NEI$fips=="24510",], sum)
fig2 <- barplot(plot2$Emissions,names=plot2$year, ylab=expression("Total Emissions, Baltimore City, PM"[2.5]),xlab="Year",
        main=expression('All sources by year, Baltimore City, Total emissions, PM'[2.5]))

##Save Plot
if(!file.exists("./figs")){dir.create("./figs")}
png("./figs/plot2.png",height=600,width=800)
fig2 <- barplot(plot2$Emissions,names=plot2$year, ylab=expression("Total Emissions, Baltimore City, PM"[2.5]),xlab="Year",
                main=expression('All sources by year, Baltimore City, Total emissions, PM'[2.5]))
dev.off()