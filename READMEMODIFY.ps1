#FOR DEPLOYING VM


#MODIFY VALUES IN "parameters.json" FILE
#001
# "publicIpAddressName": {
#   "value": "windowsvm1-ip"
#002
# "virtualMachineName": {
#    "value": "windowsvm1"
#003
# "networkInterfaceName": {
#   "value": "windowsvm1605"
#004
# "virtualMachineComputerName": {
#   "value": "windowsvm2"
#005
# "adminPassword": {
#   "value": "<passwd>"

################################################################################
#MODIFY VALUES IN "template.json" FILE

#NEW VERSION
#  "contentVersion": "1.0.0.0",
#TAGS
# "tags": {
#     "env": "dev",
#    "name": "value"
# },

##                    "imageReference": {
##                          "publisher": "MicrosoftWindowsServer",
##                          "offer": "WindowsServer",
##                          "sku": "2016-datacenter-gensecond",
##                          "version": "latest"

#ALSO TO KNOW WHAT IMAGE:
#//> az vm image list --output table



#SHOW SUBSCRIPTION ID
Get-AzSubscription
#SHOW RESOURCE GROUP LIST
Get-AzureRmResourceGroup



###PORTS

# "networkSecurityGroupRules": {
#     "value": [
#         {
#             "name": "RDP",
#             "properties": {
#                 "priority": 300,
#                 "protocol": "TCP",
#                 "access": "Allow",
#                 "direction": "Inbound",
#                 "sourceAddressPrefix": "*",
#                 "sourcePortRange": "*",
#                 "destinationAddressPrefix": "*",
#                 "destinationPortRange": "3389"
#             }