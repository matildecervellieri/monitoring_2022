# R code for species distribution modelling, namely the distribution of individuals of a population in space 

# install.packages("sdm")
library(sdm) # species distribution modelling package 
library(raster) # predictors: environmental data that help to predict the presence of species
library(rgdal) # species: used for coordinates -> species are an array of c, y points (x0, y0), (x1, y1), ..., (xn, yn)
# we don't need to set the working directory, since the data are not in our lab folder but are in the package

# species data
# the function system.files is showing all of the files in a certain package 
# "external/species.shp" is a shapefile 
file <- system.file("external/species.shp", package="sdm") # we're using quotes 
file # we have the path of the file 

# shape file function: we're going to import that shape file
species <- shapefile(file) # exactly as the raster function for raster files, but they are points in space
species # occurrence is the only variable 
species$Occurrence # we will have all the 200 occurrences: 0 if there isn't the specie, while 1 if the specie has been found

# Subset a DataFrame 
# sql: common language to query the data set. We whant to subset the data set: equal to 1 
# we want to know how many 1 there are: how many occurrences are there?
# to put equal in query we need to use ==, while non equal is made by using !=
species[species$Occurrence == 1,] # to stop the query we need to use the comma
# 94 points have the occurrence of the specie 
presences <- species[species$Occurrence == 1,]
presences

# now we want to know the absences:
species[species$Occurrence != 1,] # 106 points with no specie
# or species[species$Occurrence == 0,]
absences <- species[species$Occurrence != 1,]
absences

# plot!
# pch are the labels 
plot(species, pch=19) # 200 points
# we can see the points scattered in space, we can divide them in presence and absence points 
plot(presences, pch=19, col="blue") # 94 points
plot(absences, pch=19, col="red") # 106 points 
# but by doing this we erase the previous plot

# we want the same graph with the two colours points: we use the function points
plot(presences, pch=19, col="blue") # plot the presences
points(absences, pch=19, col="red") # point of the absences 
# we have the presences in blue and the absences in red

# we want to know the probability to find the species in a part of the area in which we don't have the known points
# we need to use predictors, so raster layers which can predict the probability of the specie's presence : look at the path 
path <- system.file("external", package="sdm")
path # we get the folder's path in which is stored the raster data 

# list the predictors 
# ASCII is the type of file and the extension is .asc
lst <- list.files(path, pattern="asc", full.names=T) # the common pattern to all of the file is asc extension
lst

# making a stack: put the files all together with the stack function 
# we can use the lapply function 
preds <- stack(lst)
preds

# plot predictors
cl <- colorRampPalette(c("blue","orange","red","yellow"))(100)
plot(preds, col=cl)
# the north and west part are at low elevation and we can see they have an higher temperature 
# vegetation and precipitation -> precipitation is high in the yellow part

# plot predicors and occurrences: in particular elevation and presences
plot(preds$elevation, col=cl)
points(presences, pch=19) # this will add the points on top of the previous plot
# presences are found in the low elevation part

# let's see the same thing with temperature
plot(preds$temperature, col=cl)
points(presences, pch=19)
# loving high temperatures, the low temperature part is avoided by this specie

# vegetation 
plot(preds$vegetation, col=cl)
points(presences, pch=19)
# we can find the specie in parts with vegetation 

# precipitation
plot(preds$precipitation, col=cl)
points(presences, pch=19)
# intermediate precipitation is linked with the presence of the specie


# ------------- day 2 

# importing the source script: we saved the link from Virtuale to the lab folder to import all the previous code
# first we need to set the working directory
setwd("/Users/matildecervellieri/lab/")
source("R_code_source_sdm.r")

# in the theoretical slide of SDMs we should use individuals of a species and predictors
# the species shapefile is also called training data
preds
# these are the predictors: elevation, precipitation, temperature, vegetation 
# explanatory variables is the other name to call the predictors 

# species ditribution model 
# we're building the model and then we will have the map 

# Set the data for the sdm
# Let's explain to the model what are the training and predictors data
datasdm <- sdmData(train=species, predictors=preds)
datasdm # features are the predictors, type of data is presence/absence (it may happens that we have abbundances, which means that is specified the amount of individuals of the species)

# SDM
m1 <- sdm(Occurrence~temperature+elevation+precipitation+vegetation, data=datasdm, methods="glm") # Occurrence is the y-variable, while the temperature is the x-variable. We sum the others because we have 4 variables as predictors
m1 


