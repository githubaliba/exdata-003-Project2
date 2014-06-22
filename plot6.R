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
onRoadNEI <- NEI[NEI$SCC %in% SCC[SCC$Data.Category=="Onroad",]$SCC,]
plot6NEI <- onRoadNEI[onRoadNEI$fips=="24510"|onRoadNEI$fips=="06037",]
plot6Melt <- melt(plot6NEI)
plot6yearType <- dcast(plot6Melt, year+SCC+fips~variable,fun.aggregate=sum)
fig6_byscc <- ggplot(data=plot6yearType, aes(y=Emissions,x=year,fill=SCC)) + geom_bar(stat="identity") + theme(legend.position="none")
fig6_byscc <- fig6_byscc + ylab(expression("Motor Vehicle (On-Road) Related Emissions"))
fig6_byscc <- fig6_byscc + xlab("Year of Observation")
fig6_byscc <- fig6_byscc + ggtitle(expression("On-Road Related Emissions by Year (color coded to SCC)"))
fipLabeler <- function(var,value) {
  value <- as.character(value)
  if(var=="fips") {
    value[value=="06037"] <- "Los Angeles"
    value[value=="24510"] <- "Baltimore City"
  }
  return(value)
}
fig6_byscc <- fig6_byscc + facet_grid(.~fips,labeller=fipLabeler)

##Save Plot
if(!file.exists("./figs")){dir.create("./figs")}
png("./figs/plot6.png",height=600,width=800)
fig6_byscc
dev.off()