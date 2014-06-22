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

plot1 <- aggregate(Emissions ~ year, NEI, sum)
barplot(plot1$Emissions,names=plot1$year, ylab=expression("Total Emissions, PM"[2.5]),xlab="Year",
        main=expression('All sources by year, Total emissions, PM'[2.5]))

plot2 <- aggregate(Emissions ~ year, NEI[NEI$fips=="24510",], sum)
barplot(plot2$Emissions,names=plot2$year, ylab=expression("Total Emissions, Baltimore City, PM"[2.5]),xlab="Year",
        main=expression('All sources by year, Baltimore City, Total emissions, PM'[2.5]))

plot3 <- aggregate(Emissions ~ year + type, NEI[NEI$fips=="24510",], sum)
gg3 <- qplot(year,Emissions,data=plot3,facets=.~type)
gg3 <- gg3 + ylab(expression("Total Emissions, Baltimore City, PM"[2.5]))
gg3 <- gg3 + xlab("Year of Observation")
gg3 <- gg3 + ggtitle(expression("Total Emissions, Baltimore City, By Emission Type, PM"[2.5]))
gg3 <- gg3 + geom_point(size=8,aes(color=type))
gg3

#SCC[grepl('[C|c]oal',SCC$EI.Sector),]$EI.Sector
#SCC[grepl('[C|c]oal',SCC$EI.Sector),]$SCC

plot4NEI <- NEI[NEI$SCC %in% SCC[grepl('[C|c]oal',SCC$EI.Sector),]$SCC,]
plot4 <- aggregate(Emissions ~ year, plot4NEI, sum)
#qplot(year,Emissions,data=plot4)
qplot(year,Emissions,data=plot4,geom="bar",stat="identity")

library(reshape2)
plot4Melt <- melt(plot4NEI)
plot4yearType <- dcast(plot4Melt, year+SCC~variable,fun.aggregate=sum)
ggplot(data=plot4yearType, aes(y=Emissions,x=year,fill=SCC)) + geom_bar(stat="identity") + theme(legend.position="none")

plot4yearType <- dcast(plot4Melt, year+SCC~variable,fun.aggregate=sum)
fig4_byscc <- ggplot(data=plot4yearType, aes(y=Emissions,x=year,fill=SCC)) + geom_bar(stat="identity") + theme(legend.position="none")
fig4_byscc <- fig4_byscc + ylab(expression("Coal Related Emissions"))
fig4_byscc <- fig4_byscc + xlab("Year of Observation")
fig4_byscc <- fig4_byscc + ggtitle(expression("US Coal Related Emissions by Year (color coded to SCC"))




onRoadNEI <- NEI[NEI$SCC %in% SCC[SCC$Data.Category=="Onroad",]$SCC,]
plot5NEI <- onRoadNEI[onRoadNEI$fips=="24510",]
plot5Melt <- melt(plot5NEI)



onRoadNEI <- NEI[NEI$SCC %in% SCC[SCC$Data.Category=="Onroad",]$SCC,]
plot6NEI <- onRoadNEI[onRoadNEI$fips=="24510"|onRoadNEI$fips=="06037",]
#plot6 <- aggregate(Emissions ~ year + type + fips, plot6NEI, sum)
#qplot(year,Emissions,data=plot6,facets=type~fips)
