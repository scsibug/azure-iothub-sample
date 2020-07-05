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
IOTCONNECTION="HostName=${IOTHOST};SharedAccessKeyName=iothubowner;SharedAccessKey=${IOTKEY}"

# Link DPS to the hub
az iot dps linked-hub create \
   --subscription $SUB \
   --resource-group $RG \
   --dps-name $DPSNAME \
   --location $LOC \
   --connection-string=$IOTCONNECTION

# Ensure azure-iot extension installed:
# az extension add --name azure-iot

