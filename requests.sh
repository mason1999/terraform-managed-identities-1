#! /usr/bin/bash

usage() {
    echo -e "\e[93mUsage: Please enter a subscription Id\e[37m"
    echo -e "\e[93m./requests.sh -s <subscription id>\e[37m"
}


#################### BEGIN SCRIPT ####################
subscription_id=''
while getopts ':s:' option; do 
    case $option in
        (s)
            subscription_id=${OPTARG}
            ;;
    esac
done

shift $(( OPTIND - 1 ))

if [[ -z "${subscription_id}" ]]; then
    usage
    exit 0
fi 

token=$(curl -X GET \
    -H 'MetaData: true'\
    'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/' | jq --raw-output '.access_token')

curl -X GET \
    -H "Authorization: Bearer ${token}" \
    "https://management.azure.com/subscriptions/${subscription_id}/resourcegroups?api-version=2021-04-01"
