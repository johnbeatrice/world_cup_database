#! /bin/bash

# insert data into games and teams tables

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# ------------------------------------------------------------------------

# delete all contents from all tables in worldcup db to start fresh
echo "$($PSQL "TRUNCATE TABLE teams, games;")"

# csv file
file="games_test.csv"

# populate teams table
team_names_array=()
declare -A assoc_array

# variable to make loop skip csv headers row
first_line="true"

while IFS=',' read -r col1 col2 col3 col4 col5 col6
do
  # skip header line of csv
  if [[ "$first_line" == "true" ]]
  then
    first_line="false"
    continue
  fi

  # associateive arrays require all keys to be unique so assigning team names as keys automaticall filters out duplicate team names
  assoc_array["$col3"]=0
  assoc_array["$col4"]=0

done < "$file"

# assigning associate array keys as array values of team_names_array
team_names_array+=("${!assoc_array[@]}")

# insert team names into teams table
for item in "${team_names_array[@]}";
do
  echo $item
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$item');")"
done


# populate games table

# variable to make loop skip csv headers row
first_line="true"

while IFS=',' read -r col1 col2 col3 col4 col5 col6
do
  # skip header line of csv
  if [[ "$first_line" == "true" ]]
  then
    first_line="false"
    continue
  fi

  # assoc_array=()    ?

# use current associate array, wipe it, then query the games table
# and make the team name the key and the team_id the value

# then in the insert statement for games, use ${assoc_array[France]} to insert
# the france team_id

# what columns do you need to insert into the games table?

done < "$file"
