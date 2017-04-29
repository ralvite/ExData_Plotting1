#import required packages
library(lubridate)

# download and unzip data
file <- "household_power_consumption.txt"
if(!file.exists(file)) {
    temp <- tempfile()
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
    file <- unzip(temp)
    unlink(temp)
} else {
    print("household_power_consumption.txt found in working directory!")
}

EPC <- read.table(file, header=T, sep=";")
EPC$Date <- dmy(EPC$Date)

## subset dataframe between indicated dates 
df <- subset(EPC, Date >= "2007-02-01" & Date <= "2007-02-02")


## cast variable data
df$Global_active_power <- as.numeric(as.character(df$Global_active_power))
df$Global_reactive_power <- as.numeric(as.character(df$Global_reactive_power))
df$Voltage <- as.numeric(as.character(df$Voltage))

df <- transform(df, timestamp=ymd_hms(paste(Date, Time)))


df$Sub_metering_1 <- as.numeric(as.character(df$Sub_metering_1))
df$Sub_metering_2 <- as.numeric(as.character(df$Sub_metering_2))
df$Sub_metering_3 <- as.numeric(as.character(df$Sub_metering_3))

########
plot2 <- function() {
  plot(df$timestamp,df$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
  dev.copy(png, file="plot2.png", width=480, height=480)
  dev.off()
  
  print("plot2.png saved. script finished.")
  
}
plot2()
