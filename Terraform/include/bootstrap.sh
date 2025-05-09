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
apt-get install -qq demoapp-puppet


/usr/bin/run-puppet


