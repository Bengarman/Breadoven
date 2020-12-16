import mysql.connector
from iZettle.iZettle import Izettle, RequestException
from escpos.printer import Usb
import barcode
from barcode.writer import ImageWriter


    # stickerPrinter = Usb(0x1ba0, 0x220a, 0)
    # stickerPrinter.set("center")

def printInitalOrderTicket(newValue):
    receiptPrinter = Usb(0x04b8, 0x0202, 0)
    receiptPrinter.set("center")

    EAN = barcode.get_barcode_class('code128')

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
    fullname = ean.save('/home/pi/ean13_barcode')
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

    receiptPrinter.close()


def reprintOrderTicket(orderNumber):
    receiptPrinter = Usb(0x04b8, 0x0202, 0)
    receiptPrinter.set("center")

    EAN = barcode.get_barcode_class('code128')

    mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
    mydb.autocommit = True
    mycursor = mydb.cursor()
    mycursor.execute("SELECT `lineID` FROM `orderLine` WHERE `orderID`= " + str(orderNumber))
    myresult = mycursor.fetchall()

    complete = []

    for x in myresult:
        x = x[0]
        mycursor = mydb.cursor()
        mycursor.execute("SELECT orderPlaced.orderID, DATE_FORMAT(orderPlaced.time, '%D %M %Y %T'), orderPlaced.collection, (SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.foodID AND orderLine.lineID = " + str(x) + ") AS baguette, ( SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.snackID AND orderLine.lineID = " + str(x) + ") AS snack, ( SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.drinkID AND orderLine.lineID = " + str(x) + ") AS drink, orderLine.extras, orderLine.sauces, orderPlaced.paid, orderPlaced.amount FROM orderPlaced, orderLine WHERE orderPlaced.orderID = orderLine.orderID AND orderLine.lineID = " + str(x))
        myresult = mycursor.fetchall()
        complete.append(myresult)
        
    receiptPrinter.text("REPRINT ORDER TICKET\n")
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
    fullname = ean.save('/home/pi/ean13_barcode')
    receiptPrinter.image("/home/pi/ean13_barcode.png")
    receiptPrinter.cut()
    mydb.close()
    
    receiptPrinter.close()
    
def printStickerLabel(orderNumber):
    stickerPrinter = Usb(0x1ba0, 0x220a, 0)
    stickerPrinter.set("center")

    mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
    mydb.autocommit = True
    # mycursor = mydb.cursor()
    # mycursor.execute("UPDATE orderPlaced SET collected  = IF(made = 1, 1 , 0), made  = IF(made = 0, 1 , 1) WHERE orderID = " + str(orderNumber))
    mycursor = mydb.cursor()
    mycursor.execute("SELECT IF(collected = 1, 'Collected' , 'Made') as Output, count(orderLine.extras), IF(orderPlaced.paid,'Paid On App','NEEDS TO PAY'), orderPlaced.orderID, orderPlaced.collection, orderPlaced.amount FROM orderPlaced, orderLine WHERE orderPlaced.orderID = orderLine.orderID AND orderPlaced.orderID = " + str(orderNumber))
    myresult = mycursor.fetchall()
    for x in myresult:
        for z in range(1,int(x[1]+1)):
            stickerPrinter.text(" Order Complete  \n")
            stickerPrinter.text(str(x[3]) + "\n\n")
            stickerPrinter.text(str(x[2]) + "\n\n")
            stickerPrinter.text(" Collection Time  \n")
            stickerPrinter.text(str(x[4]) + "\n\n")
            stickerPrinter.text("" + str(z) + " of " + str(int(x[1])) + "\n")
            stickerPrinter.barcode(str(x[3]), 'CODE39', 64, 2, 'OFF', 'True')
            if z != x[1]:
                stickerPrinter.text("\n\n=======================\n\n")
            else:
                stickerPrinter.cut()
    stickerPrinter.close()
