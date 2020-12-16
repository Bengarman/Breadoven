# -*- coding: utf-8 -*-
# Form implementation generated from reading ui file 'orderPageDialog.ui'
#
# Created by: PyQt5 UI code generator 5.14.1
#
# WARNING! All changes made in this file will be lost!
from PyQt5 import QtCore, QtGui, QtWidgets
import getpass
if str(getpass.getuser()) == "root":
    import printerFunction
else:
    import printerFunction2 as printerFunction
import mysql.connector
from functools import partial

orderNumber = 100
class Ui_Dialog(object):
    def initaliseTable(self):
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        complete = []
        mycursor = mydb.cursor()
        mycursor.execute("SELECT `lineID` FROM `orderLine` WHERE `orderID`= " + str(orderNumber))
        myresult = mycursor.fetchall()

        for x in myresult:
            x = x[0]
            mycursor = mydb.cursor()
            mycursor.execute("SELECT orderPlaced.orderID, cast(orderPlaced.time as date) AS Date, cast(orderPlaced.time as time) AS Time, IF(preparing = 0,'Waiting', IF(made = 0, 'Preparing', IF (collected = 0,'Made', 'Collected'))) AS 'Status', orderPlaced.collection, IF(orderPlaced.paid = 1,'Apple Pay', 'On Collection') AS 'Payment Status', (SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.foodID AND orderLine.lineID = " + str(x) + ") AS baguette, ( SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.snackID AND orderLine.lineID = " + str(x) + ") AS snack, ( SELECT itemDB.itemName FROM itemDB, orderLine WHERE itemDB.itemID = orderLine.drinkID AND orderLine.lineID = " + str(x) + ") AS drink, orderLine.extras, orderLine.sauces, orderPlaced.paid, orderPlaced.amount FROM orderPlaced, orderLine WHERE orderPlaced.orderID = orderLine.orderID AND orderLine.lineID = " + str(x))
            myresult = mycursor.fetchall()
            complete.append(myresult)
        
        self.label_2.setText("Date Ordered:         " + str(complete[0][0][1]))
        self.label_3.setText("Time Ordered:         " + str(complete[0][0][2]))
        self.label_6.setText("Order Status:           " + str(complete[0][0][3]))
        self.label_4.setText("Collection Time:       " + str(complete[0][0][4]))
        self.label_5.setText("Payment Status:       " + str(complete[0][0][5]))

        self.tableWidget.clearContents()
        self.tableWidget.setRowCount(0)

        rowcount = 0

        for x in complete:
            self.tableWidget.insertRow(rowcount)
            self.tableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem("1"))
            self.tableWidget.setItem(rowcount , 1, QtWidgets.QTableWidgetItem(str(x[0][6]).title()))
            rowcount = rowcount + 1
            self.tableWidget.insertRow(rowcount)
            self.tableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem(""))
            self.tableWidget.setItem(rowcount , 1, QtWidgets.QTableWidgetItem("     -" + str(x[0][9])))
            rowcount = rowcount + 1
            self.tableWidget.insertRow(rowcount)
            self.tableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem(""))
            self.tableWidget.setItem(rowcount , 1, QtWidgets.QTableWidgetItem("     -" + str(x[0][10])))
            if str(x[0][7]) != "None" or str(x[0][8]) != "None":
                rowcount = rowcount + 1
                self.tableWidget.insertRow(rowcount)
                self.tableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem("1"))
                self.tableWidget.setItem(rowcount , 1, QtWidgets.QTableWidgetItem(str(x[0][7])))
                rowcount = rowcount + 1
                self.tableWidget.insertRow(rowcount)
                self.tableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem("1"))
                self.tableWidget.setItem(rowcount , 1, QtWidgets.QTableWidgetItem(str(x[0][8])))
           
            rowcount = rowcount + 1

    def reprintOrderTicket(self):
        printerFunction.reprintOrderTicket(orderNumber)

    def reprintStickerLabel(self):
        printerFunction.printStickerLabel(orderNumber)
    
    def waitingPressed(self, Dialog):
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("UPDATE orderPlaced SET made = 0, collected = 0, preparing = 0 WHERE orderID = " + str(orderNumber))
        mydb.close()
        Dialog.close()

    def preparingPressed(self, Dialog):
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("UPDATE orderPlaced SET made = 0, collected = 0, preparing = 1 WHERE orderID = " + str(orderNumber))
        mydb.close()
        Dialog.close()

    def madePressed(self, Dialog):
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("UPDATE orderPlaced SET made = 1, collected = 0, preparing = 1 WHERE orderID = " + str(orderNumber))
        mydb.close()
        Dialog.close()

    def completePressed(self, Dialog):
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("UPDATE orderPlaced SET made = 1, collected = 1, preparing = 1 WHERE orderID = " + str(orderNumber))
        mydb.close()
        Dialog.close()

    def setupUi(self, Dialog, _orderNumber):
        global orderNumber
        orderNumber = _orderNumber
        Dialog.setObjectName("Dialog")
        Dialog.resize(752, 404)
        self.tableWidget = QtWidgets.QTableWidget(Dialog)
        self.tableWidget.setGeometry(QtCore.QRect(310, 60, 421, 271))
        self.tableWidget.setSelectionMode(QtWidgets.QAbstractItemView.NoSelection)
        self.tableWidget.setShowGrid(True)
        self.tableWidget.setGridStyle(QtCore.Qt.DotLine)
        self.tableWidget.setObjectName("tableWidget")
        self.tableWidget.setColumnCount(2)
        self.tableWidget.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.tableWidget.setHorizontalHeaderItem(1, item)
        self.tableWidget.horizontalHeader().setStretchLastSection(True)
        self.tableWidget.verticalHeader().setVisible(False)
        self.label_5 = QtWidgets.QLabel(Dialog)
        self.label_5.setGeometry(QtCore.QRect(20, 230, 281, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.label_5.setFont(font)
        self.label_5.setObjectName("label_5")
        self.pushButton_2 = QtWidgets.QPushButton(Dialog)
        self.pushButton_2.setGeometry(QtCore.QRect(20, 310, 281, 23))
        self.pushButton_2.setObjectName("pushButton_2")
        self.pushButton_2.clicked.connect(self.reprintStickerLabel)
        self.pushButton_5 = QtWidgets.QPushButton(Dialog)
        self.pushButton_5.setGeometry(QtCore.QRect(380, 350, 171, 31))
        self.pushButton_5.setStyleSheet("background-color: rgb(240, 255, 66);")
        self.pushButton_5.setObjectName("pushButton_5")
        self.pushButton_5.clicked.connect(partial(self.madePressed, Dialog))
        self.label_6 = QtWidgets.QLabel(Dialog)
        self.label_6.setGeometry(QtCore.QRect(20, 150, 281, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.label_6.setFont(font)
        self.label_6.setObjectName("label_6")
        self.label_3 = QtWidgets.QLabel(Dialog)
        self.label_3.setGeometry(QtCore.QRect(20, 110, 281, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.label_3.setFont(font)
        self.label_3.setObjectName("label_3")
        self.pushButton_4 = QtWidgets.QPushButton(Dialog)
        self.pushButton_4.setGeometry(QtCore.QRect(200, 350, 171, 31))
        self.pushButton_4.setStyleSheet("background-color: rgb(255, 159, 49);")
        self.pushButton_4.setObjectName("pushButton_4")
        self.pushButton_4.clicked.connect(partial(self.preparingPressed, Dialog))
        self.label_2 = QtWidgets.QLabel(Dialog)
        self.label_2.setGeometry(QtCore.QRect(20, 70, 281, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.label_2.setFont(font)
        self.label_2.setObjectName("label_2")
        self.label_4 = QtWidgets.QLabel(Dialog)
        self.label_4.setGeometry(QtCore.QRect(20, 190, 281, 21))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.label_4.setFont(font)
        self.label_4.setObjectName("label_4")
        self.pushButton = QtWidgets.QPushButton(Dialog)
        self.pushButton.setGeometry(QtCore.QRect(20, 270, 281, 23))
        self.pushButton.setObjectName("pushButton")
        self.pushButton.clicked.connect(self.reprintOrderTicket)
        self.pushButton_6 = QtWidgets.QPushButton(Dialog)
        self.pushButton_6.setGeometry(QtCore.QRect(560, 350, 171, 31))
        self.pushButton_6.setStyleSheet("background-color: rgb(64, 255, 51);")
        self.pushButton_6.setObjectName("pushButton_6")
        self.pushButton_6.clicked.connect(partial(self.completePressed, Dialog))
        self.label = QtWidgets.QLabel(Dialog)
        self.label.setGeometry(QtCore.QRect(10, 10, 731, 31))
        font = QtGui.QFont()
        font.setPointSize(12)
        font.setBold(True)
        font.setUnderline(False)
        font.setWeight(75)
        self.label.setFont(font)
        self.label.setAlignment(QtCore.Qt.AlignCenter)
        self.label.setObjectName("label")
        self.pushButton_3 = QtWidgets.QPushButton(Dialog)
        self.pushButton_3.setGeometry(QtCore.QRect(20, 350, 171, 31))
        self.pushButton_3.setStyleSheet("background: rgb(255, 87, 58);")
        self.pushButton_3.setObjectName("pushButton_3")
        self.pushButton_3.clicked.connect(partial(self.waitingPressed, Dialog))
        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)
        self.initaliseTable()
    def retranslateUi(self, Dialog):
        _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "Dialog"))
        item = self.tableWidget.horizontalHeaderItem(0)
        item.setText(_translate("Dialog", "Quantity"))
        item = self.tableWidget.horizontalHeaderItem(1)
        item.setText(_translate("Dialog", "Menu Item"))
        __sortingEnabled = self.tableWidget.isSortingEnabled()
        self.tableWidget.setSortingEnabled(False)
        self.tableWidget.setSortingEnabled(__sortingEnabled)
        self.label_5.setText(_translate("Dialog", "Payment Status:    On Collection"))
        self.pushButton_2.setText(_translate("Dialog", "Reprint Order Sticker "))
        self.pushButton_5.setText(_translate("Dialog", "Made"))
        self.label_6.setText(_translate("Dialog", "Order Status:        Preparing"))
        self.label_3.setText(_translate("Dialog", "Time Ordered:      12:35"))
        self.pushButton_4.setText(_translate("Dialog", "Preparing"))
        self.label_2.setText(_translate("Dialog", "Date Ordered:       23/02/2020"))
        self.label_4.setText(_translate("Dialog", "Collection Time:    13:15"))
        self.pushButton.setText(_translate("Dialog", "Reprint Order Ticket "))
        self.pushButton_6.setText(_translate("Dialog", "Collected"))
        self.label.setText(_translate("Dialog", "Order Number:  " + str(orderNumber)))
        self.pushButton_3.setText(_translate("Dialog", "Waiting"))
# if __name__ == "__main__":
#     import sys
#     app = QtWidgets.QApplication(sys.argv)
#     Dialog = QtWidgets.QDialog()
#     ui = Ui_Dialog()
#     ui.setupUi(Dialog)
#     Dialog.show()
#     sys.exit(app.exec_())
