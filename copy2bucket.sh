#!/usr/bin/env bash

#copy local files into bucket

aws s3 cp public/default.css s3://phaselist
aws s3 cp phaselist.html s3://phaselist