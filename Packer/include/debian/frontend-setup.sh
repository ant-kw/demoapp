#!/bin/bash
getMetadata() {
	curl -fs http://metadata/computeMetadata/v1/${1} -H "Metadata-flavor: Google"
}


ENVNAME=$(getMetadata instance/attributes/env)



sudo mv /tmp/apt-gs /usr/lib/apt/methods/gs
sudo mv /tmp/run-puppet /usr/bin/run-puppet && chmod +x /usr/bin/run-puppet


REPO_HOST='packages.cloud.google.com'
CODENAME="$(lsb_release -sc)"
REPO_NAME="google-cloud-ops-agent-${CODENAME}-all"
REPO_DATA="deb https://${REPO_HOST}/apt ${REPO_NAME} main"

echo "${REPO_DATA}" | sudo tee /etc/apt/sources.list.d/google-cloud-ops-agent.list
curl --connect-timeout 5 -s -f "https://${REPO_HOST}/apt/doc/apt-key.gpg" | gpg --dearmor |sudo tee "/etc/apt/trusted.gpg.d/google-cloud-packages-archive-keyring.gpg" > /dev/null


sudo apt-get update -qq && sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -qq

sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq vim htop atop make ruby apt-transport-https ca-certificates curl daemonize apt-utils lsb-release cron at logrotate rsyslog lsof procps python3-pip wget curl


echo "deb [trusted=yes] gs://demoapp-${ENVNAME}-repo/puppet bookworm main" | sudo tee /etc/apt/sources.list.d/puppet-${ENVNAME}-repo.list

sudo apt-get update


