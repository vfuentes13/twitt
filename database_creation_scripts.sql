-- ## db code ##


-- connect to the db
\c twitter

-- set encoding utf8
\encoding UTF8

-- list schema
select nspname from pg_catalog.pg_namespace;

-- create schena
create schema test;



-- drop table
drop table test.tweet;
drop table test.hashtag;

-- test select

select * from test.tweet;

-- test insert

insert into test.tweet (id, text, created, screen_name, retweet_count, is_retweet) 
	values('125','blewg;wvsd','10/02/2015','vince',0,FALSE);

select column_name, data_type from information_schema.columnswhere table_name = 'test.tweet';


---


drop table test.tweet cascade;
-- create table 
drop table test.tweet;
create table test.tweet
(
	pkid serial primary key,
	id varchar(30) unique,
	text text,
	created timestamp,
	screen_name text,
	retweet_count integer,
	is_retweet boolean,
	research_hashtag text,
	insert_time timestamp
	--primary key(pkid)
);

drop table test.hashtag;
create table test.hashtag
(
	pkid serial primary key,
	tweet_id varchar(30) references test.tweet (id),
	hashtag text
	--primary key(pkid)
);





