# Python Publisher
#   Send the time (hh:mm:ss) to MQTT queue (mydata) every 10 seconds
import paho.mqtt.client as mqtt
import time

client = mqtt.Client()
client.connect("broker.mqttdashboard.com", 1883)

while True:
  mypayload = time.strftime("%I:%M:%S")
  client.publish("benData/", mypayload, qos=2, retain=True)
  time.sleep(10)
  print("done")

client.disconnect()

