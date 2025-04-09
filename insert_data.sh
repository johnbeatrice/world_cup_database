#! /bin/bash

# insert data into games and teams tables

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# delete all contents from all tables in worldcup db to start fresh
echo "$($PSQL "TRUNCATE TABLE teams, games;")"
