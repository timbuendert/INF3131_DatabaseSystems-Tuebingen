DROP TABLE IF EXISTS tweets;

CREATE TABLE tweets (
  created_at    timestamp,
  tweet_id      bigint,
  lang          text,
  retweet_count integer,
  text          text,
  user_id       bigint
);

\COPY tweets(created_at, tweet_id, lang, retweet_count, text, user_id) FROM 'data/tweets_no-header.csv';

TABLE tweets;

-- Command to execute: psql -d scratch -f Ex2_load-tweets.sql

-- The query could be refined by adding NOT NULL for some of the columns when creating the table, however, in this case this is not necessary as no missing values are present in the data.
-- Similarly, statements such as UNIQUE(tweet_id, user_id) could have been added, but the import of the data works also without them as this constraint is already present in the data.
