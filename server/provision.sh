SUB=Test
RG=iot
UNIQ=${SUB}20200704
IOTHUBNAME=iothub${UNIQ}
DPSNAME=dps${UNIQ}
LOC=southcentralus

# Create the resource group
az group create --subscription $SUB -g $RG -l southcentralus

# Create the IOTHub with unique name
az iot hub create \
  --subscription $SUB \
  -g $RG \
  --name $IOTHUBNAME \
  --sku F1 \
  --c2d-ttl=48 \
  --retention-day 1 \
  --partition-count 2

# Create a Device Provisioning Service
az iot dps create \
   --subscription $SUB \
  -g $RG \
  --name $DPSNAME \
  --sku S1 \
  --unit 1

# Get the iothub hostname
IOTHOST=$(az iot hub show \
	     --name $IOTHUBNAME \
	     --subscription $SUB  \
	     --query="properties.hostName" \
	     --output tsv)

# Get the shared access key for the iothub
IOTKEY=$(az iot hub policy show \
		   --hub-name $IOTHUBNAME \
		   --name iothubowner \
		   --subscription $SUB \
		   --query="primaryKey" \
		   --output=tsv)
# Build connection string
IOTCONNECTION="HostName=${IOTHOST};SharedAccessKeyName=iothubowner;SharedAccessKey=${IOTKEY}"

# Link DPS to the hub
az iot dps linked-hub create \
   --subscription $SUB \
   --resource-group $RG \
   --dps-name $DPSNAME \
   --location $LOC \
   --connection-string=$IOTCONNECTION

# Retrieve the default endpoint URL
ENDPOINT_URL=$(az iot hub show \
		  --name $IOTHUBNAME \
		  --subscription $SUB \
		  --query "properties.eventHubEndpoints.events.endpoint" \
		  --output tsv)

# Retrieve the EventHub name
EVENTHUB_NAME=$(az iot hub show \
		   --name $IOTHUBNAME \
		   --subscription $SUB \
		   --query "properties.eventHubEndpoints.events.path" \
		   --output tsv)

# Add the EventHub URL and hub name into a connection string
EVENTHUB_ENDPOINT="Endpoint=${ENDPOINT_URL};SharedAccessKeyName=iothubowner;SharedAccessKey=${IOTKEY};EntityPath=${EVENTHUB_NAME}"

# Display Eventhub Connection String
echo $EVENTHUB_ENDPOINT


