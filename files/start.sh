#!/bin/sh

# Grab The Default Routing Interface And Interface IP
export INTERFACE=${INTERFACE:-$(route -n | grep ^0.0.0.0 | awk '{print $8}')}
export INTERFACE_IP=${IP:-$(ip addr show dev "${INTERFACE}" | grep "inet " |  grep "brd " | awk '{print $2}' | cut -d"/" -f1)}

# Use The 4th Octet Of The IP As The Routing ID
export ROUTE_ID=${ROUTE_ID:-$(echo "${INTERFACE_IP}" | cut -d"." -f 4)}

# Generate A Shared Password - Make The Password 8 Characters
export PASSWORD=${PASSWORD:-$(openssl rand -base64 8)}
export PASSWORD=$(echo "${PASSWORD}" | cut -c1-8)

# Set A Default IP For The Keepalive Interface
export VIRTUAL_IP=${VIRTUAL_IP:-"192.168.1.250"}

# Write The Config File
envsubst < /etc/keepalived/keepalived.conf.template > /etc/keepalived/keepalived.conf

# Run Keepalived
keepalived -lDGn
