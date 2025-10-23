#!/bin/bash

docker stop mender-gateway
docker rm mender-gateway

docker run \
  -p 8443:8443 \
  -p 8080:8080 \
  --name mender-gateway \
  -e HTTPS_ENABLED="true" \
  -e HTTPS_LISTEN=":8443" \
  -e HTTP_ENABLED="true" \
  -e HTTP_LISTEN=":8080" \
  -e HTTPS_SERVER_CERTIFICATE="/etc/mender/certs/server.crt" \
  -e HTTPS_SERVER_KEY="/etc/mender/certs/server.key" \
  -e MTLS_CA_CERTIFICATE="/etc/ssl/certs/ca.crt" \
  -e MTLS_ENABLED="true" \
  -e MTLS_MENDER_PASSWORD="$MENDER_PASSWORD" \
  -e MTLS_MENDER_USERNAME="$MENDER_USERNAME" \
  -e UPSTREAM_SERVER_URL="$UPSTREAM_SERVER_URL" \
  -v $(pwd)/server.crt:/etc/mender/certs/server.crt \
  -v $(pwd)/server.key:/etc/mender/certs/server.key \
  -v $(pwd)/ca.crt:/etc/ssl/certs/ca.crt \
  $MENDER_GATEWAY_IMAGE --log-level debug

