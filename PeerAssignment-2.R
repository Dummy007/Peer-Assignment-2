# library(data.table)
# library(dplyr)
# library(ggplot2)
# 
# 
# Data <- read.csv("repdata-data-StormData.csv", 
#                  sep = ",",
#                  na.strings = "NA",
#                  stringsAsFactors = F,
#                  header = T)
# 
# Data <- as.data.table(Data)
# 
# Data$FATALITIES <- as.numeric(Data$FATALITIES)
# Data$INJURIES <- as.numeric(Data$INJURIES)
# 
# Data[, EVTYPE:= tolower(EVTYPE)]
# 
# 
# Data$PROPDMGEXP[Data$PROPDMGEXP %in% c("","-","?", "NA")] <- 0
# Data$PROPDMGEXP[Data$PROPDMGEXP %in% c("+")] <- 1
# Data$PROPDMGEXP[Data$PROPDMGEXP %in% c("0","1","2","3","4","5","6","7","8","9")] <- 10
# Data$PROPDMGEXP[Data$PROPDMGEXP %in% c("H","h")] <- 100
# Data$PROPDMGEXP[Data$PROPDMGEXP %in% c("K","k")] <- 1000
# Data$PROPDMGEXP[Data$PROPDMGEXP %in% c("M","m")] <- 1000000
# Data$PROPDMGEXP[Data$PROPDMGEXP %in% c("B","b")] <- 1000000000
# Data$PROPDMGEXP <- as.numeric(Data$PROPDMGEXP)
# 
# 
# Data$CROPDMGEXP[Data$CROPDMGEXP %in% c("","-","?","NA")] <- 0
# Data$CROPDMGEXP[Data$CROPDMGEXP %in% c("+")] <- 1
# Data$CROPDMGEXP[Data$CROPDMGEXP %in% c("0","1","2","3","4","5","6","7","8","9")] <- 10
# Data$CROPDMGEXP[Data$CROPDMGEXP %in% c("H","h")] <- 100
# Data$CROPDMGEXP[Data$CROPDMGEXP %in% c("K","k")] <- 1000
# Data$CROPDMGEXP[Data$CROPDMGEXP %in% c("M","m")] <- 1000000
# Data$CROPDMGEXP[Data$CROPDMGEXP %in% c("B","b")] <- 1000000000
# Data$CROPDMGEXP <- as.numeric(Data$CROPDMGEXP)
# 
# Data<- filter(Data, as.POSIXct(Data$BGN_DATE, format="%m/%d/%Y") > as.POSIXct("12/31/1995", format="%m/%d/%Y"))
# Data <- Data%>%select(c(8,23:28))
# Data <- Data[!(grepl("summary",Data$EVTYPE)),]
# Data <- Data%>%filter(
#                       !(FATALITIES > 0.0 & INJURIES > 0.0 & 
#                         PROPDMG > 0.0    & CROPDMG > 0.0)
#                      )
# Data[, POPULATION.HEALTH := FATALITIES + INJURIES]
# Data[, CROP.DAMAGE.COST := CROPDMG * CROPDMGEXP]
# Data[, PROPERTY.DAMAGE.COST:= PROPDMG * PROPDMGEXP]
# Data[, TOTAL.DAMAGE.COST := CROP.DAMAGE.COST + PROPERTY.DAMAGE.COST]
# 
# 
# Data$EVTYPE[grepl("tstm wind",Data$EVTYPE) |
#             grepl("severe thunderstorm",Data$EVTYPE)|
#             grepl("severe thunderstorms",Data$EVTYPE)|
#             grepl("thunderstorm",Data$EVTYPE)|
#             grepl("thunderstorms",Data$EVTYPE)|
#             grepl("thunderstorm winds",Data$EVTYPE)|
#             grepl("thunderstorm wind",Data$EVTYPE)] <- "thunderstorm"
# 
# 
# Data$EVTYPE[grepl("ice", Data$EVTYPE)|
#             grepl("low temperature", Data$EVTYPE)|grepl("cool", Data$EVTYPE)| 
#             grepl("icy road", Data$EVTYPE)|
#             grepl("hypothermia/exposure", Data$EVTYPE)| 
#             grepl("wintry mix", Data$EVTYPE)|
#             grepl("snow", Data$EVTYPE)| 
#             grepl("record low", Data$EVTYPE)|grepl("hypothermia", Data$EVTYPE)|
#             grepl("record cold", Data$EVTYPE)|grepl("record  cold", Data$EVTYPE)|
#             grepl("winter weather/mix", Data$EVTYPE)| 
#             grepl("winter weather mix",Data$EVTYPE)] <- "winter weather"
# 
# Data$EVTYPE[grepl("frost",Data$EVTYPE)| grepl("freeze", Data$EVTYPE)] <- "frost/freeze"
# Data$EVTYPE[grepl("heat", Data$EVTYPE) | grepl("hot", Data$EVTYPE)] <- "heat"
# Data$EVTYPE[grepl("freezing", Data$EVTYPE)] <- "freezing fog"
# Data$EVTYPE[grepl("marine tstm wind", Data$EVTYPE)] <- "marine thunderstorm wind"
# Data$EVTYPE[grepl("hurricane", Data$EVTYPE) | grepl("typhoon", Data$EVTYPE)] <- "hurricane(typhoon)"
# Data$EVTYPE[grepl("tornado", Data$EVTYPE)] <- "tornado"
# Data$EVTYPE[grepl("surf", Data$EVTYPE)] <- "high surf"
# Data$EVTYPE[grepl("cold/wind chill", Data$EVTYPE)] <- "cold/wind chill"
# Data$EVTYPE[grepl("cold wind chill", Data$EVTYPE)] <- "cold/wind chill"
# Data$EVTYPE[grepl("extreme cold wind chill", Data$EVTYPE)] <- "extreme cold/wind chill"
# Data$EVTYPE[grepl("extreme cold/wind chill", Data$EVTYPE)] <- "extreme cold/wind chill"
# Data$EVTYPE[grepl("hail", Data$EVTYPE)] <- "hail"
# Data$EVTYPE[grepl("high winds", Data$EVTYPE)] <-"high wind"
# Data$EVTYPE[grepl("winds", Data$EVTYPE)] <-"high wind"
# Data$EVTYPE[grepl("wind and wave", Data$EVTYPE)] <-"high wind"
# Data$EVTYPE[grepl("wind", Data$EVTYPE)] <-"high wind"
# Data$EVTYPE[grepl("wind damage", Data$EVTYPE)] <-"high wind"
# Data$EVTYPE[grepl("whirl wind damage", Data$EVTYPE)] <-"high wind"
# Data$EVTYPE[grepl("strong wind", Data$EVTYPE)] <-"high wind"
# Data$EVTYPE[grepl("strong winds", Data$EVTYPE)] <-"high wind"
# Data$EVTYPE[grepl("storm surge/tide", Data$EVTYPE)] <-"storm surge"
# Data$EVTYPE[grepl("wild/forest", Data$EVTYPE)] <-"wildfire"
# Data$EVTYPE[grepl("wild", Data$EVTYPE)] <- "wildfire"
# Data$EVTYPE[grepl("fire", Data$EVTYPE)] <- "wildfire"
# Data$EVTYPE[grepl("flood", Data$EVTYPE)| 
#             grepl("hightide", Data$EVTYPE) | 
#             grepl("high tide", Data$EVTYPE)|
#             grepl("urban sml stream fld", Data$EVTYPE)|
#             grepl("urban/sml stream fld", Data$EVTYPE)] <- "flood"
# 
# Data$EVTYPE <- as.factor(Data$EVTYPE)
# 
# 
# 
# ## RESULTS
# 
# 

