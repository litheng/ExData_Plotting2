#read data
currentloc <- getwd()
NEI <- readRDS(file.path(currentloc, "data/summarySCC_PM25.rds"))
SCC <- readRDS(file.path(currentloc, "data/Source_Classification_Code.rds"))

#get motor vehicles SCC ids
scc.vehicle <- grep("Vehicle", SCC$SCC.Level.Two, ignore.case = TRUE)
scc.vehicle <- SCC[scc.vehicle, ]
ids <- as.character(scc.vehicle$SCC)

#summarise data
library(data.table)
all <- data.table(NEI)
dt <- subset(all, fips == "24510" & NEI$SCC %in% ids) ##subset motor vehicle-related sources
df <- as.data.frame(dt[,list(total=sum(Emissions, na.rm=TRUE)), by=year])

#plot graph and output
library(ggplot2)
library(grid)
png("plot5.png", width=480, height=480)
ggplot(df, aes(factor(year), total)) +
        geom_bar(stat="identity", fill="darkslateblue", width=.5) +
        labs(x="Year", y="PM2.5 Emissions (Tons)") +
        labs(title="Motor Vehicles-Related PM2.5 Emissions In Baltimore") +
        theme(plot.title = element_text(vjust=2), plot.margin = unit(c(1, 1, 1, 1), "cm"))
dev.off()
