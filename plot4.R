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

##### PLOTS

plotVoltage <- function() {
    plot(df$timestamp,df$Voltage, type="l", xlab="", ylab="Voltage")
}

plotGlobalActivePow <- function() {
    plot(df$timestamp,df$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
}

plotEnergySubmet <- function() {
    plot(df$timestamp,df$Sub_metering_1, type="l", xlab="", ylab="Energy submetering")
    lines(df$timestamp,df$Sub_metering_2,col="red")
    lines(df$timestamp,df$Sub_metering_3,col="blue")
    
    legend("topright", bty = "n", cex=0.6, pt.cex = 1, col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),
           lty=c(1,1), lwd=c(1,1))
}

plotReactivePow <- function() {
    plot(df$timestamp,df$Global_reactive_power, type="l", xlab="", ylab="Reactive Power")
}


plotGrid <- function() {
    par(mfrow = c(2, 2))
    plotGlobalActivePow()
    plotVoltage()
    plotEnergySubmet()
    plotReactivePow()
    
    dev.copy(png, file="plot4.png", width=480, height=480)
    dev.off()
    
    print("plot4.png saved. script finished.")
}

plotGrid()