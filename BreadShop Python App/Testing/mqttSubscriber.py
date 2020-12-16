# Python Subscriber
#   Get messages from the MQTT queue (mydata)
import paho.mqtt.client as mqtt
import threading
import time

def on_message(client, userdata, msg):
    if "Bread Oven" in str(msg.payload):
        orderNumber = str(msg.payload).split(':')[1]
        orderNumber = orderNumber.split("'")[0]
        print(str(int(orderNumber)))

client = mqtt.Client()
client.connect("broker.mqttdashboard.com", 1883)
client.subscribe("newOrderGarmanApps/")


def subscribing():
    client.on_message = on_message
    client.loop_forever()
sub=threading.Thread(target=subscribing)
sub.start()

while True:
    print("hello")
    time.sleep(10)