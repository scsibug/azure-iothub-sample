import random
import time
import os
import sys

from azure.iot.device import IoTHubDeviceClient, Message

CONNECTION_STRING = sys.argv[1]

# Send a 

# Define the JSON message to send to IoT Hub.
MSG_FMT = '{{"sysload": {load}}}'

def iothub_client_init():
    client = IoTHubDeviceClient.create_from_connection_string(CONNECTION_STRING)
    return client

def telemetry_loop():
    try:
        client = iothub_client_init()
        while True:
            cpu = os.getloadavg()[0]
            # Build the message with simulated telemetry values.
            msg = Message(MSG_FMT.format(load=cpu))
            # Custom properties
            if cpu > 1:
                msg.custom_properties["loadAlert"] = "true"
            else:
                msg.custom_properties["loadAlert"] = "false"
            # Send the message.
            print( "Sending message: {}".format(msg))
            client.send_message(msg)
            time.sleep(60)

    except KeyboardInterrupt:
        print ( "Exiting..." )

if __name__ == '__main__':
    print("IOTHub Load Client")
    telemetry_loop()
