#plot5.R
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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
onRoadNEI <- NEI[NEI$SCC %in% SCC[SCC$Data.Category=="Onroad",]$SCC,]
plot5NEI <- onRoadNEI[onRoadNEI$fips=="24510",]
plot5Melt <- melt(plot5NEI)
plot5yearType <- dcast(plot5Melt, year+SCC~variable,fun.aggregate=sum)
fig5_byscc <- ggplot(data=plot5yearType, aes(y=Emissions,x=year,fill=SCC)) + geom_bar(stat="identity") + theme(legend.position="none")
fig5_byscc <- fig5_byscc + ylab(expression("Motor Vehicle (On-Road) Related Emissions"))
fig5_byscc <- fig5_byscc + xlab("Year of Observation")
fig5_byscc <- fig5_byscc + ggtitle(expression("Baltimore City On-Road Related Emissions by Year (color coded to SCC)"))


##Save Plot
if(!file.exists("./figs")){dir.create("./figs")}
png("./figs/plot5.png",height=600,width=800)
fig5_byscc
dev.off()