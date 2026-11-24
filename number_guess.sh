#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo Enter your username:

read USERNAME

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
USER_CHECK=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")

if [[ $USERNAME = $USER_CHECK ]];
then
echo  Welcome back, $USER_CHECK! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
else
echo Welcome, $USERNAME! It looks like this is your first time here.
ADD_USER=$($PSQL "INSERT INTO users(username) VALUES ('$USERNAME')")
fi


echo Guess the secret number between 1 and 1000:

GUESS_COUNT=0

while true
do
read GUESS
((GUESS_COUNT++))

if [[ ! $GUESS =~ ^-?[0-9]+$ ]];
then
echo "That is not an integer, guess again:"
elif (( GUESS < SECRET_NUMBER ))
then
echo "It's higher than that, guess again:"
elif (( GUESS > SECRET_NUMBER ))
then
echo "It's lower than that, guess again:"
else
echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
break
fi
done

ADD_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = COALESCE(games_played, 0) + 1 WHERE username='$USERNAME'")

BEST_GAME_CHECK=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")

if [[ -z "$BEST_GAME_CHECK" ]] || (( BEST_GAME_CHECK > GUESS_COUNT ))
then
ADD_BEST_GAME=$($PSQL "UPDATE users SET best_game=$GUESS_COUNT WHERE username='$USERNAME'")
fi


