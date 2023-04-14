#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~ OIOIOI SALON ~~~~\n"
SERVICES=$($PSQL "SELECT * FROM services")

SERVICES_MENU(){
echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
do
  echo "$SERVICE_ID) $SERVICE"
done
}


SERVICES_RESPONSE(){
read SERVICE_ID_SELECTED
SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
if [[ ! $SERVICE_ID_SELECTED =~ ^[1-6]+$ ]]
then
  echo I could not find that service. What would you like today?
  SERVICES_MENU
  SERVICES_RESPONSE
  #read SERVICE_ID_SELECTED
  #SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
fi
}


echo -e "Welcome to my salon. What services would you like today?"
SERVICES_MENU
SERVICES_RESPONSE




echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CHECK_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
if [[ -z $CHECK_PHONE ]]
then
  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  echo "What time would you like your$SELECTED_SERVICE, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo "I have put you down for a$SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  ADD_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE') ")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  ADD_SERVICE=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo "What time would you like your$SELECTED_SERVICE,$CUSTOMER_NAME?"
  read SERVICE_TIME
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  ADD_SERVICE=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo "I have put you down for a$SELECTED_SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
fi