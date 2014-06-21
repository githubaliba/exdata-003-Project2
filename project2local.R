dataDir = "./data"
if(!file.exists(dataDir)) {dir.create(dataDir)}
fileUrl1="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName1="NEIData.zip"
filePath1=paste0("./data/",fileName1)
download.file(fileUrl1,filePath1)
unzip(filePath1,exdir=dataDir)

NEI <- readRDS("data//summarySCC_PM25.rds")
SCC <- readRDS("data//Source_Classification_Code.rds")

NEI$year <- as.factor(NEI$year)
NEI$type <- as.factor(NEI$type)
NEI$Pollutant <- as.factor(NEI$Pollutant)

plot1 <- aggregate(Emissions ~ year, NEI, sum)
barplot(plot1$Emissions,names=plot1$year)

plot2 <- aggregate(Emissions ~ year, NEI[NEI$fips=="24510",], sum)
barplot(plot2$Emissions,names=plot2$year)

plot3 <- aggregate(Emissions ~ year + type, NEI, sum)


#SCC[grepl('[C|c]oal',SCC$EI.Sector),]$EI.Sector
#SCC[grepl('[C|c]oal',SCC$EI.Sector),]$SCC

plot4NEI <- NEI[NEI$SCC %in% SCC[grepl('[C|c]oal',SCC$EI.Sector),]$SCC,]



plot6NEI <- NEI[NEI$fips=="24510"|NEI$fips=="06037",]
