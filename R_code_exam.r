library(raster)
library(ggplot2)
library(RStoolbox)
library(patchwork)
library(viridis)
library(ncdf4)
library(gridExtra)

# Set the working directory
setwd("/Users/matildecervellieri/lab/exam/")

# importing files: first we make a list and then use the lapply function 
lst_list <- list.files(pattern="LST")
lst_list

lst_import <- lapply(lst_list, raster)
lst_import # 3 files imported inside r. 

# stacking them all together
lst <- stack(lst_import)
lst

# Let's change their names
names(lst) <- c("lst_2010", "lst_2015", "lst_2020")
names(lst)
lst