table1 <- Data[, .(INJURIES = sum(INJURIES, na.rm = T)),
              by = .(EVENT.TYPE = EVTYPE )]%>%arrange(desc(INJURIES))

table1 <- head(table1, n = 10L) ; table1

table2 <- Data[, .(FATALITIES = sum(FATALITIES, na.rm = T)),
              by = .(EVENT.TYPE = EVTYPE )]%>%arrange(desc(FATALITIES))

table2 <- head(table2, n = 10L) ; table2

par(mfrow=c(1,2))
barplot(table1[1:10, INJURIES],
        names.arg=table1[1:10, EVENT.TYPE],
        horiz= T,  
        col="red", 
        xlab="Injuries", 
        main="Top 10 Most Costly Events (Population: Injuries)",
        xlim=c(0,25000),las=1,cex.names=.7, cex.main=0.8, cex.axis=1)

barplot(table2[1:10, FATALITIES],
        names.arg=table2[1:10, EVENT.TYPE],
        horiz= T,  
        col="red", 
        xlab="Fatalities", 
        main="Top 10 Most Costly Events (Population: Fatalities)",
        xlim=c(0,2500),las=1,cex.names=.7, cex.main=0.8, cex.axis=1)



table3 <- Data[, .(CROP.DAMAGE.COST = sum(CROP.DAMAGE.COST, na.rm = T)/10^6),
              by = .(EVENT.TYPE = EVTYPE )]%>%arrange(desc(CROP.DAMAGE.COST))
