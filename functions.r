# ------------------------------------------------------------------ #
# ------------------------------------------------------------------ #
# ------------------------------------------------------------------ #

# delete simple and double quotes
deleteQuotes <- function(textfield)
{
	return(gsub('"', '', gsub("'"," ",textfield)));
}


# loads data into the db
loadTweetData <- function(tweet_list, research_hashtag)
{	
	iter <- seq_along(tweet_list);

	for(i in iter)
	{
		screenName <- iconv(deleteQuotes(tweet_list[[i]]$screenName), to="UTF8");
		text_ <- iconv(deleteQuotes(tweet_list[[i]]$text), to="UTF8");
		tweet <- sprintf(
							"insert into test.tweet 
							(id, text, created, screen_name, retweet_count, is_retweet, research_hashtag, insert_time) 
							values('%s','%s','%s','%s',%s,%s,'%s','%s');", 
							tweet_list[[i]]$id, 
							text_, 
							tweet_list[[i]]$created, 
							screenName, 
							tweet_list[[i]]$retweetCount, 
							tweet_list[[i]]$isRetweet,
							research_hashtag,
							Sys.time()
						)
		dbGetQuery(con,tweet)
		
		hashtag <- separateElements(tweet_list[[i]]$text, "#")
		iter2 <- seq_along(hashtag)
		
		for(j in iter2)
		{
			noquote_hash <- deleteQuotes(hashtag[j])
			hash <- sprintf(
								"insert into test.hashtag (tweet_id, hashtag) 
								values ('%s', '%s');", 
								tweet_list[[i]]$id, 
								noquote_hash
							)
			dbGetQuery(con, hash)
		}
	}
}


# separates hashtags and at mentions to populate associates tables v2
separateElements <- function(tweetText, object)
{
	
	if(object != "@" && object != "#")
	{		
		writeLog(".\\log\\test.log", "separateElements", paste0(object, " is not accepted, only # or @ are accepted"), TRUE)
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


# need to improve file management
writeLog <- function(fileName, functionName, logText, isAppend)
{
	cat(paste(toString(Sys.time()), "--", functionName, "--" , logText), 
	file=fileName, append=isAppend, sep = "\n"
	)
}


# load tweets

uploadTweets <- function(hashtag, previous, now, nb_tweets)
{
	cpt <- 1

	writeLog(".\\log\\test.log", "main", paste0("research iteration no ", cpt), TRUE)
	writeLog(".\\log\\test.log", "main", "searching tweets", TRUE)
	tweet_list <- searchTwitter(hashtag, since=as.character(previous), until=as.character(now), n=nb_tweets)

	writeLog(".\\log\\test.log", "main", "deleting retweets", TRUE)
	clean_tweet_list <- strip_retweets(tweet_list, strip_manual = TRUE, strip_mt = TRUE)

	actual_nb_tweets <- length(tweet_list)
	nb_clean <- length(clean_tweet_list)
	writeLog(".\\log\\test.log", "main", paste0(actual_nb_tweets, " were returned, including ", nb_clean, " non-retweets"), TRUE)

	if(actual_nb_tweets < nb_tweets)
	{
		writeLog(".\\log\\test.log", "main", "uploading tweets in the database", TRUE)
		loadTweetData(clean_tweet_list, hashtag)
	} else
	{
		while(actual_nb_tweets == nb_tweets)
		{
			cpt <- cpt + 1
			
			writeLog(".\\log\\test.log", "main", paste0("research iteration no ", cpt), TRUE)
			maxid <- toString(as.numeric(tweet_list[[1500]]$id)-1)
			writeLog(".\\log\\test.log", "main", "searching tweets", TRUE)
			tweet_list <- searchTwitter(hashtag, since=as.character(previous), until=as.character(now), maxID=maxid, n=nb_tweets)
			writeLog(".\\log\\test.log", "main", "deleting retweets", TRUE)
			clean_tweet_list <- strip_retweets(tweet_list, strip_manual = TRUE, strip_mt = TRUE)
			
			actual_nb_tweets <- length(tweet_list)
			nb_clean <- length(clean_tweet_list)
			writeLog(".\\log\\test.log", "main", paste0(actual_nb_tweets, " were returned, including ", nb_clean, " non-retweets"), TRUE)

			writeLog(".\\log\\test.log", "main", "uploading tweets in the database", TRUE)
			loadTweetData(clean_tweet_list, hashtag)
		}
	}
}



# ------------------------------------------------------------------ #
# ------------------------------------------------------------------ #
# ------------------------------------------------------------------ #

# separates hashtags and at mentions to populate associates tables v1
separateElements_v1 <- function(tweetText, object)
{
	if(object=="#")
	{
		tweetText <- str_extract_all(tweetText, "#\\S+")
		nb <- str_count(tweetText, "#")
	} else if(object=="@")
	{
		tweetText <- str_extract_all(tweetText, "@\\S+")
		nb <- str_count(tweetText, "@")
	} else
	{
		print("separateElements:: error - only # or @ are accepted")
		stop
	}
	
	if(nb==0)
	{
		stop
		#return null;
	}
	
	tweetText <- gsub("  "," ", tweetText)
	if(substring(tweetText,1,1)=="c")
	{
		tweetText <- substring(tweetText,3,nchar(tweetText)-1)		
		tweetText <- str_split_fixed(tweetText, ", ", nb)
		return(tweetText)
	}
	
	return(tweetText)
}


# delete simple quotes
deleteQuotes_v1 <- function(textfield)
{
	return(gsub("'"," ",textfield));
}


separateElements <- function(tweetText, object)
{
	
	if(object != "@" && object != "#")
	{		
		writeLog("test.log", "separateElements", paste0(object, " is not accepted, only # or @ are accepted"), TRUE)
		stop(" ** refer to test.log ** ")
	} else
	{
		pattern <- paste0(object, "[a-zA-Z]{1,}")
		tweetTextExtract <- str_extract_all(tweetText, pattern)
		nb <- str_count(tweetTextExtract, object)
			
		#if(nb==0)
		#{
			#writeLog("test.log", "separateElements", paste0("no occurence of ", object, " in '", tweetText, "'"), TRUE)
			#stop(" ** refer to test.log ** ")		
		
		#} else 
		#{		
			tweetTextExtract <- gsub("  "," ", tweetTextExtract)
			if(substring(tweetTextExtract,1,1)=="c")
			{
				tweetTextExtract <- substring(tweetTextExtract,3,nchar(tweetTextExtract)-1)		
				tweetTextExtract <- str_split_fixed(tweetTextExtract, ", ", nb)
				return(tweetTextExtract)
			}	
			return(tweetTextExtract)
		#}
	}
}







# ------------------------------------------------------------------ #
# ------------------------------------------------------------------ #
# ------------------------------------------------------------------ #

# test calls:
# separateElements("#blablab je suis dans la foret @monvier", "#")
# separateElements("blablab je suis dans la foret monvier", "x")
# separateElements("#blablab je suis dans la foret @monvier", "@")
# separateElements("blablab je suis dans la foret monvier", "@")


# tweet_list <- searchTwitter("#circus",n=2)
# loadTweetData(tweet_list, "#circus")











