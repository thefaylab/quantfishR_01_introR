# Introduction to R workshop  Nov 13 2018

2 + 2

# read data into R
install.packages('readxl')
library(readxl)

mydata <- read_xlsx("neus_bts.xlsx","bts", na = "NA")
mydata

