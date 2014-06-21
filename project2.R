##Part 0: Download and Unzip Data
if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileName1 = "NEIData.zip"
filePath1 = paste("./data/",fileName1,sep="")
if(!file.exists(filePath1)) 
{
  download.file(fileUrl1,destfile=filePath1,method="curl")
  unzip("./data/NEIData.zip",exdir="./data")
}

## This first line will likely take a few seconds. Be patient!
if(!exists('NEI')) {NEI <- readRDS("data//summarySCC_PM25.rds")}
if(!exists('SCC')) {SCC <- readRDS("data//Source_Classification_Code.rds")}

#prune data


source("plot1.R")
source("plot2.R")
source("plot3.R")
source("plot4.R")
source("plot5.R")
source("plot6.R")
