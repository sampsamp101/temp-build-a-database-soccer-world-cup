#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year"  ]] 
  then 
    for team in "$winner" "$opponent"
    do
       team_id=$($PSQL "SELECT team_id FROM teams where name='$team'")
        
       if [[ -z $team_id ]]
       then
          $PSQL "INSERT INTO teams(name) VALUES('$team')" > /dev/null
       fi
    done
  fi
done

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != "year" ]]
  then
    winner_id=$($PSQL "Select team_id from teams WHERE name='$winner'")
    opponent_id=$($PSQL "select team_id from teams WHERE name='$opponent'")
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', $winner_id, $opponent_id, '$winner_goals', '$opponent_goals')"
  fi
done