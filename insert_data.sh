#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
tail -n +2 games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Insert winner team if it doesn't already exist
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  if [[ -z $WINNER_ID ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES('$WINNER');"
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    echo "Winning team: $WINNER (ID: $WINNER_ID)"
  fi

  # Insert opponent team if it doesn't already exist
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  if [[ -z $OPPONENT_ID ]]
  then
    $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');"
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    echo "Opponent team: $OPPONENT (ID: $OPPONENT_ID)"
  fi

  # Game record
  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);"
  echo "Games: $YEAR - $ROUND ($WINNER vs $OPPONENT, Score: $WINNER_GOALS-$OPPONENT_GOALS)"
done
