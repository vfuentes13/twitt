

# twitt


This repository will be used to share the R code to get data from twitter through twitteR API.

The aim is to provide a tool to automatically download all the tweets during a time period given a hashtag and store them in a postgreSQL database.

The tweets are downloaded along with all the relevant information available throught the API and for further analysis we decide to store separately the hashthags.


## 1) Data model: database_creation_script.sql

At this point, this is a simple data model composed of two tables as descibed below:

# Table Tweet 

field name | field type | field definition
---------- | ---------- | ----------------
pkid | serial | the numeric autoincremented primary key of the table
tweet_id | varchar(30) | the unique tweet id provided by the API
text | text | the actual text written by the user as a tweet
created | timestamp | the datetime the tweet was created
screen_name | text | the user name of the tweet author
retweet_count | integer | the number of times the tweet by retweeted
is_retweet | boolean | a flag indicated whether a tweet is a retweet or not
research_hashtag | text | the hashtag used as an input by the script's user when this tweet was downloaded
insert_time | timestamp | the datetime the tweet was inserted in the database

# Table Hashtag 

field name - field type - field definition

pkid - serial - the numeric autoincremented primary key of the table
tweet_id - varchar(30) - the unique tweet id provided by the API, use this to map to table Tweet 
hashtag - text - the hashtag or one of the hashtag in the tweet text


## 2) _functions.R

All the functions used by the main script, including the following:

deleteQuotes() - format strings to create SQL statements
separateElements() - separate hashtags from a tweet text
prepareTweetQuery() - format the query used to insert data in table Tweet
writeLog() - manage log files for debugging purposes
prepareHashtagQuery() - format the query used to insert data in table Hashtag
insertTweetData() - insert the data in the tables
uploadTweets() - main function that loops until all tweets are downloaded
connectToTwitter() - connect to the API using credentials from a separate file

## 3) loadTweet.R

Main script that calls the functions defined in the file above.

Connects to the API and to the database, defines the tweet search parameters (hashtag and timeframe), closes db connection.


## 4) launcher.ps1

Powershell script used to launch loadTweet.R so that it can be automated.
