# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'MainWindow.ui'
#
# Created by: PyQt5 UI code generator 5.14.1
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets
from functools import partial
import paho.mqtt.client as mqtt
import threading
import mysql.connector
import time

filePath = "/home/pi/Downloads"
#filePath = "C:/Users/bgarman/Downloads"
d = dict([])
class WorkerSignals(QtCore.QObject):
    list_of_dict_signals = QtCore.pyqtSignal(str)
    removeOrder = QtCore.pyqtSignal(int)

class Worker(QtCore.QRunnable):

    def __init__(self):
        super(Worker, self).__init__()
        self.signals = WorkerSignals()
        

    def run(self):
        client = mqtt.Client()
        client.connect("broker.mqttdashboard.com", 1883)
        client.subscribe("newOrderGarmanApps/")
        client.on_message = self.on_message
        client.loop_forever()


    def on_message(self, client, userdata, msg):
        if "Remove" in str(msg.payload):
            print("remove")
            self.signals.removeOrder.emit(int(str(msg.payload).split(':')[1].split("'")[0]))
            
        elif "Bread Oven" in str(msg.payload):
            print("her")
            self.signals.list_of_dict_signals.emit(str(msg.payload))



def onResize(self):
    print("here")

def getKeysByValue(dictOfElements, valueToFind):
    listOfKeys = list()
    listOfItems = dictOfElements.items()
    for item  in listOfItems:
        if item[1] == valueToFind:
            listOfKeys.append(item[0])
    return  listOfKeys

