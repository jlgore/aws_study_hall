#!/bin/bash

#TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
#&& curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/
apt-get update -y && apt-get upgrade -y
export HOSTNAME=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/hostname)
export IP_ADDR=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/public-ipv4)
export HELLO_WORLD="Hello from $HOSTNAME with IP of: $IP_ADDR"
curl -H 'Content-Type: application/json' -d '{"text": $HELLO_WORLD}'  https://gorecc.webhook.office.com/webhookb2/d2c59d41-70bc-4694-adc2-26b5b0989266@2291ccdc-b921-4ba9-889a-64ae73370eeb/IncomingWebhook/4f979041ef544cb08594d8f759453fd3/6b3fe79e-6ee9-49d5-a57c-789dc5e7c41f
