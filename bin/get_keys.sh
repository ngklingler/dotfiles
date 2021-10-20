#! /bin/bash

set -e
sync () {
    BW_SESSION=$(bw unlock --raw)
    bw sync
    keys='gitlab github'
    eval $(ssh-agent -s)
    for key in $keys; do
        bw get item ssh/$key | jq -r .notes > ~/.ssh/$key
        chmod 600 ~/.ssh/$key
        ssh-add ~/.ssh/$key
    done
}

sync
