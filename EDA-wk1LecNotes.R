# week 1 Lecture notes-Principles of Analytic Graphics 
  # principle 1. Show comparisons
  # principle 2. show causality, mechanism
  # principle 3. show multivariable data
  # principle 4. integration evidence
  # principle 5. Describe and document the evidence with appropriate lable, scales, and source, etc.
  # principle 6. content is king

# Exploratory graphs
pollutioon<-read.csv("./data/avgpm25.csv", colClasses = c("numeric","character","factor","numeric","numeric"))
head(pollution)
    # 6 number summary
summary(pollution$pm25)
    # BoxpLot
boxplot(pollution$pm25, col="blue")
abline(h=12)
    # histogram
hist(pollution$pm25,col="green", breaks=100)
rug(pollution$pm25)
abline(v=12, lwd=2) #overlaying features
abline(v=median(pollution$pm25),col="magenta",lwd=4)
    #barplot -for categorical data
barplot(table(pollution$region),col="wheat", main="Number of Counties in East Region")

  # multiple Boxplots
boxplot(pm25~region, data=pollution, col="red")
  # multiple hist
par(mfrow=c(1,2),mar=c(4,4,2,1))
hist(subset(pollution, region=="east")$pm25, col="green")
hist(subset(pollution, region=="west")$pm25, col="green")
  # scatterplot-Using color
with(pllution, plot(latitude, pm25, col=region))
abline(h=12, lwd=2, lty=2)
  # Multiple scatterplots
par(mfrow=c(1,2), mar=c(5,4,2,1))
with(subset(pollution, region=="west"),plot(latitude, pm25, main="West"))
with(subset(pollution, region=="east"),plot(latitude, pm25, main="East"))


# plotting system in R
  # Base plot system
    # plotting functions including plot, hist, boxplot and many others.
    # there are2 phases to creating a base plot: Initializing a new plot, Annotating(adding to) an existing plot
    # the system has many parameters that can set and tweaked. use ?par to find out more
    # Some important base graphics parameters:
#.pch:the plotting symbols
#.lty:the line type
#.lwd:the line width
#.col: the plotting color
#.xlab:character string for the x-axis label
#.ylab:characer string for the y-axis label.

    # The par() function is used to specify global graphics parameters that affect all plots in an R session
    #.  These parameters can be overridden when specified as arguments to specific plotting functions.
#.las:the orientation of the axis on the plot
#.bg: the background color
#.mar:the margin size
#.oma:the outer margin size 
#.mfrow: number of plots per row,column (plots are filled row-wise)
#.mfcol: number of plots per row, column (plots are filled column-wise)
par("bg")
par("mar")

    # base plotting function
#.plot: make a scatterplot or other types of plot depending on the class of the object
#.lines: add line to a plot, given a vector x values and a corresponding vector of y values
#.points: add points to a plot
#.text: add text labels to a plot using specified x.y coordinates
#.title: add annotation to x, y axis labels, title, subtitle,outer margin.
#.mtext: add arbitrary text to the margins (inner or outer) of the plot
#.axis: adding axis ticks/labels

    # Summary
# plots are created by calling successive R functions to build up a plot
library(datasets)
hist(airquality$Ozone)

with(airquality,plot(Wind, Ozone))
airquality<-transform(airquality, Month=factor(Month))
boxplot(Ozone~Month,airquality,xlab="Month",ylab="Ozone (ppb)")

with(airquality, plot(Wind, Ozone))
title(main="Ozone and Wind in New York City")

with(airquality,plot(Wind,Ozone, main="Ozone and Wind in New York City"))
with(subset(airquality,Month==5), points(Wind,Ozone, col="blue"))

with(airquality,plot(Wind,Ozone, main="Ozone and Wind in New York City"), type="n") # set up all other stuff in the plot without the actual data.
with(subset(airquality, Month==5), points(Wind, Ozone, col="blue"))
with(subset(airquality, Month!=5), points(Wind, Ozone, col="red"))
legend("topright",pch=1,col=c("blue","red"),legend=c("May","Other Months"))
# add  regression line
with(airquality,plot(Wind,Ozone, main="Ozone and Wind in New York City"), pch=20)
model<-lm(Ozone~Wind, airquality)
abline(model, lwd=2)

#multiple base plots
par(mfrow=c(2,2))
with(airquality,{
  plot(Wind, Ozone,main="Ozone and Wind")
  plot(Solar.R, Ozone, main="Ozone and Solar Radiation")
  mtext("Ozone and Weather in New York City", outer=TRUE)
})

data(cars)
with(cars, plot(speed, dist))

example(points)

x<-rnrom(100)
y<-rnrom(100)
plot(x,y,pch=20, xlabs="Weight",ylabs="Height")
title("scatterplot")
text(-2,-2,"label")
legend("topleft",legend="Data",pch=20)
fit<=lm(y~x)
abline(fit)
abline(fit, lwd=3)
abline(fir, lwd=3, col="blue")

z<-rpois(100)
par(mfrow=c(2,2))
plot(x,y)
plot(x,z)
plot(z,x)
plot(y,x)

g<-gl(2,50, labels=c("Male","Female"))
str(g)
plot(x,y, type="n")
points(x[g=="Male"],y[g=="Female"],col="green")

  # the Lattice system
    # plots are created with a single function call (xyplot,bwplot,levelplot)
library(lattice)
state<-data.frame(state.x77,region=state.region)
xyplot(Life.Exp~Income|region,data=state,layout=c(4,1))

  # the ggplot2 system
library(ggplot2)
data(mpg)
qplot(displ, hwy, data=mpg)
