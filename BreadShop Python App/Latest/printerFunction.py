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

    mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="fishie")
    mydb.autocommit = True
    mycursor = mydb.cursor()
    mycursor.execute("SELECT id FROM orderLine WHERE orderPlacedID = " + str(newValue))
    myresult = mycursor.fetchall()
    orderlineIDS = []
    for x in myresult:
        orderlineIDS.append(str(x).split("(")[1].split(",")[0])

    complete = []	
    print(orderlineIDS)
    for x in orderlineIDS:
        mycursor = mydb.cursor()
        sql = "SELECT orderPlaced.id, DATE_FORMAT(orderPlaced.orderedTime, '%D %M %Y %T'), orderPlaced.collectionTime, items.itemName, orderLine.quantity, orderPlaced.paid, orderPlaced.comments, modifiers.modifierName FROM orderPlaced, orderLine LEFT JOIN items ON orderLine.itemID = items.id LEFT JOIN orderItemMods ON orderLine.id = orderItemMods.orderLineID LEFT JOIN modifiers ON orderItemMods.modifierID = modifiers.id WHERE orderPlaced.id = orderLine.orderPlacedID AND orderLine.id = " + str(x)
        mycursor.execute(sql)
        myresult = mycursor.fetchall()
        complete.append(myresult)
    
    print(complete)
    receiptPrinter.image("/home/pi/Documents/logo.png")
    receiptPrinter.text("\n\nNew Order Received\n")
    receiptPrinter.text("Order Number: " + str(complete[0][0][0]) + "\n\n")
    receiptPrinter.text("Date: " + str(complete[0][0][1]) + "\n")
    receiptPrinter.text("Collection Time: " + str(complete[0][0][2]) + "\n\n")
    receiptPrinter.text("***************************************\n\n")
    for y in complete:
        receiptPrinter.text(str(y[0][3]).title() + "   X  " + str(y[0][4]) + "\n")
        if str(y[0][7]) != "None":
            for x in y:
                receiptPrinter.text("(" + str(x[7]) + ")\n")

            receiptPrinter.text("Comments: \n")
            receiptPrinter.text(str(x[6])+ "\n\n")
                

    receiptPrinter.text("***************************************\n\n")
    ean = EAN(str(complete[0][0][0]), writer=ImageWriter())
    fullname = ean.save('/home/pi/ean13_barcode')
    receiptPrinter.image("/home/pi/ean13_barcode.png")
    receiptPrinter.cut()
    mydb.close()
    """if str(complete[0][0][8]) == "0":
        client = Izettle(
            client_id='ccfe6b88-67e1-4f6d-94c5-34b91b11a5fa',
            client_secret='IZSEC33534207-7d83-4f70-b64d-8c54d4e21f00',
            user='benj.garman@gmail.com',
            password='Beng0264'
        )
        client.create_product_variant('d62f7bb0-2728-11e6-85b5-dd108c223139',{"name": "Order " + str(complete[0][0][0]) , "barcode": str(complete[0][0][0]), "price": {"amount": str(complete[0][0][9]), "currencyId": "GBP"}})
"""
    receiptPrinter.close()

def reprintOrderTicket(newValue):
    receiptPrinter = Usb(0x04b8, 0x0202, 0)
    receiptPrinter.set("center")

    EAN = barcode.get_barcode_class('code128')

    mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="fishie")
    mydb.autocommit = True
    mycursor = mydb.cursor()
    mycursor.execute("SELECT id FROM orderLine WHERE orderPlacedID = " + str(newValue))
    myresult = mycursor.fetchall()
    orderlineIDS = []
    for x in myresult:
        orderlineIDS.append(str(x).split("(")[1].split(",")[0])

    complete = []	
    print(orderlineIDS)
    for x in orderlineIDS:
        mycursor = mydb.cursor()
        sql = "SELECT orderPlaced.id, DATE_FORMAT(orderPlaced.orderedTime, '%D %M %Y %T'), orderPlaced.collectionTime, items.itemName, orderLine.quantity, orderPlaced.paid, orderPlaced.comments, modifiers.modifierName FROM orderPlaced, orderLine LEFT JOIN items ON orderLine.itemID = items.id LEFT JOIN orderItemMods ON orderLine.id = orderItemMods.orderLineID LEFT JOIN modifiers ON orderItemMods.modifierID = modifiers.id WHERE orderPlaced.id = orderLine.orderPlacedID AND orderLine.id = " + str(x)
        mycursor.execute(sql)
        myresult = mycursor.fetchall()
        complete.append(myresult)
    
    print(complete)
    receiptPrinter.image("/home/pi/Documents/logo.png")
    receiptPrinter.text("\n\nREPRINT ORDER TICKET\n")
    receiptPrinter.text("Order Number: " + str(complete[0][0][0]) + "\n\n")
    receiptPrinter.text("Date: " + str(complete[0][0][1]) + "\n")
    receiptPrinter.text("Collection Time: " + str(complete[0][0][2]) + "\n\n")
    receiptPrinter.text("***************************************\n\n")
    for y in complete:
        receiptPrinter.text(str(y[0][3]).title() + "   X  " + str(y[0][4]) + "\n")
        if str(y[0][7]) != "None":
            for x in y:
                receiptPrinter.text("(" + str(x[7]) + ")\n")

            receiptPrinter.text("Comments: \n")
            receiptPrinter.text(str(x[6])+ "\n\n")
                

    receiptPrinter.text("***************************************\n\n")

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
