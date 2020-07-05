import os
import sys
import time

from azure.eventhub import EventHubConsumerClient, EventHubProducerClient

# Connection String
CONN = sys.argv[1]
HUBNAME = sys.argv[2]
CONSUMER_GROUP = "$Default"

client = EventHubConsumerClient.from_connection_string(CONN,
                                                       CONSUMER_GROUP,
                                                       eventhub_name=HUBNAME)

def on_event(partition_context, event):
    print("event: {}", event)
    print("Received event from partition {}".format(partition_context.partition_id))
    partition_context.update_checkpoint(event)

with client:
    client.receive(
        on_event=on_event, 
        starting_position="-1",  # "-1" is from the beginning of the partition.
    )
