setwd("~git/MissiohHousing/data/census/R")

require(stringr)

# get list of the files
theFiles <- dir(path="data/PCT12A-O/", pattern = "\\.csv")
