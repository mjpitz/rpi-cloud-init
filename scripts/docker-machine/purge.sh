#!/usr/bin/env bash

export NETWORK_IP=${NETWORK_IP:-192.168.4.1}
readonly ip_prefix=${NETWORK_IP%.1}

export ADMIN_USER=${ADMIN_USER:-mjpitz}

function stop_unattended_upgrades() {
  ssh -oStrictHostKeyChecking=no ${ADMIN_USER}@$1 sudo killall unattended-upgrade
}

function remove_unattended_upgrades() {
  ssh -oStrictHostKeyChecking=no ${ADMIN_USER}@$1 bash -s <<EOF
sudo apt-get install -f
sudo dpkg --configure -a
sudo apt-get purge --auto-remove -y unattended-upgrades
sudo apt-get update -y
EOF
}

function stop_zone() {
  prefix=$1
  start=$2
  end=$3

  for i in $(seq ${start} ${end}); do
    stop_unattended_upgrades ${prefix}.${i}
  done
}

function remove_zone() {
  prefix=$1
  start=$2
  end=$3

  for i in $(seq ${start} ${end}); do
    remove_unattended_upgrades ${prefix}.${i}
  done
}

stop_zone ${ip_prefix} 50 54
stop_zone ${ip_prefix} 60 64
stop_zone ${ip_prefix} 70 74

remove_zone ${ip_prefix} 50 54
remove_zone ${ip_prefix} 60 64
remove_zone ${ip_prefix} 70 74
