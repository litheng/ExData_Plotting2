#read data
currentloc <- getwd()
NEI <- readRDS(file.path(currentloc, "data/summarySCC_PM25.rds"))

#summarise data
library(data.table)
dt <- data.table(NEI)
setkey(dt, year)
df <- as.data.frame(dt[,list(total=sum(Emissions, na.rm=TRUE)), by=year])

#plot graph and output
png("plot1.png", width=480, height=480)
barplot(
        (df$total)/10^3,
        names.arg=df$year,
        col = "cornflowerblue",
        ylim = c(0,8000),
        xpd = FALSE,
        beside=TRUE,
        xlab="Year", 
        ylab="PM2.5 Emissions (Kilo-Tons)", 
        main="Total PM2.5 Emissions From All US Sources" 
        )
dev.off()
