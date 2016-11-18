\name{prepareHashtagQuery}
\alias{prepareHashtagQuery}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
prepareHashtagQuery(hashtag, tweet_id)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{hashtag}{
%%     ~~Describe \code{hashtag} here~~
}
  \item{tweet_id}{
%%     ~~Describe \code{tweet_id} here~~
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
function (hashtag, tweet_id) 
{
    noquote_hash <- deleteQuotes(hashtag)
    hash_query <- sprintf("insert into twitt.hashtag (tweet_id, hashtag) values ('\%s', '\%s');", 
        tweet_id, noquote_hash)
    return(hash_query)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
