#! /bin/bash

source .env

response=$(curl -H "Accept: application/vnd.github.everest-preview+json" \
    -H "Authorization: token "$token"" \
    --request POST \
    --data '{"event_type": "create-deb-rpm-package"}' \
    https://api.github.com/repos/makerling/packaging-ext/dispatches \
    --write-out "%{http_code}\n")

echo
echo $response
echo

if [ "$response" == 204 ]
then
    echo "github actions workflow has been triggered (204)"
elif [ "$response" == 422 ]
then
    echo "validation failed, check your token settings (422)"
else
    echo -e "there was an issue with the request:\n"$response"\n"
fi