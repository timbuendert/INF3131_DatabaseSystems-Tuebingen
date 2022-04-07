DROP TABLE IF EXISTS users;

CREATE TABLE users (
  followers_count   integer,
  friends_count     integer,
  user_id           bigint,
  lang              text,
  screen_name       text,
  name              text,
  statuses_count    integer
);

\COPY users(followers_count, friends_count, user_id, lang, screen_name, name, statuses_count) FROM 'data/users_no-header.csv';

TABLE users;

-- Command to execute: psql -d scratch -f Ex2_load-users.sql

-- The query could be refined by adding NOT NULL for some of the columns when creating the table, however, in this case this is not necessary as no missing values are present in the data.
-- Similarly, statements such as UNIQUE for user_id amd screen_name could have been added, but the import of the data works also without them as this constraint is already present in the data.