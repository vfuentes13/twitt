\name{insertTweetData}
\alias{insertTweetData}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
insertTweetData(tweet_list, research_hashtag, logfile)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{tweet_list}{
%%     ~~Describe \code{tweet_list} here~~
}
  \item{research_hashtag}{
%%     ~~Describe \code{research_hashtag} here~~
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
function (tweet_list, research_hashtag, logfile) 
{
    for (i in seq_along(tweet_list)) {
        tweet_query <- prepareTweetQuery(tweet_list[[i]], research_hashtag)
        dbGetQuery(con, tweet_query)
        hashtag <- separateElements(tweet_list[[i]]$text, "#", 
            logfile)
        for (j in seq_along(hashtag)) {
            hashtag_query <- prepareHashtagQuery(hashtag[j], 
                tweet_list[[i]]$id)
            dbGetQuery(con, hashtag_query)
        }
        atmention <- separateElements(tweet_list[[i]]$text, "@", 
            logfile)
        author <- getUser(tweet_list[[i]]$screenName)$id
        for (k in seq_along(atmention)) {
            at_query <- prepareAtMentionQuery(atmention[k], tweet_list[[i]]$id, 
                author)
            dbGetQuery(con, at_query)
        }
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
