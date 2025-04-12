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
# delete teams.csv to start fresh
rm teams.csv

# csv file
file="games_test.csv"

# populate teams table
team_names_array=()
declare -A assoc_array

# variable to make loop skip csv headers row
first_line="true"

while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  # skip header line of csv
  if [[ "$first_line" == "true" ]]
  then
    first_line="false"
    continue
  fi

  # associateive arrays require all keys to be unique so assigning team names as keys automaticall filters out duplicate team names
  assoc_array["$winner"]=0
  assoc_array["$opponent"]=0

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

# first clear associative array
assoc_array=()

# put teams table into csv file
echo "$($PSQL "SELECT * FROM teams;")" >> teams.csv

# insert values from teams.csv into associative array with team names as keys
while IFS='|' read -r team_id team_name
do
 assoc_array[$team_name]=$team_id

done < "teams.csv"

# print contents of associative array for confirmation
echo -e "\n -- contents of assoc_array variable --" 
for key in ${!assoc_array[@]};
do
  echo "Key: $key, Value: ${assoc_array[$key]}"
done

# print teams table to compare to printed contents of associative array for validation
echo -e "\n -- Contents of teams table --" 
echo -e "team_id|name" 
echo "$($PSQL "SELECT * FROM teams;")"

# insert values into games table
while IFS=',' read -r year round winner opponent winner_goals opponent_goals
do
  # skip header line of csv
  if [[ "$first_line" == "true" ]]
  then
    first_line="false"
    continue
  fi

  # echo typeof $year

  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES(2018, '$round', '${assoc_array[$winner]}', '${assoc_array[$opponent]}', '$winner_goals', '$opponent_goals');")"

done < "$file"
 # use current associate array, wipe it, then query the games table
# # and make the team name the key and the team_id the value

# # then in the insert statement for games, use ${assoc_array[France]} to insert
# # the france team_id

# # what columns do you need to insert into the games table?