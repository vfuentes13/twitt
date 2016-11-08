-- connect to the db
\c twitter

-- drop schema twitt cascade;

create schema twitt;
\encoding UTF8

-- drop table twitt.tuser cascade;
-- truncate table twitt.tuser cascade;


-- drop table twitt.tuser;
create table twitt.tuser
(
	pkid serial primary key,
	user_id varchar(30) unique,
	screen_name text unique,
	created timestamp,
	description text,
	location text,
	lang varchar(4),
	followerCount integer,
	friendsCount integer,
	insert_time timestamp	
);

-- drop table twitt.tweet;
create table twitt.tweet
(
	pkid serial primary key,
	tweet_id varchar(30) unique,
	text text,
	created timestamp,
	screen_name text references twitt.tuser(screen_name),
	retweet_count integer,
	is_retweet boolean,
	research_hashtag text,
	insert_time timestamp	
);

-- drop table twitt.hashtag;
create table twitt.hashtag
(
	pkid serial primary key,
	tweet_id varchar(30) references twitt.tweet(tweet_id),
	hashtag text
);

-- drop table twitt.mention;
create table twitt.mention
(
	pkid serial primary key,
	tweet_id varchar(30) references twitt.tweet(tweet_id),
	mentionning_user_id text references twitt.tuser(user_id),
	mentionned_user text	
);



