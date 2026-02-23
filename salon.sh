#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

SERVICES="$($PSQL "SELECT service_id ,name FROM services")"


MAIN_MENU() {
  for SERVICE in $SERVICES;
  do
    NEW_LINE=$( echo $SERVICE | sed 's/|/) /g')
    echo $NEW_LINE 
  done 

  read SERVICE_ID_SELECTED
  
  SERVICE_ID="$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")"
  
  if [[ -z $SERVICE_ID ]]
    then 
      MAIN_MENU
    else 
      echo "What's your phone number?"
      read CUSTOMER_PHONE 
      
      PHONE_NUMBER="$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")"
      if [[ -z $PHONE_NUMBER ]]
        then
          echo "I don't have a record for that phone number, what's your name?"I 
          read CUSTOMER_NAME 
           
          INSERT_CUSTOMER="$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")"
          
          SERVICE_NAME="$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")"

          echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
          read SERVICE_TIME

          CUSTOMER_ID="$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")"
          echo $CUSTOMER_ID 
          # insert appointment 
          INSERT_APPOINTMENT="$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")"
          echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

      fi
  fi 
  

}

MAIN_MENU
