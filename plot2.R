#read data
currentloc <- getwd()
NEI <- readRDS(file.path(currentloc, "data/summarySCC_PM25.rds"))

#summarise data
library(data.table)
all <- data.table(NEI)
dt <- subset(all, fips == "24510") ##subset data for Baltimore City
setkey(dt, year)
df <- as.data.frame(dt[,list(total=sum(Emissions, na.rm=TRUE)), by=year])

#plot graph and output
png("plot2.png", width=480, height=480)
barplot( 
        (df$total), 
        names.arg=df$year,
        col="plum3",
        ylim=c(0,3500),
        xpd = FALSE,
        beside=TRUE,
        xlab="Year", 
        ylab="PM2.5 Emissions (Tons)", 
        main="Total PM2.5 Emissions In Baltimore City" 
        )
dev.off()
