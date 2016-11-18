\name{uploadTweets}
\alias{uploadTweets}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
uploadTweets(hashtag, previous, now, nb_tweets, logfile)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{hashtag}{
%%     ~~Describe \code{hashtag} here~~
}
  \item{previous}{
%%     ~~Describe \code{previous} here~~
}
  \item{now}{
%%     ~~Describe \code{now} here~~
}
  \item{nb_tweets}{
%%     ~~Describe \code{nb_tweets} here~~
}
  \item{logfile}{
%%     ~~Describe \code{logfile} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (hashtag, previous, now, nb_tweets, logfile) 
{
    cpt <- 1
    writeLog(logfile, "main", paste0("research iteration no ", 
        cpt), TRUE)
    writeLog(logfile, "main", "searching tweets", TRUE)
    tweet_list <- searchTwitter(hashtag, since = as.character(previous), 
        until = as.character(now), n = nb_tweets)
    writeLog(logfile, "main", "deleting retweets", TRUE)
    clean_tweet_list <- strip_retweets(tweet_list, strip_manual = TRUE, 
        strip_mt = TRUE)
    actual_nb_tweets <- length(tweet_list)
    nb_clean <- length(clean_tweet_list)
    writeLog(logfile, "main", paste0(actual_nb_tweets, " were returned, including ", 
        nb_clean, " non-retweets"), TRUE)
    if (actual_nb_tweets < nb_tweets) {
        writeLog(logfile, "main", "uploading users in the database", 
            TRUE)
        insertUserData(clean_tweet_list)
        writeLog(logfile, "main", "uploading tweets in the database", 
            TRUE)
        insertTweetData(clean_tweet_list, hashtag, logfile)
    }
    else {
        while (actual_nb_tweets == nb_tweets) {
            cpt <- cpt + 1
            writeLog(logfile, "main", paste0("research iteration no ", 
                cpt), TRUE)
            maxid <- toString(as.numeric(tweet_list[[nb_tweets]]$id) - 
                1)
            writeLog(logfile, "main", "searching tweets", TRUE)
            tweet_list <- searchTwitter(hashtag, since = as.character(previous), 
                until = as.character(now), maxID = maxid, n = nb_tweets)
            writeLog(logfile, "main", "deleting retweets", TRUE)
            clean_tweet_list <- strip_retweets(tweet_list, strip_manual = TRUE, 
                strip_mt = TRUE)
            actual_nb_tweets <- length(tweet_list)
            nb_clean <- length(clean_tweet_list)
            writeLog(logfile, "main", paste0(actual_nb_tweets, 
                " were returned, including ", nb_clean, " non-retweets"), 
                TRUE)
            writeLog(logfile, "main", "uploading users in the database", 
                TRUE)
            insertUserData(clean_tweet_list)
            writeLog(logfile, "main", "uploading tweets in the database", 
                TRUE)
            insertTweetData(clean_tweet_list, hashtag, logfile)
        }
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
