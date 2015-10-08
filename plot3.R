# delete input files if they already exist
if (file.exists("household_power_consumption.zip")) {
  unlink("household_power_consumption.zip")
}

if (file.exists("household_power_consumption.txt")) {
  unlink("household_power_consumption.txt")
}

# dowload and unzip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "household_power_consumption.zip", method="curl")
unzip("household_power_consumption.zip", files = c("household_power_consumption.txt"), overwrite = T)
data <- read.table("household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?")
unlink("household_power_consumption.zip")

# load data and convert data types of Date, Global_active_power
# create a new column called DateTime
# create filtered data frame containing data between 2007-02-01 and 2007-02-02
library(dplyr)
data <- dplyr::mutate(data, DateTime = as.POSIXct(strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")))
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$Global_active_power <- as.numeric(data$Global_active_power)
filteredData <- dplyr::filter(data, Date >= "2007-02-01" & Date <= "2007-02-02")

# delete output file if exists
if (file.exists("./plot3.png")) {
  unlink("./plot3.png")
}

# output plot to PNG file
png(filename = "plot3.png", width = 480, height = 480, units = "px", bg = "white")
plot(filteredData$DateTime, filteredData$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black")
points(filteredData$DateTime, filteredData$Sub_metering_2, type = "l", xlab = "", ylab = "Energy sub metering", col = "red")
points(filteredData$DateTime, filteredData$Sub_metering_3, type = "l", xlab = "", ylab = "Energy sub metering", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
