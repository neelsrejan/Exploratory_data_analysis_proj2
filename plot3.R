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
types <- c("POINT", "NONPOINT", "ON-ROAD", "NON-ROAD")
average <- rep(NA,4)
average_point <- rep(NA, 4)
average_nonpoint <- rep(NA, 4)
average_on_road <- rep(NA, 4)
average_non_road <- rep(NA, 4)
par(mfrow = c(1,1))
g <- ggplot() + xlab("Year") + ylab("Average Baltimore PM2.5 emission") + ggtitle("Baltimore PM2.5 emission by year and type") + 
scale_color_hue(labels = c("POINT", "ON-ROAD", "NONPOINT", "NON-ROAD")) + labs(color="Type of emission")
for (type_in in types) {
    count <- 1
    for (year_in in years) {
        average[count] <- mean(NEI[NEI$year == year_in & NEI$fips == 24510 & NEI$type == type_in, "Emissions"], na.rm = TRUE)
        count <- count + 1
    }
    average_pm2.5_by_year_baltimore <- data.frame(years, average)
    names(average_pm2.5_by_year_baltimore) <- c("Year", "Average_emission")
    #print(average_pm2.5_by_year_baltimore)
    if (type_in == "POINT") {
        g <- g + geom_line(data = average_pm2.5_by_year_baltimore, aes(x = Year, y = Average_emission, color = "red"))
    } else if (type_in == "NONPOINT") {
        g <- g + geom_line(data = average_pm2.5_by_year_baltimore, aes(x = Year, y = Average_emission, color = "blue"))
    } else if (type_in == "ON-ROAD") {
        g <- g + geom_line(data = average_pm2.5_by_year_baltimore, aes(x = Year, y = Average_emission, color = "green"))
    } else if (type_in == "NON-ROAD") {
        g <- g + geom_line(data = average_pm2.5_by_year_baltimore, aes(x = Year, y = Average_emission, color = "purple"))
    }
    
}
png(filename = "./plot3.png")
print(g)
dev.off()