#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#pass the first row
if [[ $YEAR != "year" ]]
then
  #1.inserting team name
  #1.1 inserting winner team
  #check team name had exitst or not
  WINNER_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")"
  #if team name haven't exist yet
  if [[ -z $WINNER_TEAM ]]
  then
    INSERT_WINNER="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")"
      #if insert succcess
    if [[ $INSERT_WINNER == "INSERT 0 1" ]]
    then
        echo Insert $WINNER successfully!
    else
      echo Insert failed!!!
    fi
  else
    echo $WINNER already exists
  fi
  #1.2 inserting opponent team
  #check if team already exists
  OPPONENT_TEAM="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")"
  #if team name haven't exist
  if [[ -z $OPPONENT_TEAM ]]
  then
    INSERT_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
    if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
    then
      echo Insert $OPPONENT succesfully!
    else
      echo Insert failed!
    fi
  else
    echo "$OPPONENT already exists"
  fi
  #get games data
  #get winner id and opponent id from teams table because foreign key
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  #insert data to games table
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
  then
    echo Data of games have been inserted successfully!!
  else
    echo Data of games have been failed to inserted!!
  fi
fi
done
