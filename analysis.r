library(textcat)
library(dplyr)
library(RPostgreSQL)
library(parallel)
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

######################## Functions ########################

# regroup words that are close in meaning - would need a mapping file
regroupWords <- function(word)
{
	word <-	gsub("mxico", "mexico", word)
	word <-	gsub("repjohnlewis", "johnlewis", word)
	word <-	gsub("johnlewis", "lewis", word)
	word <-	gsub("hillary", "clinton", word)
	word <-	gsub("tweets", "tweet", word)
	word <- gsub("inauguration2017", "inauguration", word)
	word <- gsub("inaugurationtoday", "inauguration", word)
	word <- gsub("trumpinaugural", "inauguration", word)
	word <- gsub("trumpinauguration", "inauguration", word)
	word <- gsub("inaugurationday", "inauguration", word)
	return(word)
}

# clean tweets version - get only >4 lenght words with no special characters
extractWordsUnique <- function(resultSet)
{
	word <- gsub("http[^ ]*", "", resultSet)
	word <- strsplit(word, " ")[[1]]
	word <- gsub("[^a-zA-Z0-9]","",word)
	word <- subset(word, nchar(word)>4)
	word <- tolower(word)
	word <- regroupWords(word)
	return(word)
}

# setting up cluster for parrallel computing
initCluster <- function()
{
	no_cores <- detectCores()-1
	cl <- makeCluster(no_cores)
	clusterExport(cl, list("regroupWords","word", "resultSet", "extractWordsUnique"),envir=environment())
	return(cl)
}

# extract all the unique words and get a raw ranking of first 100 frequencies
getRawRanking <- function(resultSet)
{
	listRes <- parLapply(cl, resultSet, function(x) extractWordsUnique(x))
	nolistRes <- unlist(listRes)
	raw_rk <- head(sort(table(nolistRes), decreasing=TRUE), n=100)
	return(raw_rk)
}

# get clean ranking 
stripStopWords <- function(raw_rk)
{	# stop words in another file?
	stopWords <- c("inauguration", "watch","under","follow","needs","former","those","these","years","never","before","wants","first","being","today","think","again","really","daily","because", "trumps", "could","still","doesn","realdonaldtrump","donaldtrump","donald","trump","about", "going", "latest", "there", "should", "would", "their", "after")
	elim <- c()
	for(i in seq_along(names(raw_rk))){
		if(is.element(names(raw_rk[i]), stopWords)){
			elim <- c(elim, i)
		}
	}
	rk <- raw_rk[-elim]
	return(rk)
}

# create our data frame for word Cloud
createDataFrame <- function(rk)
{
	nrows <- length(rk)
	ncols <- 2
	doc <- data.frame(matrix("", ncol = ncols, nrow = nrows), stringsAsFactors=FALSE)
	for(i in seq_along(rk)){
		doc[i,1] <- names(rk[i])
		doc[i,2] <- rk[[i]]
	}
	return(doc)
}


######################## Main ########################

# db connection
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname = "twitter", host = "localhost", port = 5432, user = "postgres", password = "pwd")

# initalize cluster
cl <- initCluster()


date_ <- "2017-01-21" #Sys.Date()

# retrieve data from our database
query <- paste0("select tweet_id, text, cast(created as date) from twitt.tweet where research_hashtag='#trump' and cast(created as date)= '", date_, "';")
resultSet <- dbGetQuery(con, query)

# run the cleaning in parrallel on the cluster of cores
raw_rk <- getRawRanking(resultSet[,2])

# filter out the hardcoded stop words
rk <- stripStopWords(raw_rk)

# create wordCloud friendly data frame
doc <- createDataFrame(rk)

maxWords <- 50
wordcloud(words = doc$X1[1:maxWords], freq = as.integer(doc$X2[1:maxWords]), colors=brewer.pal(8, "Dark2"))#, main="Title")#paste0("Top ", maxWords, " in #trump tweets on ", date_))

# close the cluster
stopCluster(cl)

# db disconnect
dbDisconnect(con)


