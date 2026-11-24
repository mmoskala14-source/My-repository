#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
TEAM_WINNER_CHECK=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
TEAM_OPPONENT_CHECK=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
#ADD WINNER
if  [[ -z $TEAM_WINNER_CHECK ]]
then
ADD_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
else
#ADD OPPONENT
if  [[ -z $TEAM_OPPONENT_CHECK ]]
then
ADD_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
fi
fi
 done < <(tail -n +2 games.csv)
#UPDATE TEAM ID
while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#GET WINNER/OPPONENT ID
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#ADD GAME
ADD_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
done < <(tail -n +2 games.csv)