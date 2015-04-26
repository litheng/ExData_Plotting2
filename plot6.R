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
dt <- subset(all, (fips == "06037"|fips == "24510") & NEI$SCC %in% ids)
df <- as.data.frame(dt[,list(total=sum(Emissions, na.rm=TRUE)), by=list(year, fips)])
df$fips[df$fips == "06037"] <- "New York"
df$fips[df$fips == "24510"] <- "Baltimore"

#plot graph and output
library(ggplot2)
png("plot6.png", width=480, height=480)
ggplot(df, aes(factor(year), total, fill=fips)) +
        geom_bar(stat="identity") +
        guides(fill=FALSE)+
        facet_grid(.~fips) + 
        labs(x="Year", y="PM2.5 Emissions (Tons)") + 
        labs(title="Comparison of Motor Vehicles-Related PM2.5 Emissions") +
        theme(plot.title = element_text(vjust=2))
dev.off()
