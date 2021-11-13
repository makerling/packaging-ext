#! /bin/bash

source .env

curl -H "Accept: application/vnd.github.everest-preview+json" \
    -H "Authorization: token "$token"" \
    --request POST \
    --data '{"event_type": "create-deb-rpm-package"}' \
    https://api.github.com/repos/makerling/packaging-ext/dispatches \
    --write-out "%{http_code}\n"