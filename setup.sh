#!/bin/bash

echo "Setting up the env variables"

# For evaluation, define an arbitrary domain for the mtls server (we will modify `/etc/hosts` on the device).
# No external registration will take place.
# The values provided here are arbitrary defaults.
export MENDER_GATEWAY_DOMAIN="local-domain-1993028.com"

# This is the IP of the pc you'll be running the mtls proxy on.
# Once the container is running this is the IP we'll be expected to communicate with it
# Is this the shell you'll be running the container on?
#    You can use `ip route get 8.8.8.8 | awk '{print $7}' | head -n 1` to get the IP
export MENDER_GATEWAY_IP=""

# You need to create a separate user in your Mender account.
# The mtls server will authenticate devices on Mender as this user.
# Fill these with the credentials of your newly created user.
export MENDER_USERNAME=""
export MENDER_PASSWORD=""

# Set the URL of the mender server 
# i.e 
# export UPSTREAM_SERVER_URL=""
# export UPSTREAM_SERVER_URL=""
export UPSTREAM_SERVER_URL=""

# Set the tenant/organization token for your account
# Located under Settings->Organization and billing token once logged in to the Mender UI
export TENANT_TOKEN=""

# Set the docker registry configuration and credentials
export DOCKER_REGISTRY_URL="registry.mender.io"
export DOCKER_REGISTRY_USERNAME=""
export DOCKER_REGISTRY_PASSWORD=""

# The name and version of the mtls server container
# The defaults have been set, you rarely need to change this.
export MENDER_GATEWAY_IMAGE="${DOCKER_REGISTRY_URL}/mendersoftware/mender-gateway:2.0.0"

