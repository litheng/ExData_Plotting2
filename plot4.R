#read data
currentloc <- getwd()
NEI <- readRDS(file.path(currentloc, "data/summarySCC_PM25.rds"))
SCC <- readRDS(file.path(currentloc, "data/Source_Classification_Code.rds"))

#get coal combustion SCC ids
scc.coal <- grep("Coal", SCC$EI.Sector, ignore.case = TRUE)
scc.coal <- SCC[scc.coal, ]
ids <- as.character(scc.coal$SCC)

#summarise data
library(data.table)
all <- data.table(NEI)
dt <- subset(all, NEI$SCC %in% ids) ##subset coal combustion-related sources
df <- as.data.frame(dt[,list(total=sum(Emissions, na.rm=TRUE)), by=year])

#plot graph and output
library(ggplot2)
library(grid)
png("plot4.png", width=480, height=480)
ggplot(df, aes(factor(year), total/10^3)) +
        geom_bar(stat="identity", fill="olivedrab", width=.5) +
        labs(x="Year", y="PM2.5 Emissions (Kilo-Tons)") +
        labs(title="Coal Combustion-Related PM2.5 Emissions In US") +
        theme(plot.title = element_text(vjust=2), plot.margin = unit(c(1, 1, 1, 1), "cm"))
dev.off()
