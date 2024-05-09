# Project1
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
    #  will only be using data from the dates 2007-02-01 and 2007-02-02.
class(powerDT$Date)
powerDT$Date<-as.Date(powerDT$Date, "%d/%m/%Y")
library(dplyr)
powerDT<-filter(powerDT, Date>="2007-02-01", Date<="2007-02-02")

    #  Fork and clone the following GitHub repository (link: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo)
# A fork is a new repository that shares code and visibility settings with the original “upstream” repository
# 1. navigate to "https://github.com/rdpeng/ExData_Plotting1" repository
# 2. In the top-right corner of the page, click Fork
# 3.By default, forks are named the same as their upstream repositories. Optionally, to further distinguish your fork, 
#   in the "Repository name" field, type a name. (e.g., ExData_Plotting1_Annabelle)
# 4.Optionally, in the "Description" field, type a description of your fork.
# 5. Optionally, select Copy the DEFAULT branch only. (If you do not select this option, all branches will be copied into the new fork.)
# 6. Click Create fork.
############################
# (Cloning your forked repository):Right now, you have a fork of the Spoon-Knife repository, 
#             but you do not have the files in that repository locally on your computer.
# 7. On GitHub.com, navigate to your fork of the Spoon-Knife repository.
# 8. Above the list of files, click  Code.
# 9. Copy the URL for the repository.(e.g.https://github.com/AnnabelleWg/ExData_Plotting1_Annabelle.git)
# 10. Open Terminal
# 11. Change the current working directory to the location where you want the cloned directory.
# 12. Type git clone, and then paste the URL you copied earlier.Then, press Enter. Your local clone will be created.
############################
# 13. (Configuring Git to sync your fork with the upstream repository)
# 14.On GitHub.com, navigate to the octocat/Spoon-Knife repository. Above the list of files, click  Code.
# 15. Copy the URL for the repository.
# 16.Open Terminal.Change directories to the location of the fork you cloned.
#   > go to the home directory. Type "cd"
#.  > To list the files and folders in your current directory, type "ls" .
#   > To go into one of your listed directories, type "cd YOUR-LISTED-DIRECTORY" .
#   > To go up one directory, type "cd .." .
# 17. Type "git remote -v" and press Enter. You will see the current configured remote repository for your fork.
# 18. Type "git remote add upstream", and then paste the URL you copied in Step 15 and press Enter. It will look like this:
#.    " git remote add upstream https://github.com/rdpeng/ExData_Plotting1.git"
# 19. To verify the new upstream repository you have specified for your fork, type "git remote -v" again. 
#     You should see the URL for your fork as origin, and the URL for the upstream repository as upstream.

# Creating and deleting branches within your repository
# 1.On GitHub.com, navigate to the main page of the repository.
# 2.Click New branch.
# 3. Under "Branch name", type a name for the branch.
# 4. Under "Branch source", choose a source for your branch.
#.   > If your repository is a fork, select the repository dropdown menu and click your fork or the upstream repository.
#.   > Select the branch dropdown menu and click a branch.

    # Making plot
#For each plot you should:
# Construct the plot and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.
# Name each of the plot files as plot1.png; plot2.png

# Create a separate R code file (plot1.R, plot1.R,etc.) that constructs the corresponding plot
# Your code file should include code for reading the data so that the plot can be fully reproduced. You must also include the code that creates the PNG file.

# Add the PNG file and R code file to the top-level folder of your git repository (no need for separate sub-folders)

# Plot1: frequency plot of global active power
class(powerDT$Global_active_power)
#getwd()
if(!file.exists("./plots")) {dir.create("./plots")}

library(png)
png(file="./plots/plot1.png", width=480, height=480) # open png device and creat a file named plot.png
hist(powerDT$Global_active_power, col="red", xlab ="Global Active Power(kilowatts)", main="Global Active Power")
dev.off()

#getwd()

# plot2
class(powerDT$Time)
# Making a POSIXct date capable of being filtered and graphed by time of day
powerDT$dateTime<-paste(powerDT$Date, powerDT$Time, sep=" ")
powerDT$dateTime<-as.POSIXct(strptime(powerDT$dateTime, "%Y-%m-%d %H:%M:%S"))
class(powerDT$dateTime)
#powerDT<-select(powerDT,-datetime)
#powerDT$dtWD<-weekdays(powerDT$dateTime)

library(png)
png("./plots/plot2.png", width=480, height=480)

plot(x = powerDT[, dateTime]
     , y = powerDT[, Global_active_power]
     , type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()


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

# plot 4
library(png)
png("./plots/plot4.png", width=480, height=480)
par(mfrow=c(2,2))

# plot 4.1
plot(powerDT$dateTime, powerDT$Global_active_power, xlab="",ylab="Global Active Power",type="l")
# plot 4.2
plot(powerDT$dateTime, powerDT$Voltage, ylab="Voltage", xlab="datetime",type="l")
# plot 4.3
plot(powerDT$dateTime, powerDT$Sub_metering_1, xlab="",ylab="Energy Sub metering",type="l")
lines(powerDT$dateTime, powerDT$Sub_metering_2, col="red")
lines(powerDT$dateTime, powerDT$Sub_metering_3, col="blue")
legend("topright",col=c("black","red","blue"),
       c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
       lty=c(1,1), bty="n", cex=.5)
#plot 4.4
plot(powerDT[, dateTime], powerDT[, Global_reactive_power]
     , type="l", xlab="datetime", ylab="Global_reactive_power")
dev.off()
