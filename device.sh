#!/bin/bash

docker stop mender-client-certificates
docker rm mender-client-certificates

docker run --name mender-client-certificates -d -it -p 99:85 --pull=always mendersoftware/mender-client-qemu

echo "Starting device..."

sleep 30s

docker ps -f name=mender-client-certificates -q | grep '.' > /dev/null

CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mender-client-certificates)

echo "Copying certificates to device..."
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -P 8822 device-private.key root@$CONTAINER_IP:/data/mender/mender-cert-private.pem
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -P 8822 device-cert.pem root@$CONTAINER_IP:/data/mender/mender-cert.pem
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -P 8822 ca.crt root@$CONTAINER_IP:/usr/local/share/ca-certificates/mender/ca.crt
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 8822 root@$CONTAINER_IP update-ca-certificates && \

echo "Copying configuration to device..."
# Generate the new config
cat > mender.conf << EOF
{
  "InventoryPollIntervalSeconds": 5,
  "ServerURL": "https://$MENDER_GATEWAY_DOMAIN:8443",
  "TenantToken": "$TENANT_TOKEN",
  "UpdatePollIntervalSeconds": 5,
  "HttpsClient": {
    "Certificate": "/data/mender/mender-cert.pem",
    "Key": "/data/mender/mender-cert-private.pem"
  },
  "Security": {
    "AuthPrivateKey": "/data/mender/mender-cert-private.pem"
  }
}
EOF

cat > hosts << EOF
127.0.0.1   localhost.localdomain           localhost
$MENDER_GATEWAY_IP    $MENDER_GATEWAY_DOMAIN
EOF

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 8822 root@$CONTAINER_IP systemctl stop mender-authd
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -P 8822 mender.conf root@$CONTAINER_IP:/etc/mender/mender.conf
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -P 8822 hosts root@$CONTAINER_IP:/etc/hosts

echo "Restarting Mender services on the device..."
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 8822 root@$CONTAINER_IP systemctl start mender-authd mender-updated
