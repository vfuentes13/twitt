## library import and environement setup

library(twitteR)
library(RPostgreSQL)
library(stringi)

setwd("D:\\Projets\\Twitter")

###################### MAIN ######################

## twitter API connection

api_key <- "qlSWmxgjSwDvxyBliWk8tsmyP"
api_secret <- "SnI4SIOU7gs8G2xfL2pR5PPGG7BsiwgwCGEiEtUIAm1RuGz2hR"
access_token <- "788174792331526144-wG0QRZ92q4OPJPjnrQ4nVZR9Y3Flwc0"
access_token_secret <- "d2xJf3az5FBEFkkmxKwygS7AEYKavqGW32G27eRSR3dTf"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

## initialize connection to the database

drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "twitter", host = "localhost", port = 5432, user = "postgres", password = "pwd")

## run main

# test create folder file if not created
# test and create files according to certain rules
# calculate stats at the end of an execution
# work around the rate limit by using several connections
hashtag <- '#isis'
nb_tweets <- 1500
writeLog(".\\log\\test.log", "main", "-----------------------------------------", TRUE)
writeLog(".\\log\\test.log", "main", "-----------------------------------------", TRUE)
writeLog(".\\log\\test.log", "main", paste0("research hashtag used: ", hashtag), TRUE)

for(i in c(0:10))
{
	previous <- Sys.Date()-(i+1)
	now <- Sys.Date()-i
	writeLog(".\\log\\test.log", "main", "-----------------------------------------", TRUE)
	writeLog(".\\log\\test.log", "main", paste0("timeframe: between ", previous, " and ", now), TRUE)
	uploadTweets(hashtag, previous, now, nb_tweets)
}


## disconnect from database
dbDisconnect(con)
