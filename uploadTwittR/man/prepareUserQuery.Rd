\name{prepareUserQuery}
\alias{prepareUserQuery}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
prepareUserQuery(usr)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{usr}{
%%     ~~Describe \code{usr} here~~
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
function (usr) 
{
    description_ <- iconv(deleteQuotes(usr$description), to = "UTF-8")
    location_ <- iconv(deleteQuotes(usr$location), to = "UTF-8")
    user_query <- sprintf("insert into twitt.tuser (user_id, screen_name, created, description, location, lang, followerCount, friendsCount, insert_time) values ('\%s', '\%s', '\%s', '\%s', '\%s', '\%s', \%s, \%s, '\%s');", 
        usr$id, usr$screenName, usr$created, description_, location_, 
        usr$lang, usr$followersCount, usr$friendsCount, Sys.time())
    return(user_query)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
