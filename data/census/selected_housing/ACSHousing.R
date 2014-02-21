setwd("~git/MissiohHousing/data/census/selected_housing")

require(stringr)

# get list of the files
theFiles <- dir(path="data/PCT12A-O/", pattern = "\\.csv")