# Lattice plotting system
    # All plotting/annotation is done at once with a single function call.
    # Generally, take a formula for their 1st argument; 2nd argument is the data frame 
    #     or list form which the variables in thee formula should be looked up.
    # return an object of class trellis
    # Ideal for creating conditioning plots where you examine the same kind of plot under many different conditions.
    
    # functions: xyplot (main function for creating scatterplot);
    # bwplot(box-and-whiskers plots), levelplot, counterplot(plotting "image data")
    # histogram
    # stripplot (like a boxpotnbut with actual points)
    # dotplot (plot dots on "violin strings")

# simple Lattice plot
library(lattice)
library(datasets)
p<-xyplot(Ozone~ Wind,data=airquality) # Nothing happens
print(p)

    
#convert "month" to a factor variable
airquality<-transform(airquality, Month=factor(Month))
# look at the relationship between ozone and wind for each level of month
xyplot(Ozone~Wind|Month, data=airquality,layout=c(5,1))

# Lattice Panel Function: controls what happens inside each panel of the plot.
#.     panel functions receive the x/y coordinate of the data points in their panel
library(stats)
set.seed(10)
x<-rnorm(100)
f<-rep(0:1, each=50)
y<-x+f-f*x+rnorm(100, sd=0.5)
f<-factor(f, labels=c("Group1","Group2"))
xyplot(y~x|f, layout=c(2,1)) ## plot with 2 panels
    # custom panel function
xyplot(y~x|f, panel=function(x,y,...){
  panel.xyplot(x,y,...) # first call the default panel function for xyplot()
  panel.abline(h=median(y),lty = 2) # Add a horizontal line at the median
})

# Lattice Panel Functions: Regression line
# custom panel function
xyplot(y~x|f, panel=function(x,y,...){
  panel.xyplot(x,y,...) # first call default function for xyplot
  panel.lmline(x,y,col=2) # over lay a simply linear regression line
})

# ggplot2
    # grammar: a statistical graphics is a 'mapping' from data to 'aesthetic'
    # attributes (color,shape, size) of 'geometric objects(points, lines, bars)
library(ggplot2)
str(mpg)
qplot(displ, hwy, data=mpg, color=drv)
# adding a geom
qplot(displ,hwy, data=mpg, geom=c("point","smooth"))
# hist
qplot(hwy, data=mpg, fill=drv)

# Facets: like panels
qplot(displ, hwy, data=mpg, facets=.~drv) # the right-hand side of the tilde = columns of a matrix
qplot(hwy, data=mpg, facets=drv.~, binwidth=2) # the variable of the left-hand side of the tilde= the rows of a matrix

str(maacs)
qplot(log(eno), data=maacs, fill=mopos)
# density smooth
qplot(log(eno),data = maacs, geom="density", color=mopos)
# Scatterplot
qplot(log(pm25),log(eno),data=maacs, shape=mopos)
qplot(log(pm25),log(eno),data=maacs, color=mopos)
qplot(log(pm25),log(eno),data=maacs, color=mopos)+genom.smooth(method="lm")
qplot(log(pm25),log(eno),data=maacs, facets=.~ mopos)+genom.smooth(method="lm")
qplot(logpm25, NocturnaSympt, data=maacs, facets = .~bmicat, geom=c("point","smooth"), method="lm")

# building up in layers
head(maacs[,1:3])
    # 1st plot with point payer
g<-ggplot(maacs, aes(logpm25,NocturnalSympt)) # no plot yet
summary(g)
p<-g+geom_point()
print(p)

    # adding more layers: smooth
g+geom_point()+geom_smooth() #the default is the lowess smoother
g+geom_point()+geom_smooth(method="lm")

    # adding more layers: facets
g+geom_point()+facet_grid(.~bmicat)+geom_smooth(method="lm")

    # Annotation
# for things, that only make sense globally, use theme(). (e.g. theme(legend.position="none))
# 2 standard appearance themes are : theme_gray(): the default theme; theme_bw(): more stark/plain
g+geom_point(color="steelblue", size=4, alpha=1/2) # constant variable
g+geom_point(aes(color=bmicat), size=4, alpha=1/2) # data variable

# modifying labels
g+geom_point(aes(color=bmicat),labs(title="MAACS Cohort"),labs(x=expression("log"*PM[2.5]), y="Nocturnal Symptoms"))

# Customizing the Smooth
g+geom_point(aes(color=bmicat), size=2, alpha=1/2)+geom_smooth(size=4, linetype=3, method="lm",se=FALSE)
g+geom_point(aes(color=bmicat))+theme_bw(base_family="Times")

  # Axis limits
testdat<-data.frame(x=1:100, y=rnrom(100))
testdat(50,2)<-100 # outlier
plot(testdat$x, testdat$y, type="1",ylim=c(-3,3) )
g<-ggplot(testdat,aes(x=x, y=y))
g+geom_line()+coord_cartesian(ylim=c(-3,3))

    # more example
