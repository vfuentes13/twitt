## library import and environement setup

library(twitteR)
library(RPostgreSQL)
library(stringi)
library(stringr)
library (twitteR)

###################### MAIN ######################
setwd("D:\\Projets\\Twitter")

## twitter API connection
connectToTwitter()

## database connection
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "twitter", host = "localhost", port = 5432, user = "postgres", password = "pwd")

## set research variables
hashtag <- '#trump'
nb_tweets <- 1500
logfile <- paste0(".\\log\\", substr(hashtag,2,nchar(hashtag)) ,".log")

## write some log
writeLog(logfile, "main", "-----------------------------------------", TRUE)
writeLog(logfile, "main", "-----------------------------------------", TRUE)
writeLog(logfile, "main", paste0("research hashtag used: ", hashtag), TRUE)

## run 
for(i in c(0:1))
{
	previous <- Sys.Date()-(i+1)
	now <- Sys.Date()-i
	writeLog(logfile, "main", "-----------------------------------------", TRUE)
	writeLog(logfile, "main", paste0("timeframe: between ", previous, " and ", now), TRUE)
	uploadTweets(hashtag, previous, now, nb_tweets, logfile)
}


## disconnect from database
dbDisconnect(con)
