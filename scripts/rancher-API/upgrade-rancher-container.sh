#!/usr/bin/env bash

ENVIRONMENT=$1
SERVICE=$2
IMAGE=$3
C_ACCESS_KEY=$4
C_SECRET_KEY=$5
R_API_URL=$6

eval $(ssh-agent)
ssh-agent sh
export CATTLE_ACCESS_KEY="$C_ACCESS_KEY"
export CATTLE_SECRET_KEY="$C_SECRET_KEY"
export RANCHER_API_URL="$R_API_URL"

./rancher.sh upgrade $ENVIRONMENT $SERVICE $IMAGE
sleep 10
./rancher.sh finish_upgrade $ENVIRONMENT $SERVICE