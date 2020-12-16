import mysql.connector
from escpos.printer import Usb
import os
import barcode
from barcode.writer import ImageWriter


os.system('clear')

stickerPrinter = Usb(0x1ba0, 0x220a, 0)

while True:
    try:
        orderNumber = input("Please input order number: ")
        if (orderNumber == "exit"):
            break;
        orderNumber = int(orderNumber)
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("UPDATE orderPlaced SET collected  = IF(made = 1, 1 , 0), made  = IF(made = 0, 1 , 1) WHERE orderID = " + str(orderNumber))
        mycursor = mydb.cursor()
        mycursor.execute("SELECT IF(collected = 1, 'Collected' , 'Made') as Output, count(orderLine.extras), IF(orderPlaced.paid,'Paid On App','NEEDS TO PAY'), orderPlaced.orderID, orderPlaced.collection, orderPlaced.amount FROM orderPlaced, orderLine WHERE orderPlaced.orderID = orderLine.orderID AND orderPlaced.orderID = " + str(orderNumber))
        myresult = mycursor.fetchall()
        for x in myresult:
            if (x[0] == "Made"):
                for z in range(1,int(x[1]+1)):
                    stickerPrinter.text(" Order Complete  \n")
                    stickerPrinter.text((int((2-len(str(x[3])))/2)*" ") + str(x[3]) + "\n\n")
                    stickerPrinter.text((int((6-len(str(x[2])))/2)*" ") + str(x[2]) + "\n\n")
                    stickerPrinter.text(" Collection Time  \n")
                    stickerPrinter.text((int((4-len(str(x[3])))/2)*" ") + str(x[4]) + "\n\n")
                    stickerPrinter.text("" + str(z) + " of " + str(int(x[1])) + "\n")
                    #stickerPrinter.barcode("012ABCDabcd", "CODE128", function_type="B")
                    stickerPrinter.barcode('132', 'CODE39', 64, 2, 'OFF', 'True')
                    stickerPrinter.cut()
                    if (z != x[1]):
                        input("Please Tear")
                    else:
                        print("Food Created")
            elif (x[0] == "Collected"):
                print("Order Completed")
    except:
        print("Not recognised")
