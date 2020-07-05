SUB=Test
RG=iot
UNIQ=${SUB}20200704
IOTHUBNAME=iothub${UNIQ}
DPSNAME=dps${UNIQ}
LOC=southcentralus
DEVICE=python-sample-5z4

# Ensure azure-iot extension installed:
# az extension add --name azure-iot

#Create a new device, registered in the hub
az iot hub device-identity create \
   --device-id $DEVICE \
   --auth-method shared_private_key \
   --hub-name $IOTHUBNAME \
   --subscription $SUB \
   --resource-group $RG

# Retrieve the connection string for this device
DEVCONN=$(az iot hub device-identity show-connection-string \
	     --hub-name $IOTHUBNAME \
	     --subscription $SUB  \
	     --device-id $DEVICE \
	     --output tsv)

# This is required for the device to connect
echo $DEVCONN
