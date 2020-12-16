
import slack
import ssl as ssl_lib
import certifi
import urllib
import time
import tkinter

trigger = False

def messagebox():
    root = tkinter.Tk()
    root.title("GUI")
    root.geometry("500x20")
    trigger = True

    label = tkinter.Label(text = "Disconnected from Server").pack()

    root.mainloop()

def say_hello(data, **kwargs):
    if 'Hello' in data['text']:
        print("here")

try:
    ssl_context = ssl_lib.create_default_context(cafile=certifi.where())
    slack_token = "xoxb-795840878529-856613875153-zMXfzOYTYXrfQTVuevr1LEF5"
    rtmclient = slack.RTMClient(token=slack_token, ssl=ssl_context)
    rtmclient.on(event='message', callback=say_hello)
    rtmclient.start()
except Exception:
    pass

while True:

    try:
        urllib.request.urlopen("http://google.com")
        try:
            rtmclient.start()
        except Exception:
            pass
    except Exception as e:
        print(e)
        messagebox()
        print("HERE")
        
    

# ssl_context = ssl_lib.create_default_context(cafile=certifi.where())
# slack_token = "xoxb-795840878529-856613875153-zMXfzOYTYXrfQTVuevr1LEF5"
# rtmclient = slack.RTMClient(token=slack_token, ssl=ssl_context, auto_reconnect=False)
# rtmclient.on(event='message', callback=say_hello)
# rtmclient.start()

