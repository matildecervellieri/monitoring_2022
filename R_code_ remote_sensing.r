# R code for ecosystem monitoring by remote sensing
# First of all, we need to install additional packages
# raster package to manage image data
# https://cran.r-project.org/web/packages/raster/index.html

install.packages("raster")

library(raster)

# set working directory
setwd("/Users/matildecervellieri/lab/")

# We are going to import satellite data (Landsat program)
# objects cannot be numbers
l2011 <- brick("p224r63_2011.grd")

l2011

plot(l2011)

# B1 is the reflectance in the blue wavelength band
# B2 is the reflectance in the green wavelength band
# B3 is the reflectance in the red wavelength band 
# the higher the reflectance the higher the value 

plot(l2011$B1_sre)

cl <- colorRampPalette(c("black","grey","light grey"))(100)
plot(l2011, col=cl)

plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")

# ------------- day 2
# B1 is the reflectance in the blue wavelength band
# B2 is the reflectance in the green wavelength band
# B3 is the reflectance in the red wavelength band 
# B4 is the reflectance in the NIR band (near infrared)

# Let's plot the green band 
plot(l2011$B2_sre)
# to link we use the dollar simble
# plot is the funciton and the stuff inside the parenthesis is the argument

# "black","grey","light grey" is an arrey in R and it needs the function c 
cl <- colorRampPalette(c("black","grey","light grey"))(100)
plot(l2011$B2_sre, col=cl)

# change the colorRampPalette with dark green, green and light green, e.g. clg
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
plot(l2011$B2_sre, col=clg)

# let's plot the blue band using "dark blue", "blue", "light blue", e.g. clb
plot(l2011$B1_sre)
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

# plot both images in just one multiframe graph
par(mfrow=c(1,2)) # the first number is the number of rows in the multiframe, while the second one is the number of columns 
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

par(mfrow=c(2,1))
plot(l2011$B2_sre, col=clg)
plot(l2011$B1_sre, col=clb)


# ----------------- day 3

# plot the blue band using a blue colorRampPalette
plot(l2011$B1_sre)
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

# multiframe
par(mfrow=c(1,2))

# plot the blue the band and the green besides, with different colorRampPalettes
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
par(mfrow=c(1,2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# Exercise: put the plots one on top of the other
# invert the number of rows and the number of columns 
par(mfrow=c(2,1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# Excercise: plot the first four bands with two rows and two columns 
par(mfrow=c(2,2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)
clr <- colorRampPalette(c("dark red", "red", "pink"))(100)
clnir <- colorRampPalette(c("red", "orange", "yellow"))(100)
plot(l2011$B3_sre, col=clr)
plot(l2011$B4_sre, col=clnir)

# function to clean and close all the windows: it close the plotting device
dev.off()

plotRGB(l2011, r=3, g=2, b=1, stretch="Lin") # natural colour
plotRGB(l2011, r=4, g=3, b=2, stretch="Lin") # false colour
# the red part is the forest, while the white part is the agricultural part of the land
plotRGB(l2011, r=3, g=4, b=2, stretch="Lin") # the forest is green 
plotRGB(l2011, r=3, g=2, b=4, stretch="Lin") # in yellow we can see the part of the forest which has been changed into agriculture

par(mfrow=c(2,2))
plotRGB(l2011, r=3, g=2, b=1, stretch="Lin") 
plotRGB(l2011, r=4, g=3, b=2, stretch="Lin") 
plotRGB(l2011, r=3, g=4, b=2, stretch="Lin") 
plotRGB(l2011, r=3, g=2, b=4, stretch="Lin")

# --------------- day 4 final day on this tropical forest reserve 
plotRGB(l2011, r=4, g=3, b=2, stretch="Lin") # false colour -> the stretch is to improve the range for reflection to 0 to 1, so we can view better 
plotRGB(l2011, r=4, g=3, b=2, stretch="Hist") # it enhanced the extremes part so we can view beetter the differences 

# now we are importing in R the version of 1988. Remember to use quotes 
l1988 <- brick("p224r63_1988.grd")
l1988

par(mfrow=c(2,1))
plotRGB(l1988, r=4, g=3, b=2, stretch="Lin")
plotRGB(l2011, r=4, g=3, b=2, stretch="Lin")
# in 1988 the forest was there, theey were just building some houses, but in 2011 thee situation is dramatic, there are agricultural fields and the forest is becoming smaller in such a little time 

# Put the NIR in the blue channel 
par(mfrow=c(2,1))
plotRGB(l1988, r=2, g=3, b=4, stretch="Lin")
plotRGB(l2011, r=2, g=3, b=4, stretch="Lin")


