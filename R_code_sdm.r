# R code for species distribution modelling, namely the distribution of individuals in space 

# install.packages("sdm")
library(sdm)
library(raster) # predictors
library(rgdal) # species
# we don't need to set the working directory, since the data are not in our lab folder but are in the package

# the function system.files is showing all of the files in a certain package 
# it's a shapefile 
file <- system.file("external/species.shp", package="sdm") # we're using quotes 
file 

# shape file function: we're going to import that shape file
species <- shapefile(file) # exactly as the raster function for raster files, but they are points in space

plot(species, pch=19, col="red") # pch are the labels 
# we can see the points scattered in space, we can divide them in presence and absence points 

