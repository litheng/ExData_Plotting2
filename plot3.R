#read data
currentloc <- getwd()
NEI <- readRDS(file.path(currentloc, "data/summarySCC_PM25.rds"))

#summarise data
library(data.table)
all <- data.table(NEI)
dt <- subset(all, fips == "24510") ##subset data for Baltimore City
df <- as.data.frame(dt[,list(total=sum(Emissions, na.rm=TRUE)), by=list(year,type)])

#plot graph and output
library(ggplot2)
png("plot3.png", width=600, height=480)
ggplot(df, aes(factor(year), total, fill=type)) +
        geom_bar(stat="identity") +
        guides(fill=FALSE)+
        facet_grid(.~type) + 
        labs(x="Year", y="PM2.5 Emissions (Tons)") + 
        labs(title="Total PM2.5 Emissions In Baltimore City by Source Type")
dev.off()
