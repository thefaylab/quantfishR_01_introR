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

## map the abundance of species

# use the library 'ggmap'
library(ggmap)

# we'll use stamenmap - which is an alternative to google maps (google changed access to their API recently)
# define the area we want to obtain a map for
mylocation <- c(-72,41,-69,43)  #corners of a box, lon & lat bottom-left, lon & lat top-right
mymap <- get_stamenmap(mylocation, zoom=9)

#myMap <- get_map(location=mylocation, source = "google", maptype = "terrain",
#                 crop = FALSE, zoom= 8)

p <- ggmap(myMap) +
  geom_point(aes(x=lon,y=lat,size=abundance, color = season),
             data = neus) +
  #data=filter(neus,comname %in% c("SPINY DOGFISH","ATLANTIC COD"))) +
  #color = "orange", alpha = 1) + #0.05) +
  scale_size_area() #+
#guides(colour = guide_legend(override.aes = list(alpha = 1,
#                                                  color = "orange")))
p + facet_wrap(~comname)


