# R codes for plot 1

# Download and load data set.
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
              destfile = "./data/electricPowerConsump.zip", method="curl")
unzip("./data/electricPowerConsump.zip",exdir="./data")
library("data.table")

   # calculate a rough estimate of how much memory the dataset will require in memory before reading into R.
file.info("./data/household_power_consumption.txt")
powerDT <- data.table::fread(input = "./data/household_power_consumption.txt"
                             , na.strings="?"
)


# clean dataset
class(powerDT$Date)
powerDT$Date<-as.Date(powerDT$Date, "%d/%m/%Y")
library(dplyr)
powerDT<-filter(powerDT, Date>="2007-02-01", Date<="2007-02-02")

# Plot1: frequency plot of global active power
class(powerDT$Global_active_power)
#getwd()
if(!file.exists("./plots")) {dir.create("./plots")}
library(png)
png(file="./plots/plot1.png", width=480, height=480) # open png device and create a file named plot.png
hist(powerDT$Global_active_power, col="red", xlab ="Global Active Power(kilowatts)", main="Global Active Power")
dev.off()