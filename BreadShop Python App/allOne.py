
from iZettle.iZettle import Izettle, RequestException
import slack
import ssl as ssl_lib
import certifi
import time
import asyncio
import concurrent
import mysql.connector
from escpos.printer import Usb
import barcode
from barcode.writer import ImageWriter
import urllib
from datetime import datetime
import subprocess 
import sys

p = subprocess.Popen([sys.executable, 'decent_ui.py'], 
                                stdout=subprocess.PIPE, 
                                stderr=subprocess.STDOUT)

EAN = barcode.get_barcode_class('code128')

receiptPrinter = Usb(0x04b8, 0x0202, 0)
receiptPrinter.set("center")


def messagebox():
    import tkinter
    root = tkinter.Tk()
    root.title("GUI")
    root.geometry("500x20")
    trigger = True

    label = tkinter.Label(text = "Disconnected from Server").pack()

    root.mainloop()
    root.quit()
    print("now")


@slack.RTMClient.run_on(event='message')
async def say_hello(**payload):
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
            
        receiptPrinter.text("New Order Received\n")
        receiptPrinter.text("Order Number: " + str(complete[0][0][0]) + "\n\n")
        receiptPrinter.text("Date: " + str(complete[0][0][1]) + "\n")
        receiptPrinter.text("***************************************\n\n")
        for x in complete:
            receiptPrinter.text(str(x[0][3]).title() + " Baguette\n")
            receiptPrinter.text("(" + str(x[0][6]) + ")\n")
            receiptPrinter.text("(" + str(x[0][7]) + ")\n\n")
            if str(x[0][4]) != "None":
                receiptPrinter.text(str(x[0][4])+ "\n")
                receiptPrinter.text(str(x[0][5]) + "\n\n\n")  

        receiptPrinter.text("\n")
        ean = EAN(str(complete[0][0][0]), writer=ImageWriter())
        fullname = ean.save('ean13_barcode')
        receiptPrinter.image("/home/pi/ean13_barcode.png")
        receiptPrinter.cut()
        mydb.close()
        if str(complete[0][0][8]) == "0":
            client = Izettle(
                client_id='ccfe6b88-67e1-4f6d-94c5-34b91b11a5fa',
                client_secret='IZSEC33534207-7d83-4f70-b64d-8c54d4e21f00',
                user='benj.garman@gmail.com',
                password='Beng0264'
            )
            client.create_product_variant('d62f7bb0-2728-11e6-85b5-dd108c223139',{"name": "Order " + str(complete[0][0][0]) , "barcode": str(complete[0][0][0]), "price": {"amount": str(complete[0][0][9]), "currencyId": "GBP"}})


def sync_loop():
    print("here")


async def slack_main():
    loop = asyncio.get_event_loop()
    ssl_context = ssl_lib.create_default_context(cafile=certifi.where())
    slack_token = "xoxb-795840878529-856613875153-zMXfzOYTYXrfQTVuevr1LEF5"
    rtm_client = slack.RTMClient(token=slack_token, ssl=ssl_context, run_async=True, loop=loop)
    executor = concurrent.futures.ThreadPoolExecutor(max_workers=1)
    await asyncio.gather(
        loop.run_in_executor(executor, sync_loop),
        rtm_client.start()
    )


try:
    asyncio.run(slack_main())
except Exception :
    pass

while True:
    try:
        urllib.request.urlopen("http://google.com")
        try:
            asyncio.run(slack_main())
        except Exception:
            pass
    except Exception as e:
        if "429: Too Many Requests" in str(e):
            try:
                asyncio.run(slack_main())
            except Exception:
                pass
        else:
            print(e)
            messagebox()
            print("HERE")
    



    
