# twitt

This repository will be used to share the R code to get data from twitter through twitteR API.

We have a postrgresSQL simple relational model with the following tables:

-- Tweet
-- Hashtag
-- Mention
-- User

This database is fed by the loadTweets R script that works as below:

Given a hashtag, research all the tweets in a given time period and store them along with the related hadshtag and users information in the db above.
