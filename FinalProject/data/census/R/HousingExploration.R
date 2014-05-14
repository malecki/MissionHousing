setwd("~/git/MissionHousing/data/census/R")

MissionHousing <- read.csv("HousingData2010-2012.csv", sep=",",stringsAsFactors=FALSE )
head(MissionHousing)

require(ggplot2)
require(lubridate)
# subset table for housing occupancy
Occupancy <- MissionHousing[4:8,]
Occupancy[,1] <- gsub("HOUSING OCCUPANCY - ", "", Occupancy[,1])

# transpose matrix 
Occupancy2 <- t(Occupancy)
Occupancy2 <- as.data.frame(Occupancy2)
colnames(Occupancy2) <- c("Total", "Occupied", "Vacant" , "HomeownerVacancyRate", "RentalVacancyRate")
Occupancy2 <- Occupancy2[-1,]

# Number of total housing over the 3 years

class(Occupancy2)
Years <- c(2010, 2011, 2012)
Occupancy2$Year <- as.factor(Years)
Occupancy2$Vacant <- as.numeric(as.character(Occupancy2$Vacant))
Occupancy2$Total <- as.numeric(as.character(Occupancy2$Total))
Occupancy2$Occupied <- as.numeric(as.character(Occupancy2$Occupied))


ggplot(Occupancy2, aes(x =Year, y= Total)) + geom_point(color = "darkturquoise")
ChangeInUnits <- ts(Occupancy2, start=min(Occupancy2$Year), end=max(Occupancy2$Year))

plot(ChangeInUnits)
require(lattice)
barchart(Total~Year, ylim=c(0,900), data=Occupancy2 )
barchart(Species~Reason,data=Reasonstats,groups=Catergory, 
         scales=list(x=list(rot=90,cex=0.8)))




