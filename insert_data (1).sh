#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
  ### Insert new teams' names into the table
  CHECK_TABLE_TEAMS=$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")
  if [[ -z $CHECK_TABLE_TEAMS ]]
  then
    INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi
  # Insert the only team that's not in the opponents team
  CHECK_TABLE_W=$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")
  if [[ -z $CHECK_TABLE_W ]]
  then
    INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  fi
  # Find each team's ID
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # Insert data into games' table
  INSERT_ROUND=$($PSQL "INSERT INTO games(round,year,winner_goals,opponent_goals, winner_id, opponent_id) VALUES('$ROUND',$YEAR,$WINNER_GOALS,$OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
  fi
done