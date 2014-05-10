hpc <- getDataFrame()

png("plot1.png", width = 504, height = 504, units = "px", bg = "transparent", type="cairo-png")

hist(hpc$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency")

dev.off()
rm(hpc)


getDataFrame <- function() {
    require(sqldf)

    datafile <- "household_power_consumption.txt"
    zipfile  <- "household_power_consumption.zip"

    if (!file.exists(datafile)) {
        unzip(zipfile)
    }
    if (!file.exists(datafile)) {
        stop(paste0("Cannot read data file: ", datafile))
    }

    #setClass("hpcDate")
    #setClass("hpcTime")
    #setAs("character", "hpcDate", function(from) { as.Date(from, format="%d/%m/%Y") })
    #setAs("character", "hpcTime", function(from) { as.Date(from, "%H:%M:%S") })
    #colsClasses<- c("hpcDate", "hpcTime", rep("numeric", 7))
    colsClasses<- c("character", "character", rep("numeric", 7))

    #hpc <- read.table(datafile, sep=";", header=T, na.strings ="?", colClasses=colsClasses, as.is=T)
    query <- "select * from file where Date in ('1/2/2007', '2/2/2007')"
    data <- read.csv.sql(datafile, sql=query, sep=";", header=T, colClasses=colsClasses)
    data$timestamp <- strptime(paste(data$Date, " ", data$Time), "%d/%m/%Y %H:%M:%S")
    data
}
