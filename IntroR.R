# Introduction to R workshop  Nov 13 2018
# Gavin Fay

2 + 2

# read data into R
# reading from an Excel file
install.packages('readxl')
library(readxl)

mydata <- read_xlsx("neus_bts.xlsx","bts", na = "NA")
mydata

summary(mydata)

## do some data analysis
# load in the tidyverse - set of packages that work together
library(tidyverse)

# want to look at mean abundance by year, season, and species
# Tell R that there is a grouping structure to our data
# All functions work the same: name is an action verb saying what the function does
# - 1st argument is the data set, subsequent arguments relate to the particular function
# group_by() tells R that we are going to want to do things to a particular grouping structure
grouped_data <- group_by(mydata, year, season, comname)

# summarise() does a function for each level of the grouping structure
# this is exactly like a pivot table
# here we creat a new variable 'means' that contains the mean abundance
mean_abundance <- summarise(grouped_data, means=mean(abundance))
mean_abundance <- summarise(grouped_data, means=mean(abundance, na.rm = TRUE))  #this version removes the NAs from the mean function.

# print our new summarised object
mean_abundance

## plot the mean abundances over time, by season (color) & species (panels)
ggplot(mean_abundance, aes(x=year, y=means, color=season)) +  #sets up plot, maps variables to plot aesthetics
  geom_point() +  #produces the scatterplot
  facet_wrap(~comname, scales = "free") +   #adds panels (scales argument makes y axes separate by species)
  geom_smooth(method="loess")   #adds the smoother/trend line



###############################
## map the abundance of species
###############################

# use the library 'ggmap'
library(ggmap)

# we'll use stamenmap - which is an alternative to google maps (google changed access to their API recently)
# define the area we want to obtain a map for
mylocation <- c(-72,41,-69,43)  #corners of a box, lon & lat bottom-left, lon & lat top-right
mymap <- get_stamenmap(mylocation, zoom = 9, crop = FALSE)
ggmap(mymap)

# now add the data
ggmap(mymap) +
  geom_point(data = mydata, aes(x=lon,y=lat, size=abundance,color=season)) +
  scale_size_area()

#like before this puts all the data on one map
# add species to separate panels, using facets, just like we did with the scatterplots
ggmap(mymap) +
  geom_point(data = mydata, aes(x=lon,y=lat, size=abundance,color=season)) +
  scale_size_area() +
  facet_wrap(~comname)

# These plots include all the tows where we caught none of a particular species (abundance = 0)
# Let's remove the zeroes by changing the data we pass to geom_point()
no_zeroes <- filter(mydata, abundance > 0)
ggmap(mymap) +
  geom_point(data = no_zeroes, aes(x=lon,y=lat, size=abundance,color=season)) +
  scale_size_area() +
  facet_wrap(~comname)

# Doing the above with Google Earth Maps
# Google recently changed the way you query their API, which makes doing ggmap over GoogleMaps (previously super easy) a little more tricky - you have to register (which is free, but you need to enable billing by entering a credit card), to obtain a key. If all you needed was to register I would give you my key.
# It's pretty easy and only takes a couple of minutes to do:
# https://developers.google.com/maps/documentation/geocoding/usage-and-billing
# it helps to use a newer version of ggmap
if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup")
# once you have a key you can then run:
register_google("paste your key here in quotations")
# proceed as before
mymap <- get_map(mylocation, zoom = 8, crop = FALSE)
ggmap(mymap)




If 