# Mender Certificate Rotation (reference)

This document describes how to use the `mender-cert-updater` script to rotate device certificates.

### 1. The `mender-cert-updater` Update Module

It's a shell script that handles the installation, commit, and rollback of the new certificate.

**Important:** The script assumes your device key is at `/etc/mender/device-private.key` and the certificate is at `/etc/mender/device-cert.pem`. If your setup is different, you need to edit the script and change the `DEVICE_KEY` and `DEVICE_CERT` variables.

### 2. Move the script to your device

You need to place the `mender-cert-updater` script on your device in the `/usr/share/mender/modules/v3/` directory.

### 3. Generate a new Key and Certificate

On your workstation, you need to generate a new private key and a certificate signing request (CSR). Then you will sign the CSR with your Certificate Authority (CA).

```bash
# Generate the new key pair 
openssl ecparam -genkey -name P-256 -noout -out device-private.key.new
openssl req -new -key device-private.key.new -out device-cert.req.new -config ../device-cert.conf

# Sign the key using the already created CA
openssl x509 -req -CA ../ca.crt -CAkey ../ca-private.key -CAcreateserial -in device-cert.req.new -out device-cert.pem.new -days $((365*10))
```

This will create `device-private.key.new` and `device-cert.pem.new`.

### 4. Create the Mender Artifact

Now you can create the Mender artifact that you will deploy to your device. You will need the `mender-artifact` tool for this.

The artifact will include the new key and certificate.

```bash
mender-artifact write module-image \
    -T mender-cert-updater \
    --device-type qemux86-64 \
    -n cert-rotation-v1 \
    -f device-private.key.new \
    -f device-cert.pem.new \
    -o cert-rotation-v1.mender
```

This command will create a Mender artifact named `cert-rotation-v1.mender`.

*   `-T mender-cert-updater`: Specifies the type of the update, which matches the name of our update module.
*   `--device-type qemux86-64`: Specifies the device type, should match your board.
*   `-n cert-rotation-v1`: The name of the artifact.
*   `-f device-private.key.new`: The new private key to be included in the artifact.
*   `-f device-cert.pem.new`: The new certificate to be included in the artifact.
*   `-o cert-rotation-v1.mender`: The output file name of the artifact.

### 5. Deploy the Artifact

You can now upload the `cert-rotation-v1.mender` artifact to your Mender server and create a deployment to your devices. The `mender-cert-updater` script on the device will handle the certificate rotation process. After the artifact is deployed, next time the Mender client runs Sync_Leave the Mender Services will restart and start using the new certificate.

