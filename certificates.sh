#!/bin/bash

echo "Generating the certificates..."

openssl ecparam -genkey -name P-256 -noout -out ca-private.key
cat > ca.conf <<EOF
[req]
distinguished_name = req_distinguished_name
prompt = no
x509_extensions = v3_ca

[req_distinguished_name]
commonName=My CA
organizationName=My Organization
organizationalUnitName=My Unit
emailAddress=myusername@example.com
countryName=NO
localityName=Oslo
stateOrProvinceName=Oslo

[v3_ca]
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, keyCertSign, digitalSignature
EOF

openssl req -new -x509 -key ca-private.key -out ca.crt -config ca.conf -days $((365*10))
openssl ecparam -genkey -name P-256 -noout -out server.key

cat > server.conf <<EOF
[req]
distinguished_name = req_distinguished_name
prompt = no

[req_distinguished_name]
commonName=$MENDER_GATEWAY_DOMAIN
organizationName=My Organization
organizationalUnitName=My Unit
emailAddress=myusername@example.com
countryName=NO
localityName=Oslo
stateOrProvinceName=Oslo
EOF
openssl req -new -key server.key -out server.req -config server.conf
openssl x509 -req -CA ca.crt -CAkey ca-private.key -CAcreateserial -in server.req -out server.crt -days $((365*2))
openssl ecparam -genkey -name P-256 -noout -out device-private.key
cat > device-cert.conf <<EOF
[req]
distinguished_name = req_distinguished_name
prompt = no

[req_distinguished_name]
commonName=my-device-hostname.com
organizationName=My Organization
organizationalUnitName=My Unit
emailAddress=myusername@example.com
countryName=NO
localityName=Oslo
stateOrProvinceName=Oslo
EOF
openssl req -new -key device-private.key -out device-cert.req -config device-cert.conf
openssl x509 -req -CA ca.crt -CAkey ca-private.key -CAcreateserial -in device-cert.req -out device-cert.pem -days $((365*10))

sudo chown 65534 $(pwd)/server.crt $(pwd)/server.key $(pwd)/ca.crt
sudo chmod 0600 $(pwd)/server.key