# How does the relationship b/w PM2.5 and nocturnal symptoms vary by BMI and NO2 ?
# Make NO2 categorical, using the cut() function for this

# calculate the deciles of the data
cutpoints<-quantile(maacs$logno2_new,deq(0,1,length=4), na.rm=TRUE)

# cut the data at the deciles and create a new factor variable
maacs$no2fec<-cut(maacs$logno2_new, cutpoints)

# see the levels of the newly created factor variable
levels(maacs$no2dec)

# final plot
## set up plot with data frame
g<-ggplot(maacs, aes(logpm25, NocturnalSympt))

## add layers
g+geom_point(alpha=1/3)#add points
+facet_wrap(bmicat-no2dec, nrow=2, ncol=4)#make panels
+geom_smooth(method="lm", se=FALSE, col="steelblue") #add smoother
+theme_bw(base_family = "Avenir", base_size = 10) # change theme to black-white 
+labs(x= expression("log"*PM[2.5]))
+labs(y= "Nocturnal Symptoms")
+labs(title="MAACS Cohort")

# Swirl Lesson: Lattics plotting system

#typical lattice plot call,  xyplot(y ~ x | f * g, data). 
  #The f and g represent the optional conditioning variables.
  # The * represents interaction between them.
xyplot(Ozone ~ Wind, data = airquality)
# change the dot color, the ploting character, and add title
xyplot(Ozone ~ Wind, data = airquality, pch=8, col="red", main="Big Apple Data")
# multi-pane plot
xyplot(Ozone ~ Wind | as.factor(Month), data = airquality, layout=c(5,1))
# better store the code
p <- xyplot(Ozone~Wind,data=airquality)
p <- xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)  ## First call the default panel function for 'xyplot'
  panel.abline(h = median(y), lty = 2)  ## Add a horizontal line at the median
})
print(p)
invisible()

p
print(p)
p[["formula"]]
p[["x.limits"]]

p2 <- xyplot(y ~ x | f, panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)  ## First call default panel function
  panel.lmline(x, y, col = 2)  ## Overlay a simple linear regression line
})
print(p2)
invisible()

xyplot(y~x|f, layout=c(2,1)) # the first 50 entries of f are "group 1" and the last 50 are "group 2"
source(pathtofile("plot1.R"),local=TRUE)

library(datasets)
str(diamonds)
table(diamnds$color)
?myedit

# Swirl lesson: ggplot2
library(ggplot2)
str(mpg)
qplot(displ, hwy, data=mpg, color=drv, geom=c("points",smooth))
qplot(drv, hwy, data=mpg,geom="boxplot", color="manufacturer")

qplot(hwy, data=mpg, fill=drv)

#do two plots, a scatterplot and then a histogram, each with 3 facets.
qplot(displ, data=mpg, facets = .~drv) # qplot() stands for quick plot
qplot(hwy, data=mpg, facets= drv~., binwidth=2)

g<-ggplot(mpg, aes(displ, hwy)) # the 2nd argument tells what we want to plot
g #will get an error
print(g) #will get an error.ggplot doesn't know how to display the data yet 
         ##since you didn't specify how you wanted to see it.

# by calling geom_point() you added a layer. 
g+geom_point() # don't have to pass any arguments to the function geom_point() as g has all the data stored in it.
g+geom_smooth()+geom_point()
g+geom_point()+geom_smooth(method="lm") #try different smoother
g+geom_point()+geom_smooth(method="lm")+facet_grid(.~drv)
g+geom_point()+geom_smooth(method="lm")+facet_grid(.~drv)+ggtitle("Swirl Rules!")
g+geom_point(color="pink",size=4,alpha=1/2)
g + geom_point(aes(color = drv), size = 4, alpha = 1/2)
g + geom_point(aes(color = drv), size = 4, alpha = 1/2)+labs(title="Swirl Rules")+labs(x="Displacement", y="Hwy Mileage")
# modify plot theme
g+geom_point(aes(color=drv))+theme_bw(base_family = "Times")

# the base plotting system
  # one outlier was in the data set
plot(myx, myy, type = "l", ylim = c(-3,3)) # the outlier was not shown in the line plot
g<-ggplot(testdat, aes(x=myx, y=myy))
g+geom_line()
g+geom_line()+ylim(-3,3) # by doing this, ggplot would ignore the outlier
g+geom_line()+ coord_cartesian(ylim = c(-3,3))

g<-ggplot(mpg, aes(x=displ, y=hwy, color=factor(year)))
g+geom_point()+ 

# week2 Quiz
library(ggplot2)
library(datasets)
airquality=transform(airquality,Month=factor(Month))
qplot(Wind, Ozone, data=airquality, facets = .~Month)

# what is a geom in the ggplo2 system ?
# a plotting object like point, line, or other shape.

library(ggplot2)
qplot(votes, rating, data=movies)
qplot(votes, rating, data = movies)+geom_smooth()
