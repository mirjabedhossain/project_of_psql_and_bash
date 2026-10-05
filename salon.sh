#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "

MAIN_MENU(){
if [[ $1 ]]
then
echo "$1"
fi

echo -e "\nWhat service you to from us?"
SERVICES=$($PSQL  "SELECT service_id,name FROM services")
echo "$SERVICES" |
while read SERVICE_ID BAR NAME
do
  echo "$SERVICE_ID) $NAME"
done
read SERVICE_ID_SELECTED
if [[ ! $SERVICE_ID_SELECTED  =~ ^[0-9]+$ ]]
then
MAIN_MENU "Enter a currect id"
fi
SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
if [[ -z $SERVICE_ID ]]
then 
MAIN_MENU 
else
#get user phone
echo -e "Enter your phone number\n"
read CUSTOMER_PHONE
CUSTOMER_INFO=$($PSQL "SELECT * FROM customers WHERE phone = '$CUSTOMER_PHONE'")
#if not found 
if [[ -z $CUSTOMER_INFO ]]
then
#get user information
read CUSTOMER_NAME
CREATE_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
echo -e "\nYour profile has been created successfully."
fi
echo -e "When You want this service? Place enter a time."
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
CREATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$CUSTOMER_ID','$SERVICE_ID','$SERVICE_TIME')")
APPOINTMENT_INFO=$($PSQL "SELECT services.name,customers.name,time FROM services INNER JOIN appointments ON services.service_id = appointments.service_id INNER JOIN customers ON appointments.customer_id = customers.customer_id WHERE phone = '$CUSTOMER_PHONE'")
echo "$APPOINTMENT_INFO" | while read SERVICE_NAME BAR CUSTOMER_NAME BAR TIME
do
echo -e "\nI have put you down for a $SERVICE_NAME at $TIME, $CUSTOMER_NAME."
done
fi
}

MAIN_MENU 