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

# load data and convert data types of Date, Global_active_power
# create a new column called DateTime
# create filtered data frame containing data between 2007-02-01 and 2007-02-02
library(dplyr)
data <- dplyr::mutate(data, DateTime = as.POSIXct(strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")))
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$Global_active_power <- as.numeric(data$Global_active_power)
filteredData <- dplyr::filter(data, Date >= "2007-02-01" & Date <= "2007-02-02")

# delete output file if exists
if (file.exists("./plot4.png")) {
  unlink("./plot4.png")
}

# output plot to PNG file
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "white")
par(mfrow = c(2, 2))

# plot in row 1, column 1
plot(filteredData$DateTime, filteredData$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")

# plot in row 1, column 2
plot(filteredData$DateTime, filteredData$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

# plot in row 2, column 1
plot(filteredData$DateTime, filteredData$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering", col = "black")
points(filteredData$DateTime, filteredData$Sub_metering_2, type = "l", xlab = "", ylab = "Energy sub metering", col = "red")
points(filteredData$DateTime, filteredData$Sub_metering_3, type = "l", xlab = "", ylab = "Energy sub metering", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# plot in row 2, column 2
plot(filteredData$DateTime, filteredData$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power", ylim = c(0, 0.5))
dev.off()

# cleanup
unlink("household_power_consumption.zip")
unlink("household_power_consumption.txt")