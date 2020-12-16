
from PyQt5 import QtCore, QtGui, QtWidgets
from orderDetails import Ui_Dialog as ver3
import mysql.connector
import paho.mqtt.client as mqtt
from iZettle.iZettle import Izettle, RequestException
import ssl as ssl_lib
import certifi
import time
import concurrent
import mysql.connector
import urllib
from datetime import datetime
import subprocess 
import sys
import threading
from functools import partial

def on_message(self12, client, userdata, msg):
    if "Bread Oven" in str(msg.payload):
        self12.initaliseTable()
        newValue = str(msg.payload).split(':')[1]
        newValue = int(newValue.split("'")[0])
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
            print("izettle")
            client.create_product_variant('d62f7bb0-2728-11e6-85b5-dd108c223139',{"name": "Order " + str(complete[0][0][0]) , "barcode": str(complete[0][0][0]), "price": {"amount": str(complete[0][0][9]), "currencyId": "GBP"}})





class Ui_MainWindow(object):
    
    def tableClicked(self, x, y):
        dialog = QtWidgets.QDialog()
        dialog.ui = ver3()
        dialog.ui.setupUi(dialog, int(self.tableWidget.item(x, 0).text()))
        dialog.exec_()
        dialog.show()
        self.lineEdit.setFocus()

    def initalisePrint(self):
        client = mqtt.Client()
        client.connect("broker.mqttdashboard.com", 1883)
        client.subscribe("newOrderGarmanApps/")


        def subscribing():
            client.on_message = partial(on_message, self)
            client.loop_forever()
        sub=threading.Thread(target=subscribing)
        sub.start()

    def initaliseTable(self):

        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("SELECT orderPlaced.orderID, cast(orderPlaced.time as date) AS Date, cast(orderPlaced.time as time) AS Time, IF(made = 0,'Preparing', IF(collected = 0, 'Made','Complete')) AS 'Status', (SELECT COUNT(orderLine.orderID) FROM orderLine WHERE orderPlaced.orderID = orderLine.orderID) AS 'Items', IF(orderPlaced.paid = 1,'Apple Pay', 'On Collection') AS 'Payment Status', orderPlaced.collection FROM orderPlaced WHERE orderPlaced.paid = 0 OR orderPlaced.made = 0 OR orderPlaced.collected = 0")
        myresult = mycursor.fetchall()
        self.tableWidget.clearContents()
        self.tableWidget.setRowCount(len(myresult))
        for y, x in enumerate(myresult):
            self.tableWidget.setItem(y , 0, QtWidgets.QTableWidgetItem(str(x[0])))
            self.tableWidget.setItem(y , 1, QtWidgets.QTableWidgetItem(str(x[1])))
            self.tableWidget.setItem(y , 2, QtWidgets.QTableWidgetItem(str(x[2])))
            self.tableWidget.setItem(y , 3, QtWidgets.QTableWidgetItem(str(x[3])))
            self.tableWidget.setItem(y , 4, QtWidgets.QTableWidgetItem(str(x[4])))
            self.tableWidget.setItem(y , 5, QtWidgets.QTableWidgetItem(str(x[5])))
            self.tableWidget.setItem(y , 6, QtWidgets.QTableWidgetItem(str(x[6])))
        mydb.close()
        print("initalise")

    def searchOrder(self):
        if self.pushButton.text() == "Search" and self.lineEdit.text() != "":
            mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
            mydb.autocommit = True
            mycursor = mydb.cursor()
            mycursor.execute("SELECT orderPlaced.orderID, cast(orderPlaced.time as date) AS Date, cast(orderPlaced.time as time) AS Time, IF(made = 0,'Preparing', IF(collected = 0, 'Made','Complete')) AS 'Status', (SELECT COUNT(orderLine.orderID) FROM orderLine WHERE orderPlaced.orderID = orderLine.orderID) AS 'Items', IF(orderPlaced.paid = 1,'Apple Pay', 'On Collection') AS 'Payment Status', orderPlaced.collection FROM orderPlaced WHERE orderPlaced.orderID = " + str(self.lineEdit.text()))
            myresult = mycursor.fetchall()
            if len(myresult) == 1:
                dialog = QtWidgets.QDialog()
                dialog.ui = ver3()
                dialog.ui.setupUi(dialog, int(myresult[0][0]))
                dialog.exec_()
                dialog.show()
                self.lineEdit.setText("")
                self.lineEdit.setFocus()
            else:
                self.tableWidget.clearContents()
                self.tableWidget.setRowCount(0)
                for x in myresult:
                    rowPosition = self.tableWidget.rowCount()
                    self.tableWidget.insertRow(rowPosition)
                    self.tableWidget.setItem(rowPosition , 0, QtWidgets.QTableWidgetItem(str(x[0])))
                    self.tableWidget.setItem(rowPosition , 1, QtWidgets.QTableWidgetItem(str(x[1])))
                    self.tableWidget.setItem(rowPosition , 2, QtWidgets.QTableWidgetItem(str(x[2])))
                    self.tableWidget.setItem(rowPosition , 3, QtWidgets.QTableWidgetItem(str(x[3])))
                    self.tableWidget.setItem(rowPosition , 4, QtWidgets.QTableWidgetItem(str(x[4])))
                    self.tableWidget.setItem(rowPosition , 5, QtWidgets.QTableWidgetItem(str(x[5])))
                    self.tableWidget.setItem(rowPosition , 6, QtWidgets.QTableWidgetItem(str(x[6])))
                self.pushButton.setText("Reset")
                self.lineEdit.setText("")
            mydb.close()

            
        else:
            self.initaliseTable()
            self.pushButton.setText("Search")
        self.lineEdit.setFocus()

    def lineEditChanged(self):
        if self.lineEdit.text() != "":
            self.pushButton.setText("Search")
    
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(671, 602)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.gridLayout = QtWidgets.QGridLayout(self.centralwidget)
        self.gridLayout.setObjectName("gridLayout")
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Arial")
        font.setPointSize(11)
        font.setBold(True)
        font.setUnderline(True)
        font.setWeight(75)
        self.label_2.setFont(font)
        self.label_2.setAlignment(QtCore.Qt.AlignCenter)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 1, 0, 1, 2)
        self.label = QtWidgets.QLabel(self.centralwidget)
        font = QtGui.QFont()
        font.setFamily("Arial Black")
        font.setPointSize(14)
        font.setBold(True)
        font.setUnderline(True)
        font.setWeight(75)
        self.label.setFont(font)
        self.label.setAlignment(QtCore.Qt.AlignCenter)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 0, 0, 1, 2)
        self.pushButton = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton.setObjectName("pushButton")
        self.pushButton.clicked.connect(self.searchOrder)
        self.gridLayout.addWidget(self.pushButton, 2, 1, 1, 1)
        self.tableWidget = QtWidgets.QTableWidget(self.centralwidget)
        self.tableWidget.setSizeAdjustPolicy(QtWidgets.QAbstractScrollArea.AdjustToContents)
        self.tableWidget.horizontalHeader().setSectionResizeMode(QtWidgets.QHeaderView.Stretch)
        self.tableWidget.setEditTriggers(QtWidgets.QAbstractItemView.NoEditTriggers)
        self.tableWidget.setSelectionMode(QtWidgets.QAbstractItemView.SingleSelection)
        self.tableWidget.setSelectionBehavior(QtWidgets.QAbstractItemView.SelectRows)
        self.tableWidget.setObjectName("tableWidget")
        self.tableWidget.setColumnCount(7)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(1, item)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(2, item)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(3, item)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(4, item)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(5, item)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(6, item)
        self.tableWidget.horizontalHeader().setDefaultSectionSize(90)
        self.tableWidget.verticalHeader().setVisible(False)
        self.gridLayout.addWidget(self.tableWidget, 3, 0, 1, 2)
        self.lineEdit = QtWidgets.QLineEdit(self.centralwidget)
        self.lineEdit.setObjectName("lineEdit")
        self.lineEdit.textChanged.connect(self.lineEditChanged)
        self.lineEdit.returnPressed.connect(self.searchOrder)
        self.gridLayout.addWidget(self.lineEdit, 2, 0, 1, 1)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 671, 21))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)
        self.tableWidget.cellDoubleClicked.connect(self.tableClicked)
        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)
        self.initaliseTable()
        self.initalisePrint()

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.label_2.setText(_translate("MainWindow", "Orders Placed"))
        self.label.setText(_translate("MainWindow", "Bread Oven"))
        self.pushButton.setText(_translate("MainWindow", "Search"))
        item = self.tableWidget.horizontalHeaderItem(0)
        item.setText(_translate("MainWindow", "Order ID"))
        item = self.tableWidget.horizontalHeaderItem(1)
        item.setText(_translate("MainWindow", "Date Placed"))
        item = self.tableWidget.horizontalHeaderItem(2)
        item.setText(_translate("MainWindow", "Time Placed"))
        item = self.tableWidget.horizontalHeaderItem(3)
        item.setText(_translate("MainWindow", "Order Status"))
        item = self.tableWidget.horizontalHeaderItem(4)
        item.setText(_translate("MainWindow", "Items"))
        item = self.tableWidget.horizontalHeaderItem(5)
        item.setText(_translate("MainWindow", "Payment Status"))
        item = self.tableWidget.horizontalHeaderItem(6)
        item.setText(_translate("MainWindow", "Collection Time"))
        self.lineEdit.setPlaceholderText(_translate("MainWindow", "Find Order Number"))
if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    #MainWindow.showFullScreen()
    MainWindow.show()
    ui.lineEdit.setFocus()
    sys.exit(app.exec_())
