# R codes for plot3

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

class(powerDT$Time)
# Making a POSIXct date capable of being filtered and graphed by time of day
powerDT$dateTime<-paste(powerDT$Date, powerDT$Time, sep=" ")
powerDT$dateTime<-as.POSIXct(strptime(powerDT$dateTime, "%Y-%m-%d %H:%M:%S"))
class(powerDT$dateTime)

# plot 3 : time vs energy sub metering 
library(png)
png("./plots/plot3.png", width=480, height=480)
plot(x=powerDT[,dateTime], y=powerDT[,Sub_metering_1], type = "l", xlab="", ylab="Energy sub metering")
lines(powerDT$dateTime,powerDT$Sub_metering_2, col="red")
lines(powerDT$dateTime, powerDT$Sub_metering_3, col="blue")
legend("topright",col=c("black","red","blue"),
       c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       lty=c(1,1), lwd=c(1,1))
dev.off()
