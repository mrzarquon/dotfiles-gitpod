#!/bin/bash

if [ ! -d ~/.aws ]; then
    mkdir ~/.aws
fi

cat <<- AWSFILE > ~/.aws/config
[default]
sso_start_url = ${AWS_SSO_URL}
sso_region = ${AWS_SSO_REGION}
sso_account_id = ${AWS_ACCOUNT_ID}
sso_role_name = ${AWS_ROLE_NAME}
region = eu-west-1
AWSFILE

