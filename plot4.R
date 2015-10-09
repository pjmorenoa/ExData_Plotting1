library(dplyr)
library(lubridate)

## Data sources
src <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- "household_power_consumption.txt"

## Check if the data file is downloaded
if (!file %in% dir(".")) 
{
    print("Downloading...")
    download.file(src, destfile = "power_consumption.zip")
    unzip("power_consumption.zip", overwrite=TRUE)
}

## Reading and processing the data
data <- read.csv(file, header = TRUE, sep=";", as.is=TRUE)
data <- tbl_df(data)
data <- data %>%
    filter(Date=="1/2/2007" | Date=="2/2/2007") %>%
    mutate(Date_Time = paste(Date, Time, sep = " ")) %>%
    select(Date_Time, Sub_metering_1, Sub_metering_2, Sub_metering_3, Voltage, 
           Global_active_power, Global_reactive_power) %>%
    mutate(Date_Time = dmy_hms(Date_Time))%>%
    mutate(Global_active_power=as.numeric(Global_active_power)) %>%
    mutate(Global_reactive_power=as.numeric(Global_reactive_power)) %>%
    mutate(Sub_metering_1=as.numeric(Sub_metering_1)) %>%
    mutate(Sub_metering_2=as.numeric(Sub_metering_2)) %>%
    mutate(Sub_metering_3=as.numeric(Sub_metering_3)) 

## Making the plot
png("plot4.png")
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(data, {
    plot(Global_active_power~Date_Time, type="l", 
         ylab = "Global Active Power (kilowatts)", xlab="")
    plot(Voltage~Date_Time, type="l", xlab="datetime", ylab="Voltage")
    plot(Sub_metering_1~Date_Time, type="l", xlab="", 
         ylab = "Energy sub metering")
    lines(Sub_metering_2~Date_Time, col="red")
    lines(Sub_metering_3~Date_Time, col="blue")
    legend("topright", col=c("black","red","blue"), lty=1, lwd=2, 
           legend = c("Sub_metering_1", "Sub_metering_2", 
                      "Sub_metering_3"))
    plot(Global_reactive_power~Date_Time, type="l", 
         xlab="Global_reactive_power", ylab="datetime")
})
dev.off()
