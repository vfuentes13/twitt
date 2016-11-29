## library import and environement setup

library(twitteR)
library(RPostgreSQL)
library(stringi)
library(stringr)


# FUNCTIONS TO BE MOVED IN A PACKAGE
# ------------------------------------------------------------------ #
# ------------------------------------------------------------------ #
# ------------------------------------------------------------------ #

# ---------------------------------- #
# delete simple and double quotes
deleteQuotes <- function(textfield)
{
	return(gsub('"', '', gsub("'"," ",textfield)));
}


# ---------------------------------- #
# writes log to a file
writeLog <- function(fileName, functionName, logText, isAppend)
{
	if(!file.exists(fileName))
	{
		file.create(fileName)
	}
	cat(paste(toString(Sys.time()), "--", functionName, "--" , logText), file=fileName, append=isAppend, sep = "\n")
}

# ---------------------------------- #
# separates hashtags and at mentions to populate associates tables
separateElements <- function(tweetText, object, logfile)
{
	
	if(object != "@" && object != "#")
	{		
				writeLog(logfile, "separateElements", paste0(object, " is not accepted, only # or @ are accepted"), TRUE)
		stop(" ** refer to test.log ** ")
	} else
	{
		pattern <- paste0(object, "[a-zA-Z]{1,}")
		tweetTextExtract <- str_extract_all(tweetText, pattern)
		nb <- str_count(tweetTextExtract, object)	
		tweetTextExtract <- gsub("  "," ", tweetTextExtract)
		if(substring(tweetTextExtract,1,1)=="c")
		{
			tweetTextExtract <- substring(tweetTextExtract,3,nchar(tweetTextExtract)-1)		
			tweetTextExtract <- str_split_fixed(tweetTextExtract, ", ", nb)
			return(tweetTextExtract)
		}	
		return(tweetTextExtract)
	}
}

# ---------------------------------- #
# formats the insert statement to populate the tweet table
prepareTweetQuery <- function(tweet, research_hashtag)
{
	screenName <- iconv(deleteQuotes(tweet$screenName), to="UTF-8");
	text_ <- iconv(deleteQuotes(tweet$text), to="UTF-8");
	tweet_query <- sprintf(
		"insert into twitt.tweet (tweet_id, text, created, screen_name, retweet_count, is_retweet, research_hashtag, insert_time) values('%s','%s','%s','%s',%s,%s,'%s','%s');", 
		tweet$id, 
		text_, 
		tweet$created, 
		screenName, 
		tweet$retweetCount, 
		tweet$isRetweet,
		research_hashtag,
		Sys.time()
	)
	return(tweet_query)
}

# ---------------------------------- #
# formats the insert statement to populate the hashtag table
prepareHashtagQuery <- function(hashtag, tweet_id)
{
	noquote_hash <- deleteQuotes(hashtag)
	hash_query <- sprintf(
		"insert into twitt.hashtag (tweet_id, hashtag) values ('%s', '%s');", 
		tweet_id, 
		noquote_hash
	)
	return(hash_query)
}

# ---------------------------------- #
# formats the insert statement to populate the mention table
prepareAtMentionQuery <- function(atmention, tweet_id, author)
{
	noquote_atmention <- deleteQuotes(atmention)
	at_query <- sprintf(
		"insert into twitt.mention (tweet_id, mentionning_user_id, mentionned_user) values ('%s', '%s', '%s');", 
		tweet_id, 
		author,
		noquote_atmention		
	)
	return(at_query)
}

# ---------------------------------- #
# formats the insert statement to populate the user table
prepareUserQuery <- function(usr)
{
	description_ <- iconv(deleteQuotes(usr$description), to="UTF-8");	
	location_ <- iconv(deleteQuotes(usr$location), to="UTF-8");	
	screenName <- iconv(deleteQuotes(usr$screenName), to="UTF-8");	
	
	user_query <- sprintf(
		"insert into twitt.tuser (user_id, screen_name, created, description, location, lang, followerCount, friendsCount, insert_time) values ('%s', '%s', '%s', '%s', '%s', '%s', %s, %s, '%s');", 
		usr$id, 
		screenName,
		usr$created,
		description_ ,
		location_,
		usr$lang,
		usr$followersCount,
		usr$friendsCount,
		Sys.time()
	)
	return(user_query)
}

