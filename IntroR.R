# Introduction to R workshop  Nov 13 2018

2 + 2

# read data into R
install.packages('readxl')
library(readxl)

mydata <- read_xlsx("neus_bts.xlsx","bts", na = "NA")
mydata

summary(mydata)

library(tidyverse)

grouped_data <- group_by(mydata, year, season, comname)
mean_abundance <- summarise(grouped_data, means=mean(abundance))

ggplot(mean_abundance, aes(x=year, y=means, color=season)) +
  geom_point() +
  facet_wrap(~comname)


