
import mysql.connector
import paho.mqtt.client as mqtt
import time
import threading
from functools import partial
import getpass
if str(getpass.getuser()) == "root":
    import printerFunction
else:
    import printerFunction2 as printerFunction
    #test

def on_message(client, userdata, msg):
    if "New Quick kit Order Number" in str(msg.payload):
        newValue = str(msg.payload).split(':')[1]
        print(newValue)
        newValue = int(newValue.split("'")[0])
        printerFunction.printInitalOrderTicket(newValue)
    elif "Reprint Quick kit Order Number" in str(msg.payload):
        newValue = str(msg.payload).split(':')[1]
        print(newValue)
        newValue = int(newValue.split("'")[0])
        printerFunction.reprintOrderTicket(newValue)


def subscribing():
    client = mqtt.Client()
    client.connect("broker.mqttdashboard.com", 1883)
    client.subscribe("newOrderGarmanApps/")
    client.on_message = partial(on_message)
    client.loop_forever()
    
sub=threading.Thread(target=subscribing)
sub.start()


