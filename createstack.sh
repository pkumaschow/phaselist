#!/usr/bin/env bash

aws cloudformation create-stack --template-body file://./phaselist.template --stack-name phaselist-dev --capabilities CAPABILITY_NAMED_IAM
