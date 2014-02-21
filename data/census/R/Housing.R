setwd("~/git/MissionHousing/data/census/R")

require(stringr)

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
    names(df.annotations.transposed) <- c("key", "208", "209", "228.01", "228.02", "228.03", "229.01", 
                                          "229.02", "229.03")
    nameOfMerged <- str_sub(string=a, start=5, end=12)
    df.merged <- merge(x= df.metadata, y = df.annotations.transposed, by.x="V1", by.y="key")
    
    # assign them into the workspace
    assign(x = nameOfMerged, value = df.merged)
  }
}
