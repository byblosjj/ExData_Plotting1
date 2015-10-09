library(sqldf)

#checking if data directory exists

if(!file.exists("./data")){dir.create("./data")}

#download and extract data files to data/UCI directory
if(!file.exists("./data/household_power_consumption.zip")){
  fileUrl1 = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl1,destfile="./data/household_power_consumption.zip")
  unzip("./data/household_power_consumption.zip", exdir = "./data")
}

#setting the source file
file <- "./data/household_power_consumption.txt"

#defining sql query on file - only two days, handling NAs

sql =  "select
Date
,Time
,case when Global_active_power<>'?' then Global_active_power end as Global_active_power
,case when Global_reactive_power<>'?' then Global_reactive_power end as Global_reactive_power
,case when Voltage<>'?' then Voltage end as Voltage
,case when Global_intensity<>'?' then Global_intensity end as Global_intensity
,case when Sub_metering_1<>'?' then Sub_metering_1 end as Sub_metering_1
,case when Sub_metering_2<>'?' then Sub_metering_2 end as Sub_metering_2
,case when Sub_metering_3<>'?' then Sub_metering_3 end as Sub_metering_3
from file where Date in ( '1/2/2007', '2/2/2007')"

#reading data 
data <- read.csv.sql(file, sep=';', sql)

#closing connection
sqldf()

#datetime parsing
data$Date<- strptime(paste(data$Date, data$Time), format = '%d/%m/%Y %H:%M:%S')

#opening graphics device
png(file = "plot4.png", width = 480, height = 480)

#multiple chart view
par(mfrow = c(2,2))

#chart 1
plot(data$Date, data$Global_active_power, type = "l", xlab="", ylab="Global Active Power (kilowatts)")

#chart 2
plot(data$Date, data$Voltage, xlab = "datetime", ylab = "Voltage", type = "l")

#chart 3
#series 1
plot(data$Date, data$Sub_metering_1, type = "l", xlab="", ylab="Energy sub metering")
#series 2
points(data$Date, data$Sub_metering_2, type = "l", col="Red")
#series 3
points(data$Date, data$Sub_metering_3, type = "l", col="Blue")
#legend
legend("topright", lwd=1, col=c("Black", "Red", "Blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#chart 4
plot(data$Date, data$Global_reactive_power, xlab = "datetime", ylab = "Global_reactive_power", type = "l")

#closing graphics device 
dev.off()
