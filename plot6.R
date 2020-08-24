library(ggplot2)
#Download needed files to working directory
setwd("/Users/neelsrejan/datascience-R/course4/proj2/course4project2")
zip_url_to_download <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
to_unzip <- "./zippedData"
scc_file <- "./Source_Classification_Code.rds"
scc_summary_file <- "./summarySCC_PM25.rds"

#checks if file is already downloaded to wd, if not downloads and upzips files    
if (!file.exists(to_unzip)) {
    download.file(zip_url_to_download, destfile = "./zippedData", method = "curl")
    unzip(to_unzip)
}

#load in data 
NEI <- readRDS(scc_summary_file)
SCC <- readRDS(scc_file)

#get average pm25 per year
years <- c(1999, 2002, 2005, 2008)
zips <- c("24510", "06037")
average <- rep(NA,4)
par(mfrow = c(1,1))
g <- ggplot() + xlab("Year") + ylab("PM2.5 motor vechicle emissions") + 
    ggtitle("Baltimore vs LA PM2.5 motor vehicle emission") + 
    scale_color_hue(labels = c("Los Angeles", "Baltimore")) + labs(color="Locations")
for (zip in zips) {
    count <- 1
    for (year_in in years) {
        average[count] <- mean(NEI[NEI$year == year_in & NEI$type == "ON-ROAD" & NEI$fips == zip, "Emissions"], na.rm = TRUE)
        count <- count + 1
    }
    average_pm2.5_by_year <- data.frame(years, average)
    names(average_pm2.5_by_year) <- c("Year", "Average_emission")
    #print(average_pm2.5_by_year)
    if (zip == "24510") {
        g <- g + geom_line(data = average_pm2.5_by_year, aes(x = Year, y = Average_emission, color = "red"))
    } else if (zip == "06037") {
        g <- g + geom_line(data = average_pm2.5_by_year, aes(x = Year, y = Average_emission, color = "blue"))
    } 
}
png(filename = "./plot6.png")
print(g)
dev.off()