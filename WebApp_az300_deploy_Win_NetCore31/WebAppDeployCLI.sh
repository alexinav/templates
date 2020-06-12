#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
 
# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
 
usage() { 
    echo "Usage: $0 -i "cc4f3a29-5039-43c7-87dd-a18084b3f96b" -g xGroup -n deploymentwebappalix0002 -l westeurope -t template.json -p parameters.json -m <mode>" 1>&2; 
    exit 1; 
}
 
declare subscriptionId=""
declare resourceGroupName=""
declare deploymentName=""
declare resourceGroupLocation=""
declare parametersFilePath=""
declare templateFilePath=""
declare mode=""
 
# Initialize parameters specified from command line
while getopts ":i:g:n:l:p:" arg; do
    case "${arg}" in
        i)
            subscriptionId=${OPTARG}
            ;;
        g)
            resourceGroupName=${OPTARG}
            ;;
        n)
            deploymentName=${OPTARG}
            ;;
        l)
            resourceGroupLocation=${OPTARG}
            ;;
        t)
            templateFilePath=${OPTARG}
            ;;
        p)
            parametersFilePath=${OPTARG}
            ;;
        m)
            mode=${OPTARG}
            ;;
        esac
done
shift $((OPTIND-1))
 
#Prompt for parameters is some required parameters are missing
if [[ -z "$subscriptionId" ]]; then
    echo "Subscription Id:"
    read subscriptionId
    [[ "${subscriptionId:?}" ]]
fi
 
if [[ -z "$resourceGroupName" ]]; then
    echo "ResourceGroupName:"
    read resourceGroupName
    [[ "${resourceGroupName:?}" ]]
fi
 
if [[ -z "$deploymentName" ]]; then
    deploymentName="Deploy_$(date +"%m.%d.%Y-%I.%M.%S")"
fi
 
if [[ -z "$resourceGroupLocation" ]]; then
    resourceGroupLocation="West US"
fi
 
if [[ -z "$templateFilePath" ]]; then
    templateFilePath="AzureWebHelloWorld.json"
fi
 
if [[ -z "$parametersFilePath" ]]; then
    echo "Enter parameter file path "
    echo "parametersFilePath:"
    read parametersFilePath
fi
 
if [[ -z "$mode" ]]; then
    mode="Complete"
fi
 
if [ ! -f "$templateFilePath" ]; then
    echo "$templateFilePath not found"
    exit 1
fi
 
#parameter file path
if [ ! -f "$parametersFilePath" ]; then
    echo "$parametersFilePath not found"
    exit 1
fi
 
if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$deploymentName" ]; then
    echo "Either one of subscriptionId, resourceGroupName, deploymentName is empty"
    usage
fi
 
#login to azure using your credentials
az account show 1> /dev/null
 
if [ $? != 0 ];
then
    az login
fi
 
#set the default subscription id
#az account set --name $subscriptionId #default, doesn't work
az account set --sub $subscriptionId
 
set +e
 
#Check for existing RG
#az group show $resourceGroupName 1> /dev/null #default, doesn't work
 
if [ $(az group exists --name $resourceGroupName) == 'false' ]; then
    echo "Resource group with name" $resourceGroupName "could not be found. Creating new resource group.."
    set -e
    (
        set -x
        az group create --name $resourceGroupName --location $resourceGroupLocation 1> /dev/null
    )
    else
    echo "Using existing resource group..."
fi
 
#Start deployment
echo "Starting deployment..."
(
    set -x
    az group deployment create --name $deploymentName --resource-group $resourceGroupName --template-file $templateFilePath --parameters $parametersFilePath --mode $mode --debug
)
 
if [ $?  == 0 ];
 then
    echo "Template has been successfully deployed"
fi