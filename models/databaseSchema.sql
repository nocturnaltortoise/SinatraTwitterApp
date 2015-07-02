-- if you want to regenerate the database (.sqlite file)
-- and you already have a copy, either delete it and make
-- a new one, or drop all the tables in it before running Rake.

CREATE TABLE searchTerms (
  searchTerm TEXT NOT NULL UNIQUE PRIMARY KEY
);

CREATE TABLE hashtags (
  hashtag TEXT NOT NULL UNIQUE PRIMARY KEY
);

CREATE TABLE loginInfo (
  email TEXT NOT NULL UNIQUE PRIMARY KEY,
  password TEXT NOT NULL
);

CREATE TABLE usersToFollow (
  user TEXT NOT NULL UNIQUE PRIMARY KEY
);

CREATE TABLE followingUsers (
  user TEXT NOT NULL UNIQUE PRIMARY KEY
);

CREATE TABLE previouslyFollowed (
  user TEXT NOT NULL UNIQUE PRIMARY KEY
);