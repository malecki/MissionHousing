setwd("~/git/MissionHousing/data/census/R")

require(stringr)
require(plyr)
require(reshape)

# get list of the files


theFiles <- dir(path="../2009-2012-RaceEthnicity/", pattern = "\\.csv")

for(a in theFiles)
{
  # build a good name to assign to the data
  nameToUse <- str_sub(string=a, start=5, end=26)
  # year <- str_sub(string=a, start=5, end=6)
  
  # read in the csv using read.table
  # file.path is a convenient way to specify a folder and file name
  temp <- read.table(file = file.path("../2009-2012-RaceEthnicity/", a), 
                     header = FALSE, 
                     sep = ",", 
                     stringsAsFactors=FALSE)
  
  # assign them into the workspace
  assign(x = nameToUse, value = temp)
  
  # assign metadata dataframe to dataframe
  search <- str_sub(string=nameToUse, start = 15, end = 22)
  if ( search == "metadata")
  {
    df.metadata <-  temp
  }
  
  # assign annotations dataframe to dataframe
  # transpose annotations df
  # merge metadata and transposed annotations
  if (search == "with_ann")
  {
    df.annotations <- temp
    df.annotations.transposed <- as.data.frame(t(df.annotations))
    names(df.annotations.transposed) <- c("key", "SFCounty","T208", "T209", "T228.01", "T228.02", "T228.03", "T229.01", 
                                          "T229.02", "T229.03")
    nameOfMerged <- str_sub(string=a, start=5, end=12)
    df.merged <- merge(x= df.metadata, y = df.annotations.transposed, by.x="V1", by.y="key", stringsAsFactors=FALSE)
    
    # assign them into the workspace
    assign(x = nameOfMerged, value = df.merged)
  }
}


# only looking for estimates
# create table per year
Race2009 <- `09_5YR_B`[4:24,2:11]
Race2010 <- `10_5YR_B`[4:24,2:11]
Race2011 <- `11_5YR_B`[4:24,2:11]
Race2012 <- `12_5YR_B`[4:24,2:11]
class(Race2012$T208)

# change numbers to numerics
for(i in c(2:ncol(Race2009))) {
  Race2009[,i] <- as.numeric(as.character(Race2009[,i]))
}

# change numbers to numerics
for(i in c(2:ncol(Race2010))) {
  Race2010[,i] <- as.numeric(as.character(Race2010[,i]))
}

# change numbers to numerics
for(i in c(2:ncol(Race2011))) {
  Race2011[,i] <- as.numeric(as.character(Race2011[,i]))
}

# change numbers to numerics
for(i in c(2:ncol(Race2012))) {
  Race2012[,i] <- as.numeric(as.character(Race2012[,i]))
}


# # make a year column values numerics
# y <- c(2009, 2010, 2011, 2012)
# dfs <- list (`09_5YR_B`, `10_5YR_B`,`11_5YR_B`, `12_5YR_B`)
# sum estimates across all census tracks
Race2009$Total2009 <- rowSums(Race2009 [,3:10])
Race2010$Total2010 <- rowSums(Race2010 [,3:10])
Race2011$Total2011 <- rowSums(Race2011 [,3:10])
Race2012$Total2012 <- rowSums(Race2012 [,3:10])


# Combine the data tables together
RaceData <- cbind(Race2009[,c(1,11)], Race2010$Total2010, Race2011$Total2011, Race2012$Total2012)

# # add a year column to the data frame
# y <- seq(from=2010, to= 2012)
# Years <- rep(y, times = 1, length.out = 387, each = 129)
# HousingData$Years <- Years

# Remove 'Estimate;' from row names
RaceData[,1] <- gsub("Estimate; ", "", RaceData[,1])

# write out data to csv file
write.table(RaceData, "RaceData2009-2012.csv", sep=",", col.names= TRUE, row.names = FALSE)