table3 <- head(table3, n = 10L) ; table3

table4 <- Data[, .(PROPERTY.DAMAGE.COST = sum(PROPERTY.DAMAGE.COST, na.rm = T)/10^6),
              by = .(EVENT.TYPE = EVTYPE )]%>%arrange(desc(PROPERTY.DAMAGE.COST))
table4 <- head(table4, n = 10L) ; table4

par(mfrow=c(1,2))
barplot(table3[1:10,CROP.DAMAGE.COST],
        names.arg=table3[1:10, EVENT.TYPE],
        horiz= T,  
        col="dark blue", 
        xlab="Dollars (x1,000,000)", 
        main="Top 10 Most Costly Events (Economically: Crop Damage)",
        xlim=c(0,20000),las=1,cex.names=.7, cex.main=0.8, cex.axis=1)

barplot(table4[1:10,PROPERTY.DAMAGE.COST],
        names.arg=table4[1:10, EVENT.TYPE],
        horiz= T,  
        col="dark blue", 
        xlab="Dollars (x1,000,000)", 
        main="Top 10 Most Costly Events (Economically: Property Damage)",
        xlim=c(0,200000),las=1,cex.names=.7, cex.main=0.8, cex.axis=1)



 


table5 <- Data[, .(POPULATION.HEALTH = sum(POPULATION.HEALTH, na.rm = T)),
               by = .(EVENT.TYPE = EVTYPE )]%>%arrange(desc(POPULATION.HEALTH))
table5 <- head(table5, n = 10L) ; table5

table6 <- Data[, .(TOTAL.DAMAGE.COST = sum(TOTAL.DAMAGE.COST, na.rm = T)/10^6),
               by = .(EVENT.TYPE = EVTYPE )]%>%arrange(desc(TOTAL.DAMAGE.COST))
table6 <- head(table6, n = 10L) ; table6

par(mfrow = c(1,2))
barplot(table5[1:10, POPULATION.HEALTH],
        names.arg=table5[1:10, EVENT.TYPE],
        horiz= T,  
        col="red", 
        xlab="Injuries and Fatalities", 
        main="Top 10 Most Costly Events (Population: Injuries and Fatalities)",
        xlim=c(0,25000),las=1,cex.names=.7, cex.main=0.8, cex.axis=1)

barplot(table6[1:10,TOTAL.DAMAGE.COST],
        names.arg=table2[1:10, EVENT.TYPE],
        horiz= T,  
        col="dark blue", 
        xlab="Dollars (x1,000,000)", 
        main="Top 10 Most Costly Events (Economically: Crop and Property)",
        xlim=c(0,250000),las=1,cex.names=.7, cex.main=0.8, cex.axis=1)


