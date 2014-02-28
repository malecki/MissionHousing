setwd("~/git/MissionHousing/data/census/R")

require(stringr)
require(plyr)
require(reshape)

# get list of the files


theFiles <- dir(path="../2009-2012-SelectedHousing/", pattern = "\\.csv")
# drop 2009 data
theFiles <- theFiles[-1:-2]
theFiles

for(a in theFiles)
{
  # build a good name to assign to the data
  nameToUse <- str_sub(string=a, start=5, end=24)
  # year <- str_sub(string=a, start=5, end=6)
  
  # read in the csv using read.table
  # file.path is a convenient way to specify a folder and file name
  temp <- read.table(file = file.path("../2009-2012-SelectedHousing/", a), 
                     header = FALSE, 
                     sep = ",", 
                     stringsAsFactors=FALSE)
  
  # assign them into the workspace
  assign(x = nameToUse, value = temp)
  
  # assign metadata dataframe to dataframe
  search <- str_sub(string=nameToUse, start = 13, end = 20)
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
    names(df.annotations.transposed) <- c("key", "T208", "T209", "T228.01", "T228.02", "T228.03", "T229.01", 
                                          "T229.02", "T229.03")
    nameOfMerged <- str_sub(string=a, start=5, end=12)
    df.merged <- merge(x= df.metadata, y = df.annotations.transposed, by.x="V1", by.y="key", stringsAsFactors=FALSE)
    
    # assign them into the workspace
    assign(x = nameOfMerged, value = df.merged)
  }
}


# I'm only interested in the housing data (rows 1-129)
Housing2010 <- `10_5YR_D`[1:129,]
Housing2011 <- `11_5YR_D`[1:129,]
Housing2012 <- `12_5YR_D`[1:129,]

# make column values numerics
y <- c(2010, 2011, 2012)
dfs <- list (Housing2010, Housing2011, Housing2012)

############# I FAIL AT WRITING LOOPS!!!!! ############
# for (i in 2010:2012) 
# {
#   Housing[[i]]$T208 <- as.numeric(Housing[[i]]$T208)
#   Housing[[i]]$T228.01 <- as.numeric(Housing[[i]]$T228.01)
#   Housing[[i]]$T228.02 <- as.numeric(Housing[[i]]$T228.02)
#   Housing[[i]]$T228.03 <- as.numeric(Housing[[i]]$T228.03)
#   Housing[[i]]$T209 <- as.numeric(Housing[[i]]$T209)
#   Housing[[i]]$T229.01 <- as.numeric(Housing[[i]]$T229.01)
#   Housing[[i]]$T229.02 <- as.numeric(Housing[[i]]$T229.02)
#   Housing[[i]]$T229.03 <- as.numeric(Housing[[i]]$T229.03)
# }

Housing2010$T208 <- as.numeric(Housing2010$T208)
Housing2010$T228.01 <- as.numeric(Housing2010$T228.01)
Housing2010$T228.02 <- as.numeric(Housing2010$T228.02)
Housing2010$T228.03 <- as.numeric(Housing2010$T228.03)
Housing2010$T209 <- as.numeric(Housing2010$T209)
Housing2010$T229.01 <- as.numeric(Housing2010$T229.01)
Housing2010$T229.02 <- as.numeric(Housing2010$T229.02)
Housing2010$T229.03 <- as.numeric(Housing2010$T229.03)

Housing2011$T208 <- as.numeric(Housing2011$T208)
Housing2011$T209 <- as.numeric(Housing2011$T209)
Housing2011$T228.01 <- as.numeric(Housing2011$T228.01)
Housing2011$T228.02 <- as.numeric(Housing2011$T228.02)
Housing2011$T228.03 <- as.numeric(Housing2011$T228.03)
Housing2011$T229.01 <- as.numeric(Housing2011$T229.01)
Housing2011$T229.02 <- as.numeric(Housing2011$T229.02)
Housing2011$T229.03 <- as.numeric(Housing2011$T229.03)

Housing2012$T208 <- as.numeric(Housing2012$T208)
Housing2012$T209 <- as.numeric(Housing2012$T209)
Housing2012$T228.01 <- as.numeric(Housing2012$T228.01)
Housing2012$T228.02 <- as.numeric(Housing2012$T228.02)
Housing2012$T228.03 <- as.numeric(Housing2012$T228.03)
Housing2012$T229.01 <- as.numeric(Housing2012$T229.01)
Housing2012$T229.02 <- as.numeric(Housing2012$T229.02)
Housing2012$T229.03 <- as.numeric(Housing2012$T229.03)

# sum estimates across all census tracks
Housing2010$Total2010 <- rowSums(Housing2010 [,3:10])
Housing2011$Total2011 <- rowSums(Housing2011 [,3:10])
Housing2012$Total2012 <- rowSums(Housing2012 [,3:10])


# Combine the data tables together
HousingData <- cbind(Housing2010[,c(2,11)], Housing2011[,c(2,11)],Housing2012[,c(2,11)])
HousingData <- HousingData[,c(1:2,4,6)]
# # add a year column to the data frame
# y <- seq(from=2010, to= 2012)
# Years <- rep(y, times = 1, length.out = 387, each = 129)
# HousingData$Years <- Years

# Remove 'Estimate;' from row names
HousingData[,1] <- gsub("Estimate; ", "", HousingData[,1])

# write out data to csv file
write.table(HousingData, "HousingData2010-2012.csv", sep=",", col.names= TRUE, row.names = FALSE)




