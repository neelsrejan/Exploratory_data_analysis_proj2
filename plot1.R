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
average <- rep(NA, 4)
count <- 1
for (year_in in years) {
    average[count] <- mean(NEI[NEI$year == year_in, "Emissions"], na.rm = TRUE)
    count <- count + 1
}

#create average pm2.5 by year df and plot as png
average_pm2.5_by_year <- data.frame(years, average)
names(average_pm2.5_by_year) <- c("Year", "Average_emission")
png(filename = "./plot1.png")
plot(average_pm2.5_by_year$Year, average_pm2.5_by_year$Average_emission, type = "o", ylab = "Average PM2.5 emission (T)", xlab = "Year", main = "Total US PM2.5 per year")
dev.off()
