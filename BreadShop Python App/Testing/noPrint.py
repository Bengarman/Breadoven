import os
from iZettle.iZettle import Izettle, RequestException
import slack
import ssl as ssl_lib
import certifi
import mysql.connector

os.system("clear")

# When a user sends a DM, the event type will be 'message'.
# Here we'll link the message callback to the 'message' event.
@slack.RTMClient.run_on(event="message")
def message(**payload):
    os.system("clear")
    data = payload['data']
    if 'Hello world' in data['text']:
        newValue = int(float(data['text'][12:1000]))
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("SELECT MAX(lineID) FROM `orderLine`")
        myresult = mycursor.fetchall()

        for x in myresult:
            highest = x[0]

        complete = []   

        for x in range(newValue, (highest + 1)):
            mycursor = mydb.cursor()
            mycursor.execute("SELECT orderPlaced.orderID, DATE_FORMAT(orderPlaced.time, '%D %M %Y %T'), orderPlaced.collection, (SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.foodID AND orderLine.lineID = " + str(x) + ") AS baguette, ( SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.snackID AND orderLine.lineID = " + str(x) + ") AS snack, ( SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.drinkID AND orderLine.lineID = " + str(x) + ") AS drink, orderLine.extras, orderLine.sauces, orderPlaced.paid, orderPlaced.amount FROM orderPlaced, orderLine WHERE orderPlaced.orderID = orderLine.orderID AND orderLine.lineID = " + str(x))
            myresult = mycursor.fetchall()
            complete.append(myresult)
            
        print("New Order Received")
        print("Order Number: " + str(complete[0][0][0]) + "\n")
        print("Date: " + str(complete[0][0][1]))
        print("***************************************\n")
        for x in complete:
            print(str(x[0][3]).title() + " Baguette")
            print("(" + str(x[0][6]) + ")")
            print("(" + str(x[0][7]) + ")\n")
            if str(x[0][4]) != "None":
                print(str(x[0][4]))
                print(str(x[0][5]) + "\n\n")  

        mydb.close()
        if str(complete[0][0][8]) == "0":
            client = Izettle(
                client_id='ccfe6b88-67e1-4f6d-94c5-34b91b11a5fa',
                client_secret='IZSEC33534207-7d83-4f70-b64d-8c54d4e21f00',
                user='benj.garman@gmail.com',
                password='Beng0264'
            )
            client.create_product_variant('d62f7bb0-2728-11e6-85b5-dd108c223139',{"name": "Order " + str(complete[0][0][0]) , "barcode": str(complete[0][0][0]), "price": {"amount": str(complete[0][0][9]), "currencyId": "GBP"}})

ssl_context = ssl_lib.create_default_context(cafile=certifi.where())
slack_token = "xoxb-795840878529-856613875153-zMXfzOYTYXrfQTVuevr1LEF5"
rtm_client = slack.RTMClient(token=slack_token, ssl=ssl_context)
rtm_client.start()


