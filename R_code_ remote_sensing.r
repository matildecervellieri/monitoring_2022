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






