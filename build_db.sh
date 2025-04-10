#! /bin/bash

# script to build db and tables according to project requirements
# db will be populated with values when insert_data.sh is run

# postgres connection
PSQL1="psql --username=freecodecamp --dbname=postgres -t --no-align -c"
# worldcup connection
PSQL2="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"

# create worldcup database
echo "$($PSQL1 "CREATE DATABASE worldcup;")"

# create teams table
echo "$($PSQL2 "CREATE TABLE teams(team_id SERIAL PRIMARY KEY, name VARCHAR(50) UNIQUE NOT NULL);")"

# create games table
echo "$($PSQL2 "CREATE TABLE games(game_id SERIAL PRIMARY KEY, year INT NOT NULL, round VARCHAR(15) NOT NULL, winner_goals INT NOT NULL, opponent_goals INT NOT NULL, winner_id INT NOT NULL, opponent_id INT NOT NULL);")"

# add foreign keys winner_id and opponent_id to games table
echo "$($PSQL2 "ALTER TABLE games ADD FOREIGN KEY (winner_id) REFERENCES teams(team_id),  ADD FOREIGN KEY (opponent_id) REFERENCES teams(team_id);")"

# all tests relating to db and table architecture should now pass