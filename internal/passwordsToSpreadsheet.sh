#!/bin/bash

 aws ec2 describe-instances --filters "Name=tag-key,Values=env" --filters "Name=tag-value,Values=grouperTraining" |jq '[.Reservations | .[] | .Instances | .[] | select(.State.Name!="terminated") ] | .[] | .InstanceId' | xargs -n 1 -I{}  aws  ec2 get-console-output  --instance-id {} | gawk 'match($0, /abcdefg12345678,([0-9.]+),([0-9a-zA-Z]+),/, m) { print m[1], ",student,", m[2], ",ssh -L 8443:localhost:8443 -l student ", m[1]; }'
 