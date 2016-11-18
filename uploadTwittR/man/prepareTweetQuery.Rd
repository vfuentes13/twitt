\name{prepareTweetQuery}
\alias{prepareTweetQuery}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
prepareTweetQuery(tweet, research_hashtag)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{tweet}{
%%     ~~Describe \code{tweet} here~~
}
  \item{research_hashtag}{
%%     ~~Describe \code{research_hashtag} here~~
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
function (tweet, research_hashtag) 
{
    screenName <- iconv(deleteQuotes(tweet$screenName), to = "UTF-8")
    text_ <- iconv(deleteQuotes(tweet$text), to = "UTF-8")
    tweet_query <- sprintf("insert into twitt.tweet (tweet_id, text, created, screen_name, retweet_count, is_retweet, research_hashtag, insert_time) values('\%s','\%s','\%s','\%s',\%s,\%s,'\%s','\%s');", 
        tweet$id, text_, tweet$created, screenName, tweet$retweetCount, 
        tweet$isRetweet, research_hashtag, Sys.time())
    return(tweet_query)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
