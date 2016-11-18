\name{prepareAtMentionQuery}
\alias{prepareAtMentionQuery}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
prepareAtMentionQuery(atmention, tweet_id, author)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{atmention}{
%%     ~~Describe \code{atmention} here~~
}
  \item{tweet_id}{
%%     ~~Describe \code{tweet_id} here~~
}
  \item{author}{
%%     ~~Describe \code{author} here~~
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
function (atmention, tweet_id, author) 
{
    noquote_atmention <- deleteQuotes(atmention)
    at_query <- sprintf("insert into twitt.mention (tweet_id, mentionning_user_id, mentionned_user) values ('\%s', '\%s', '\%s');", 
        tweet_id, author, noquote_atmention)
    return(at_query)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
