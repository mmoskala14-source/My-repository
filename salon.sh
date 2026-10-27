#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Barber Shop ~~~~~\n"

MAIN_MENU () {

if  [[ $1 ]]
then
  echo -e "\n$1"
fi

  echo -e "\n1) cut\n2) color\n3) perm"

  read SERVICE_ID_SELECTED
  
  case $SERVICE_ID_SELECTED in
  1) NEXT ;;
  2) NEXT ;;
  3) NEXT ;;
  *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac
}

NEXT () {

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

PHONE_CHECK=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone='$PHONE_CHECK'")


if  [[ -z $PHONE_CHECK ]]
then

echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
ADD_CLIENT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER"
read SERVICE_TIME

ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

else

echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER"
read SERVICE_TIME

ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER."

fi

}

MAIN_MENU