class Ui_MainUI(object):
    

    def ExitScreen(self, MainWindow):
        MainWindow.close()
    
    def initaliseServerRequest(self):
        
        myWorker = Worker()
        myWorker.signals.list_of_dict_signals.connect(self.NewOrder)
        myWorker.signals.removeOrder.connect(self.RemoveItem)
        self.threaderPool.start(myWorker)

    def MaximizeElements(self, MainUI):
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("SELECT orderPlaced.orderID, IF(preparing = 0,'Waiting', IF(made = 0, 'Preparing', IF (collected = 0,'Made', 'Collected'))) AS 'Status' FROM orderPlaced WHERE orderPlaced.collected = 0")
        myresult = mycursor.fetchall()
        
        backgroundWidth = self.OrderPage.width()
        backgroundHeight = self.OrderPage.height()
        
        self.BackgroundLogo.setHidden(False)
        self.BackgroundLogo.setGeometry(QtCore.QRect(0, 0, backgroundWidth, backgroundHeight))

        buttonWidth = 200
        buttonHeight = 50
        buttonSpace = 30

        maxButtonsWidth = 0
        widthSpacers = 0
        maxButtonsHeight = 0
        heightSpacers = 0

        for x in range(1,10):
            if (backgroundWidth - (buttonWidth * x) - (buttonSpace * (x-1))) < 10:
                maxButtonsWidth = x - 1
                if maxButtonsWidth == 1:
                    widthSpacers = (backgroundWidth - buttonWidth) / 2
                    break
                else:
                    widthSpacers = (backgroundWidth - (buttonWidth * (x-1)) - (buttonSpace * (x-2))) / 2
                    break
                        
        
        for x in range(1,20):
            if (backgroundHeight - (buttonHeight * x) - (buttonSpace * (x-1))) < 10:
                maxButtonsHeight = x - 1
                if maxButtonsHeight == 1:
                    heightSpacers = (backgroundHeight - buttonHeight) / 2
                    break
                else:
                    heightSpacers = (backgroundHeight - (buttonHeight * (x-1)) - (buttonSpace * (x-2))) / 2
                    break
        
        
        self.OrdersTable.setColumnCount(maxButtonsWidth)
        self.OrdersTable.setRowCount(maxButtonsHeight)
        d["MaxWidth"] = str(maxButtonsWidth) + ":"
        d["MaxHeight"] = str(maxButtonsHeight) + ":"
        
        for buttonX in range(0, maxButtonsWidth):
            for tempButtonY in range (0, maxButtonsHeight):
                d[str(buttonX) +":" + str(tempButtonY)] = ""
                TempButton = QtWidgets.QPushButton(self.OrdersTable)
                self.OrdersTable.setCellWidget(tempButtonY, buttonX, TempButton)

            temp = int(len(myresult) / maxButtonsWidth)
            if ((len(myresult)) % maxButtonsWidth) > buttonX:
                temp += 1

            for buttonY in range(0, temp):
                TempButton = QtWidgets.QPushButton(self.OrdersTable)
                TempButton.setGeometry(QtCore.QRect(20, 20, buttonWidth, buttonHeight))
                TempButton.setMaximumSize(QtCore.QSize(buttonWidth, buttonHeight))
                TempButton.clicked.connect(partial(self.buttonClick, TempButton))
                TempButton.setStyleSheet("border-radius: 10px; background-color: rgb(90, 156, 255);")
                TempButton.setObjectName("OrderButton" + str(buttonX) +" " + str(buttonY))
                font = QtGui.QFont()
                font.setFamily("KG How Many Times")
                font.setPointSize(16)
                TempButton.setFont(font)
                count = ((buttonY) * (maxButtonsWidth)) + buttonX
                TempButton.setText("Order Number:" + str(myresult[count][0]))
                d[str(buttonX) +":" + str(buttonY)] = str(myresult[count][0])
                self.OrdersTable.setCellWidget(buttonY, buttonX, TempButton)

        d["Highest"] = ""

        for orderKey, orderValue in d.items():
            if orderValue == str(myresult[-1][0]):   
                d["Highest"] = orderKey
        
        self.OrdersTable.setGeometry(QtCore.QRect(widthSpacers, buttonSpace, backgroundWidth - widthSpacers, backgroundHeight - buttonSpace))
        self.BackgroundLogo.setGeometry(QtCore.QRect(0, 0, backgroundWidth, backgroundHeight))

    def RemoveItem(self, orderNumber):
        buttonWidth = 200
        buttonHeight = 50
        tempList =  []
        print(str(orderNumber))
        for orderKey, orderValue in d.items():
            try:
                tempList.append(int(orderValue))
            except Exception:
                pass
        tempList.sort()

        index = tempList.index(orderNumber) + 1
        update = dict([])
        positionPreviously = ""

        for indexVal in range(index, len(tempList)):
            valueToMove = tempList[indexVal]
            positionPreviously = getKeysByValue(d, str(valueToMove))[0]
            positionNew = getKeysByValue(d, str(tempList[indexVal-1]))[0]

            update[str(positionNew)] = str(valueToMove)

        update[str(positionPreviously)] = ""

        for key, value in update.items():
            
            posX = int(key.split(':')[0])
            posY = int(key.split(':')[1])

            TempButton = QtWidgets.QPushButton(self.OrdersTable)
            
            if value != "":
                TempButton.clicked.connect(partial(self.buttonClick, TempButton))
                TempButton.setGeometry(QtCore.QRect(20, 20, buttonWidth, buttonHeight))
                TempButton.setMaximumSize(QtCore.QSize(buttonWidth, buttonHeight))
                TempButton.setStyleSheet("border-radius: 10px; background-color: rgb(90, 156, 255);")
                TempButton.setObjectName("OrderButton" + str(posX) +" " + str(posY))
                font = QtGui.QFont()
                font.setFamily("KG How Many Times")
                font.setPointSize(16)
                TempButton.setFont(font)
                TempButton.setText("Order Numbr:" + str(value))
                d[str(posX) +":" + str(posY)] = str(value)
                d["Highest"] = str(posX) +":" + str(posY)
            else:
                TempButton.setHidden(True)
                TempButton.setEnabled(False)

            self.OrdersTable.setCellWidget(posY, posX, TempButton)
                
            
    def NewOrder(self, payload):
        buttonWidth = 200
        buttonHeight = 50
        location = str(payload).split(':')[1].split("'")[0]
        mydb = mysql.connector.connect(host="62.75.152.102", user="login", passwd="GA2019!?", database="wordpress_b")
        mydb.autocommit = True
        mycursor = mydb.cursor()
        mycursor.execute("SELECT orderPlaced.orderID FROM orderPlaced, orderLine WHERE orderLine.orderID = orderPlaced.orderID AND orderLine.lineID = " + str(location))
        myresult = mycursor.fetchall()
        orderNumber = int(myresult[0][0])
        newHighestX = int(d["Highest"].split(':')[0]) + 1
        newHighestY = int(d["Highest"].split(':')[1])
        d[str(newHighestX) +":" + str(newHighestY)] = ""
        
        
        
        MaxWidth = d["MaxWidth"].split(':')[0]
        if newHighestX > int(MaxWidth) - 1:
            newHighestX = 0
            newHighestY += 1

        TempButton = QtWidgets.QPushButton(self.OrdersTable)
        TempButton.setGeometry(QtCore.QRect(20, 20, buttonWidth, buttonHeight))
        TempButton.setMaximumSize(QtCore.QSize(buttonWidth, buttonHeight))
        TempButton.setStyleSheet("border-radius: 10px; background-color: rgb(90, 156, 255);")
        TempButton.setObjectName("OrderButton" + str(newHighestX) +" " + str(newHighestY))
        font = QtGui.QFont()
        font.setFamily("KG How Many Times")
        font.setPointSize(16)
        TempButton.setFont(font)
        TempButton.setText("Order Numbr:" + str(orderNumber))
        TempButton.clicked.connect(partial(self.buttonClick, TempButton))
        d[str(newHighestX) +":" + str(newHighestY)] = str(orderNumber)
        d["Highest"] = str(newHighestX) +":" + str(newHighestY)
        self.OrdersTable.setCellWidget(newHighestY, newHighestX, TempButton)



    def buttonClick(self, OrderBox):
        orderNumber = OrderBox.text().split(':')[1]
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
        
        self.OrderNumberLabel.setText("ORDER - " + orderNumber)
        self.ReprintStickerButton.setEnabled(True)
        self.ReprintStickerButton.setHidden(False)
        self.ReprintTicketButton.setEnabled(True)
        self.ReprintTicketButton.setHidden(False)
        self.DetailsTitleLabel.setText("DETAILS")
        self.ItemsTitleLabel.setText("ITEMS")
        self.DatePlacedLabel.setText("Date:                     " + str(complete[0][0][0]))
        self.TimePlacedLabel.setText( "Time:                     " + str(complete[0][0][1]))
        self.PaymentMethodLabel.setText("Payment:                " + str(complete[0][0][4]))
        self.TimeCollectionLabel.setText("Collection Time:         " + str(complete[0][0][3]))
        self.StatusLabel.setText("Status:                   " + str(complete[0][0][2]))

        self.ItemsOrderedTableWidget.clearContents()
        self.ItemsOrderedTableWidget.setRowCount(0)

        rowcount = 0

        for x in complete:
            self.ItemsOrderedTableWidget.insertRow(rowcount)
            self.ItemsOrderedTableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem("· " + str(x[0][6]).title()))
            rowcount = rowcount + 1
            self.ItemsOrderedTableWidget.insertRow(rowcount)
            self.ItemsOrderedTableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem("        -" + str(x[0][9])))
            rowcount = rowcount + 1
            self.ItemsOrderedTableWidget.insertRow(rowcount)
            self.ItemsOrderedTableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem("        -" + str(x[0][10])))
            if str(x[0][7]) != "None" or str(x[0][8]) != "None":
                rowcount = rowcount + 1
                self.ItemsOrderedTableWidget.insertRow(rowcount)
                self.ItemsOrderedTableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem("  " + str(x[0][7])))
                rowcount = rowcount + 1
                self.ItemsOrderedTableWidget.insertRow(rowcount)
                self.ItemsOrderedTableWidget.setItem(rowcount , 0, QtWidgets.QTableWidgetItem("  " + str(x[0][8])))
           
            rowcount = rowcount + 1

    def testingme(self, MainUI):
        backgroundWidth = MainUI.width() - 300
        backgroundHeight = MainUI.height() - 300
        print(str(backgroundWidth) + "-" + str(backgroundHeight))
        

    def setupUi(self, MainUI):
        MainUI.setObjectName("MainUI")
        MainUI.resize(1200, 811)
        self.AllWidgets = QtWidgets.QWidget(MainUI)
        self.AllWidgets.setObjectName("AllWidgets")
        self.gridLayout_4 = QtWidgets.QGridLayout(self.AllWidgets)
        self.gridLayout_4.setContentsMargins(0, 0, 0, 0)
        self.gridLayout_4.setSpacing(0)
        self.gridLayout_4.setObjectName("gridLayout_4")
        self.MainUILayout = QtWidgets.QVBoxLayout()
        self.MainUILayout.setSpacing(0)
        self.MainUILayout.setObjectName("MainUILayout")
        self.TopUILayout = QtWidgets.QGridLayout()
        self.TopUILayout.setSpacing(0)
        self.TopUILayout.setObjectName("TopUILayout")
        self.OrderPage = QtWidgets.QFrame(self.AllWidgets)
        self.OrderPage.setMinimumSize(QtCore.QSize(785, 670))
        self.OrderPage.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.OrderPage.setFrameShadow(QtWidgets.QFrame.Raised)
        self.OrderPage.setObjectName("OrderPage")
        self.BackgroundLogo = QtWidgets.QLabel(self.OrderPage)
        self.BackgroundLogo.setGeometry(QtCore.QRect(0, 0, 1000, 1000))
        self.BackgroundLogo.setMinimumSize(QtCore.QSize(0, 0))
        self.BackgroundLogo.setPixmap(QtGui.QPixmap(filePath + "/test-removebg-preview.png"))
        self.BackgroundLogo.setAlignment(QtCore.Qt.AlignCenter)
        self.BackgroundLogo.setObjectName("BackgroundLogo")
        self.BackgroundLogo.setHidden(True)

        self.OrdersTable = QtWidgets.QTableWidget(self.OrderPage)
        #self.OrdersTable.setGeometry(QtCore.QRect(0, 0))
        self.OrdersTable.setObjectName("ordersTable")
        self.OrdersTable.horizontalHeader().setVisible(False)
        self.OrdersTable.verticalHeader().setVisible(False)
        self.OrdersTable.horizontalHeader().setSectionResizeMode(QtWidgets.QHeaderView.Stretch)
        self.OrdersTable.verticalHeader().setSectionResizeMode(QtWidgets.QHeaderView.Stretch)
        self.OrdersTable.setStyleSheet("background-color: rgba(255, 255, 255, 0); border: None;")
        self.OrdersTable.setFocusPolicy(QtCore.Qt.NoFocus)
        self.OrdersTable.setSelectionMode(QtWidgets.QAbstractItemView.NoSelection)
        self.OrdersTable.setShowGrid(False)
        self.OrdersTable.setColumnCount(1)
        self.OrdersTable.setRowCount(1)

        self.TopUILayout.addWidget(self.OrderPage, 0, 0, 1, 1)
        self.OrderDetailsFrame = QtWidgets.QFrame(self.AllWidgets)
        self.OrderDetailsFrame.setMinimumSize(QtCore.QSize(300, 0))
        self.OrderDetailsFrame.setMaximumSize(QtCore.QSize(300, 16777215))
        self.OrderDetailsFrame.setStyleSheet("background-color: rgb(207, 207, 207);")
        self.OrderDetailsFrame.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.OrderDetailsFrame.setFrameShadow(QtWidgets.QFrame.Raised)
        self.OrderDetailsFrame.setObjectName("OrderDetailsFrame")
        self.gridLayout_2 = QtWidgets.QGridLayout(self.OrderDetailsFrame)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.OrderNumberLabel = QtWidgets.QLabel(self.OrderDetailsFrame)
        self.OrderNumberLabel.setStyleSheet("font: 20pt \"KG LET HER GO SOLID\";\n"
"text-decoration: underline;")
        self.OrderNumberLabel.setAlignment(QtCore.Qt.AlignCenter)
        self.OrderNumberLabel.setObjectName("OrderNumberLabel")
        self.gridLayout_2.addWidget(self.OrderNumberLabel, 0, 0, 1, 1)
        spacerItem = QtWidgets.QSpacerItem(60, 60, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Preferred)
        self.gridLayout_2.addItem(spacerItem, 4, 0, 1, 1)
        self.DetailsTitleLabel = QtWidgets.QLabel(self.OrderDetailsFrame)
        self.DetailsTitleLabel.setStyleSheet("font: 14pt \"KG How Many Times\";\n"
"text-decoration: underline;\n"
"")
        self.DetailsTitleLabel.setAlignment(QtCore.Qt.AlignCenter)
        self.DetailsTitleLabel.setObjectName("DetailsTitleLabel")
        self.gridLayout_2.addWidget(self.DetailsTitleLabel, 1, 0, 1, 1)
        self.ReprintTicketButton = QtWidgets.QPushButton(self.OrderDetailsFrame)
        self.ReprintTicketButton.setMinimumSize(QtCore.QSize(0, 40))
        font = QtGui.QFont()
        font.setFamily("KG How Many Times")
        font.setPointSize(14)
        self.ReprintTicketButton.setFont(font)
        self.ReprintTicketButton.setStyleSheet("border-radius: 10px;\n"
"background-color: rgb(132, 134, 144);\n"
"")
        self.ReprintTicketButton.setAutoDefault(True)
        self.ReprintTicketButton.setHidden(True)
        self.ReprintTicketButton.setEnabled(False)
        self.ReprintTicketButton.setObjectName("ReprintTicketButton")
        self.gridLayout_2.addWidget(self.ReprintTicketButton, 10, 0, 1, 1)
        self.ItemsOrderedTableWidget = QtWidgets.QTableWidget(self.OrderDetailsFrame)
        font = QtGui.QFont()
        font.setFamily("KG How Many Times")
        font.setPointSize(14)
        self.ItemsOrderedTableWidget.setFont(font)
        self.ItemsOrderedTableWidget.setStyleSheet("border: none;")
        self.ItemsOrderedTableWidget.setGridStyle(QtCore.Qt.NoPen)
        self.ItemsOrderedTableWidget.setObjectName("ItemsOrderedTableWidget")
        self.ItemsOrderedTableWidget.setColumnCount(1)
        self.ItemsOrderedTableWidget.setRowCount(0)
        item = QtWidgets.QTableWidgetItem()
        self.ItemsOrderedTableWidget.setHorizontalHeaderItem(0, item)
        self.ItemsOrderedTableWidget.horizontalHeader().setVisible(False)
        self.ItemsOrderedTableWidget.horizontalHeader().setDefaultSectionSize(256)
        self.ItemsOrderedTableWidget.verticalHeader().setVisible(False)
        self.ItemsOrderedTableWidget.verticalHeader().setDefaultSectionSize(30)
        self.gridLayout_2.addWidget(self.ItemsOrderedTableWidget, 6, 0, 1, 1)
        spacerItem1 = QtWidgets.QSpacerItem(90, 20, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Preferred)
        self.gridLayout_2.addItem(spacerItem1, 7, 0, 1, 1)
        self.ReprintStickerButton = QtWidgets.QPushButton(self.OrderDetailsFrame)
        self.ReprintStickerButton.setMinimumSize(QtCore.QSize(0, 40))
        self.ReprintStickerButton.setHidden(True)
        self.ReprintStickerButton.setEnabled(False)
        font = QtGui.QFont()
        font.setFamily("KG How Many Times")
        font.setPointSize(14)
        self.ReprintStickerButton.setFont(font)
        self.ReprintStickerButton.setStyleSheet("border-radius: 10px;\n"
"background-color: rgb(132, 134, 144);\n"
"")
        self.ReprintStickerButton.setAutoDefault(True)
        self.ReprintStickerButton.setObjectName("ReprintStickerButton")
        self.ReprintStickerButton.clicked.connect(partial(self.testingme, MainUI))
        self.gridLayout_2.addWidget(self.ReprintStickerButton, 8, 0, 1, 1)
        self.ItemsTitleLabel = QtWidgets.QLabel(self.OrderDetailsFrame)
        self.ItemsTitleLabel.setStyleSheet("font: 14pt \"KG How Many Times\";\n"
"text-decoration: underline;\n"
"")
        self.ItemsTitleLabel.setAlignment(QtCore.Qt.AlignCenter)
        self.ItemsTitleLabel.setObjectName("ItemsTitleLabel")
        self.gridLayout_2.addWidget(self.ItemsTitleLabel, 5, 0, 1, 1)
        self.OrderDetailsInfo = QtWidgets.QSplitter(self.OrderDetailsFrame)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Preferred, QtWidgets.QSizePolicy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.OrderDetailsInfo.sizePolicy().hasHeightForWidth())
        self.OrderDetailsInfo.setSizePolicy(sizePolicy)
        self.OrderDetailsInfo.setOrientation(QtCore.Qt.Vertical)
        self.OrderDetailsInfo.setObjectName("OrderDetailsInfo")
        self.DatePlacedLabel = QtWidgets.QLabel(self.OrderDetailsInfo)
        self.DatePlacedLabel.setStyleSheet("font: 14pt \"KG How Many Times\";")
        self.DatePlacedLabel.setObjectName("DatePlacedLabel")
        self.TimePlacedLabel = QtWidgets.QLabel(self.OrderDetailsInfo)
        self.TimePlacedLabel.setStyleSheet("font: 14pt \"KG How Many Times\";")
        self.TimePlacedLabel.setObjectName("TimePlacedLabel")
        self.PaymentMethodLabel = QtWidgets.QLabel(self.OrderDetailsInfo)
        self.PaymentMethodLabel.setStyleSheet("font: 14pt \"KG How Many Times\";")
        self.PaymentMethodLabel.setObjectName("PaymentMethodLabel")
        self.TimeCollectionLabel = QtWidgets.QLabel(self.OrderDetailsInfo)
        self.TimeCollectionLabel.setStyleSheet("font: 14pt \"KG How Many Times\";")
        self.TimeCollectionLabel.setObjectName("TimeCollectionLabel")
        self.StatusLabel = QtWidgets.QLabel(self.OrderDetailsInfo)
        self.StatusLabel.setStyleSheet("font: 14pt \"KG How Many Times\";")
        self.StatusLabel.setObjectName("StatusLabel")
        self.gridLayout_2.addWidget(self.OrderDetailsInfo, 2, 0, 1, 1)
        self.TopUILayout.addWidget(self.OrderDetailsFrame, 0, 1, 1, 1)
        self.MainUILayout.addLayout(self.TopUILayout)
        self.BottomUILayout = QtWidgets.QFrame(self.AllWidgets)
        self.BottomUILayout.setMaximumSize(QtCore.QSize(16777215, 100))
        self.BottomUILayout.setStyleSheet("background-color: rgb(207, 207, 207);\n"
"border-color: rgb(207, 207, 207);")
        self.BottomUILayout.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.BottomUILayout.setFrameShadow(QtWidgets.QFrame.Raised)
        self.BottomUILayout.setObjectName("BottomUILayout")
        self.gridLayout = QtWidgets.QGridLayout(self.BottomUILayout)
        self.gridLayout.setObjectName("gridLayout")
        self.BottomSpacer = QtWidgets.QSplitter(self.BottomUILayout)
        self.BottomSpacer.setOrientation(QtCore.Qt.Horizontal)
        self.BottomSpacer.setObjectName("BottomSpacer")
        self.TitleLabel = QtWidgets.QLabel(self.BottomSpacer)
        self.TitleLabel.setStyleSheet("font: 20pt \"KG LET HER GO SOLID\";")
        self.TitleLabel.setAlignment(QtCore.Qt.AlignCenter)
        self.TitleLabel.setObjectName("TitleLabel")
        self.MenuBar = QtWidgets.QSplitter(self.BottomSpacer)
        self.MenuBar.setMinimumSize(QtCore.QSize(290, 0))
        self.MenuBar.setMaximumSize(QtCore.QSize(214, 31))
        self.MenuBar.setOrientation(QtCore.Qt.Horizontal)
        self.MenuBar.setChildrenCollapsible(True)
        self.MenuBar.setObjectName("MenuBar")
        self.MenuSplitter5 = QtWidgets.QFrame(self.MenuBar)
        self.MenuSplitter5.setMaximumSize(QtCore.QSize(1, 50))
        self.MenuSplitter5.setStyleSheet("background-color: rgb(141, 141, 141);")
        self.MenuSplitter5.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.MenuSplitter5.setFrameShadow(QtWidgets.QFrame.Raised)
        self.MenuSplitter5.setObjectName("MenuSplitter5")
        self.printersConnected = QtWidgets.QPushButton(self.MenuBar)
        self.printersConnected.setMaximumSize(QtCore.QSize(31, 31))
        self.printersConnected.setText("")
        self.printersConnected.setIcon(QtGui.QIcon(filePath + "/icons8-label-printer-96.png"))
        self.printersConnected.setStyleSheet("background-color: rgba(207, 207, 207, 0); border: none;")
        self.printersConnected.setIconSize(QtCore.QSize(31, 31))
        self.printersConnected.setObjectName("printersConnected")
        self.MenuSplitter4 = QtWidgets.QFrame(self.MenuBar)
        self.MenuSplitter4.setMaximumSize(QtCore.QSize(1, 50))
        self.MenuSplitter4.setStyleSheet("background-color: rgb(141, 141, 141);")
        self.MenuSplitter4.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.MenuSplitter4.setFrameShadow(QtWidgets.QFrame.Raised)
        self.MenuSplitter4.setObjectName("MenuSplitter4")
        self.managerPortalButton = QtWidgets.QPushButton(self.MenuBar)
        self.managerPortalButton.setMaximumSize(QtCore.QSize(31, 31))
        self.managerPortalButton.setText("")
        self.managerPortalButton.setIcon(QtGui.QIcon(filePath + "/icons8-coins-128.png"))
        self.managerPortalButton.setStyleSheet("background-color: rgba(207, 207, 207, 0); border: none;")
        self.managerPortalButton.setIconSize(QtCore.QSize(31, 31))
        self.managerPortalButton.setObjectName("managerPortalButton")
        self.MenuSplitter3 = QtWidgets.QFrame(self.MenuBar)
        self.MenuSplitter3.setMaximumSize(QtCore.QSize(1, 50))
        self.MenuSplitter3.setStyleSheet("background-color: rgb(141, 141, 141);")
        self.MenuSplitter3.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.MenuSplitter3.setFrameShadow(QtWidgets.QFrame.Raised)
        self.MenuSplitter3.setObjectName("MenuSplitter3")
        self.stockButton = QtWidgets.QPushButton(self.MenuBar)
        self.stockButton.setMaximumSize(QtCore.QSize(31, 31))
        self.stockButton.setText("")
        self.stockButton.setIcon(QtGui.QIcon(filePath + "/icons8-clipboard-160.png"))
        self.stockButton.setStyleSheet("background-color: rgba(207, 207, 207, 0); border: none;")
        self.stockButton.setIconSize(QtCore.QSize(31, 31))
        self.stockButton.setObjectName("stockButton")
        self.MenuSplitter2 = QtWidgets.QFrame(self.MenuBar)
        self.MenuSplitter2.setMaximumSize(QtCore.QSize(1, 50))
        self.MenuSplitter2.setStyleSheet("background-color: rgb(141, 141, 141);")
        self.MenuSplitter2.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.MenuSplitter2.setFrameShadow(QtWidgets.QFrame.Raised)
        self.MenuSplitter2.setObjectName("MenuSplitter2")
        self.wifiButton = QtWidgets.QPushButton(self.MenuBar)
        self.wifiButton.setMaximumSize(QtCore.QSize(31, 31))
        self.wifiButton.setText("")
        self.wifiButton.setIcon(QtGui.QIcon(filePath + "/icons8-wi-fi-96.png"))
        self.wifiButton.setStyleSheet("background-color: rgba(207, 207, 207, 0); border: none;")
        self.wifiButton.setIconSize(QtCore.QSize(31, 31))
        self.wifiButton.setObjectName("wifiButton")
        self.MenuSplitter1 = QtWidgets.QFrame(self.MenuBar)
        self.MenuSplitter1.setMaximumSize(QtCore.QSize(1, 50))
        self.MenuSplitter1.setStyleSheet("background-color: rgb(141, 141, 141);")
        self.MenuSplitter1.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.MenuSplitter1.setFrameShadow(QtWidgets.QFrame.Raised)
        self.MenuSplitter1.setObjectName("MenuSplitter1")
        self.exitButton = QtWidgets.QPushButton(self.MenuBar)
        self.exitButton.setMaximumSize(QtCore.QSize(31, 31))
        self.exitButton.setText("")
        self.exitButton.setIcon(QtGui.QIcon(filePath + "/icons8-exit-100.png"))
        self.exitButton.setIconSize(QtCore.QSize(31, 31))
        self.exitButton.setStyleSheet("background-color: rgba(207, 207, 207, 0); border: none;")
        self.exitButton.setObjectName("exitButton")
        self.exitButton.clicked.connect(partial(self.ExitScreen, MainUI))
        self.gridLayout.addWidget(self.BottomSpacer, 1, 0, 1, 1)
        spacerItem2 = QtWidgets.QSpacerItem(20, 7, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.gridLayout.addItem(spacerItem2, 0, 0, 1, 1)
        spacerItem3 = QtWidgets.QSpacerItem(20, 8, QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Expanding)
        self.gridLayout.addItem(spacerItem3, 2, 0, 1, 1)
        self.MainUILayout.addWidget(self.BottomUILayout)
        self.gridLayout_4.addLayout(self.MainUILayout, 0, 0, 1, 1)
        MainUI.setCentralWidget(self.AllWidgets)
        self.threaderPool = QtCore.QThreadPool()
        self.initaliseServerRequest()
        print("second")
        self.retranslateUi(MainUI)
        QtCore.QMetaObject.connectSlotsByName(MainUI)

    def retranslateUi(self, MainUI):
        _translate = QtCore.QCoreApplication.translate
        MainUI.setWindowTitle(_translate("MainUI", "MainWindow"))
        self.OrderNumberLabel.setText(_translate("MainUI", "select order to view"))
        self.DetailsTitleLabel.setText(_translate("MainUI", ""))
        self.ReprintTicketButton.setText(_translate("MainUI", "Reprint Order Ticket"))
        item = self.ItemsOrderedTableWidget.horizontalHeaderItem(0)
        item.setText(_translate("MainUI", "New Column"))
        self.ReprintStickerButton.setText(_translate("MainUI", "Reprint Sticker Label"))
        self.ItemsTitleLabel.setText(_translate("MainUI", ""))
        self.DatePlacedLabel.setText(_translate("MainUI", ""))#Date:                  01/04/2020
        self.TimePlacedLabel.setText(_translate("MainUI", ""))#Time:                  12:30
        self.PaymentMethodLabel.setText(_translate("MainUI", ""))#Time:                  12:30
        self.TimeCollectionLabel.setText(_translate("MainUI", ""))#Collection Time:      14:30
        self.StatusLabel.setText(_translate("MainUI", ""))#Status:                Waiting
        self.TitleLabel.setText(_translate("MainUI", "BREAD OVEN - KITCHEN MANAGEMENT SYSTEM"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainUI = QtWidgets.QMainWindow()
    ui = Ui_MainUI()
    ui.setupUi(MainUI)
    MainUI.showFullScreen()

    timer = QtCore.QTimer()
    timer.timeout.connect(partial(ui.MaximizeElements, MainUI))
    timer.start(1000)

    sys.exit(app.exec_())

print("herererer")