
from PyQt5 import QtCore, QtGui, QtWidgets
from orderDetails import Ui_Dialog as ver3
import mysql.connector
import paho.mqtt.client as mqtt
from iZettle.iZettle import Izettle, RequestException
import time
import threading
from functools import partial
import getpass
if str(getpass.getuser()) == "root":
    import printerFunction
else:
    import printerFunction2 as printerFunction
    #test

def on_message(self12, client, userdata, msg):
    if "Bread Oven" in str(msg.payload):
        self12.initaliseTable()
        newValue = str(msg.payload).split(':')[1]
        print(newValue)
        newValue = int(newValue.split("'")[0])
        printerFunction.printInitalOrderTicket(newValue)



class Ui_MainWindow(object):
    
    def tableClicked(self, x, y):
        dialog = QtWidgets.QDialog()
        dialog.ui = ver3()
        dialog.ui.setupUi(dialog, int(self.tableWidget.item(x, 0).text()))
        dialog.exec_()
        self.initaliseTable()
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
        mycursor.execute("SELECT orderPlaced.orderID, cast(orderPlaced.time as date) AS Date, cast(orderPlaced.time as time) AS Time, IF(preparing = 0,'Waiting', IF(made = 0, 'Preparing', IF (collected = 0,'Made', 'Collected'))) AS 'Status', (SELECT COUNT(orderLine.orderID) FROM orderLine WHERE orderPlaced.orderID = orderLine.orderID) AS 'Items', IF(orderPlaced.paid = 1,'Apple Pay', 'On Collection') AS 'Payment Status', orderPlaced.collection FROM orderPlaced WHERE orderPlaced.collected = 0")
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
            mycursor.execute("SELECT orderPlaced.orderID, cast(orderPlaced.time as date) AS Date, cast(orderPlaced.time as time) AS Time, IF(preparing = 0,'Waiting', IF(made = 0, 'Preparing', IF (collected = 0,'Made', 'Collected'))) AS 'Status', (SELECT COUNT(orderLine.orderID) FROM orderLine WHERE orderPlaced.orderID = orderLine.orderID) AS 'Items', IF(orderPlaced.paid = 1,'Apple Pay', 'On Collection') AS 'Payment Status', orderPlaced.collection FROM orderPlaced WHERE orderPlaced.orderID = " + str(self.lineEdit.text()))
            myresult = mycursor.fetchall()
            if len(myresult) == 1:
                dialog = QtWidgets.QDialog()
                dialog.ui = ver3()
                dialog.ui.setupUi(dialog, int(myresult[0][0]))
                dialog.exec_()
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
        print("here")
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
        print("here")
        self.initaliseTable()
        print("here")
        self.initalisePrint()
        print("here")

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
#    MainWindow.showFullScreen()
    MainWindow.show()
    ui.lineEdit.setFocus()
    sys.exit(app.exec_())
