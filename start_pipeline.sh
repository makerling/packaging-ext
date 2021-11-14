#! /bin/bash

source .env

response=$(curl -s -H "Accept: application/vnd.github.everest-preview+json" \
    -H "Authorization: token "$token"" \
    --request POST \
    --data '{"event_type": "create-deb-rpm-package"}' \
    https://api.github.com/repos/makerling/packaging-ext/dispatches \
    --write-out "%{http_code}\n")

if [ "$response" == 204 ]
then
    echo -e "github actions workflow has been triggered (204)\n\
navigate to the following link to download the .deb/.rpm artifacts:\n\
https://github.com/makerling/packaging-ext/actions"

elif [ "$response" == 422 ]
then
    echo "validation failed, check your token settings (422)"
else
    echo -e "there was an issue with the request:\n"$response""
fi