# ---------------------------------- #
# loads tweet data into the db
insertTweetData <- function(tweet_list, research_hashtag, logfile)
{	
	
	for(i in seq_along(tweet_list))
	{		
		tweet_query <- prepareTweetQuery(tweet_list[[i]], research_hashtag)		
		dbGetQuery(con,tweet_query)
		
		hashtag <- separateElements(tweet_list[[i]]$text, "#", logfile)		
		for(j in seq_along(hashtag))
		{
			hashtag_query <- prepareHashtagQuery(hashtag[j], tweet_list[[i]]$id)						
			dbGetQuery(con, hashtag_query)
		}		
		
		#atmention <- separateElements(tweet_list[[i]]$text, "@", logfile)
		#author <- getUser(tweet_list[[i]]$screenName)$id
		#for(k in seq_along(atmention))
		#{
		#	at_query <- prepareAtMentionQuery(atmention[k], tweet_list[[i]]$id, author)			
		#	dbGetQuery(con, at_query)
		#}		
	}
}

# ---------------------------------- #
# loads user data into the db
insertUserData <- function(tweet_list)
{	
	for(i in seq_along(tweet_list))
	{
		usr <- getUser(tweet_list[[i]]$screenName)
		user_query <- prepareUserQuery(usr)
		dbGetQuery(con, user_query)		
	}
}

# ---------------------------------- #
# loads data into the db
uploadTweets <- function(hashtag, previous, now, nb_tweets, logfile)
{
	cpt <- 1

	writeLog(logfile, "main", paste0("research iteration no ", cpt), TRUE)
	writeLog(logfile, "main", "searching tweets", TRUE)
	tweet_list <- searchTwitter(hashtag, since=as.character(previous), until=as.character(now), n=nb_tweets)

	writeLog(logfile, "main", "deleting retweets", TRUE)
	clean_tweet_list <- strip_retweets(tweet_list, strip_manual = TRUE, strip_mt = TRUE)

	actual_nb_tweets <- length(tweet_list)
	nb_clean <- length(clean_tweet_list)
	writeLog(logfile, "main", paste0(actual_nb_tweets, " were returned, including ", nb_clean, " non-retweets"), TRUE)


	#writeLog(logfile, "main", "uploading users in the database", TRUE)
	#try(insertUserData(clean_tweet_list))
	

	writeLog(logfile, "main", "uploading tweets in the database", TRUE)
	try(insertTweetData(clean_tweet_list, hashtag, logfile))
	
	while(actual_nb_tweets == nb_tweets)
	{
		cpt <- cpt + 1
		
		writeLog(logfile, "main", paste0("research iteration no ", cpt), TRUE)
		maxid <- toString(as.numeric(tweet_list[[nb_tweets]]$id)-1)
		writeLog(logfile, "main", "searching tweets", TRUE)
		tweet_list <- searchTwitter(hashtag, since=as.character(previous), until=as.character(now), maxID=maxid, n=nb_tweets)
		writeLog(logfile, "main", "deleting retweets", TRUE)
		clean_tweet_list <- strip_retweets(tweet_list, strip_manual = TRUE, strip_mt = TRUE)
		
		actual_nb_tweets <- length(tweet_list)
		nb_clean <- length(clean_tweet_list)
		writeLog(logfile, "main", paste0(actual_nb_tweets, " were returned, including ", nb_clean, " non-retweets"), TRUE)

		#writeLog(logfile, "main", "uploading users in the database", TRUE)
		#try(insertUserData(clean_tweet_list))
		
		writeLog(logfile, "main", "uploading tweets in the database", TRUE)
		try(insertTweetData(clean_tweet_list, hashtag, logfile))
	}
}

# ---------------------------------- #
# given the credentials in a csv format, connects to the Twitter API
connectToTwitter <- function()
{
	cred <- read.table("api_credentials.txt", sep=';')
	api_key <- cred[1,2]
	api_secret <- cred[2,2]
	access_token <- cred[3,2]
	access_token_secret <- cred[4,2]
	setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
}

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
for(i in c(0:20))
{
	previous <- Sys.Date()-(i+1)
	now <- Sys.Date()-i
	writeLog(logfile, "main", "-----------------------------------------", TRUE)
	writeLog(logfile, "main", paste0("timeframe: between ", previous, " and ", now), TRUE)
	uploadTweets(hashtag, previous, now, nb_tweets, logfile)
}


## disconnect from database
dbDisconnect(con)
