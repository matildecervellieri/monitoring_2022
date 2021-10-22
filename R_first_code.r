# This is my first code in github! Quite exciting, right?

# Here are the input data
# Costanza date on streams
water <- c(100, 200, 300, 400, 500)
water

# Marta data on fishes genomes
fishes <- c(10, 50, 60, 100, 200)
fishes

# plot the diversity of fishes (y) versus the amount of water (X)
# a function is used with arguments inside!
plot(water, fishes) 

# the data we developed can be stored in a table 
# a table in R is called data frame 

streams <- data.frame(water, fishes) 
streams 

# From now on, we are going to import and/or export data!
# setwd Mac
# setwd("/Users/yourname/lab/")
setwd("/Users/matildecervellieri/lab/")

# Let's export out table! 
# https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/write.table
write.table(streams, file="my_first_table.txt")

# Some collegues did send us a table How to import it in R?
read.table("my_first_table.txt")
# let's assign it to an object inside R
matitable <- read.table("my_first_table.txt")
matitable

# the first statistics for lazy beautiful people 
summary(matitable)

# Marta does not like water
# Marta wants to get info only on fishes
summary(matitable$fishes) 

#histogram
hist(matitable$fishes)
hist(matitable$water)
