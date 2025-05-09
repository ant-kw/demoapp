#!/bin/bash

getMetadata() {
    curl -fs http://metadata/computeMetadata/v1/${1} -H "Metadata-flavor: Google"
}

PROJECTID=$(getMetadata project/project-id)
REGION=$(getMetadata instance/zone|cut -f 4 -d '/')
ZONE=$(getMetadata instance/zone|cut -f 4 -d '/'|cut -f 2 -d '-')
ENV=$(getMetadata instance/attributes/env)
ROLE=$(getMetadata instance/attributes/role)

mkdir -p /etc/facter/facts.d

cat << EOFF > /etc/facter/facts.d/gcp.txt

## Bootscript Generated

projectid=${PROJECTID}
region=${REGION}
zone=${ZONE}
env=${ENV}
role=${ROLE}

EOFF

export DEBIAN_FRONTEND=noninteractive

apt-get update -qq

##Install rabbit  - puppet would take care of this 
apt-get install -qq rabbitmq-server

## Patch config 
echo "PLUGINS_DIR=\"/usr/lib/rabbitmq/plugins:/usr/lib/rabbitmq/lib/rabbitmq_server-3.10.8/plugins\"" >> /etc/rabbitmq/rabbitmq-env.conf

## enable management interface for demo

/sbin/rabbitmq-plugins enable rabbitmq_management

## start the server now
systemctl enable --now rabbitmq-server


## password here is plain - puppet would mask this however 
/usr/sbin/rabbitmqctl add_user rabbitmqclient Hunter2
/usr/sbin/rabbitmqctl set_user_tags rabbitmqclient management
/usr/sbin/rabbitmqctl set_permissions -p / rabbitmqclient ".*" ".*" ".*"



## Puppet isn't complete in this demo
#apt-get install -qq demoapp-puppet
#/usr/bin/run-puppet


