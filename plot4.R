#plot4.R
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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
plot4NEI <- NEI[NEI$SCC %in% SCC[grepl('[C|c]oal',SCC$EI.Sector),]$SCC,]
plot4 <- aggregate(Emissions ~ year, plot4NEI, sum)
#qplot(year,Emissions,data=plot4)
fig4 <- qplot(year,Emissions,data=plot4,geom="bar",stat="identity")
fig4 <- fig4 + ylab(expression("Coal Related Emissions"))
fig4 <- fig4 + xlab("Year of Observation")
fig4 <- fig4 + ggtitle(expression("US Coal Related Emissions by Year"))

library(reshape2)
plot4Melt <- melt(plot4NEI)
plot4yearType <- dcast(plot4Melt, year+SCC~variable,fun.aggregate=sum)
fig4_byscc <- ggplot(data=plot4yearType, aes(y=Emissions,x=year,fill=SCC)) + geom_bar(stat="identity") + theme(legend.position="none")
fig4_byscc <- fig4_byscc + ylab(expression("Coal Related Emissions"))
fig4_byscc <- fig4_byscc + xlab("Year of Observation")
fig4_byscc <- fig4_byscc + ggtitle(expression("US Coal Related Emissions by Year (color coded to SCC)"))

##Save Plot
if(!file.exists("./figs")){dir.create("./figs")}
png("./figs/plot4.png",height=600,width=800)
fig4_byscc
dev.off()