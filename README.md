# Mender Gateway with mTLS

This repository provides a set of scripts to set up and run a [Mender Gateway](https://docs.mender.io/system-updates/mender-gateway) with mutual TLS (mTLS) for secure communication with IoT devices. It also includes scripts to simulate a device and demonstrate certificate rotation.

## Prerequisites

*   Docker
*   OpenSSL
*   [Mender account](https://hosted.mender.io/)

## Setup

1.  **Configure Environment Variables:**

    The `setup.sh` script configures the necessary environment variables. You need to edit this file and provide your Mender account details, including your username, password, and tenant token.

    ```bash
    source ./setup.sh
    ```

2.  **Generate Certificates:**

    The `certificates.sh` script generates the required certificates for the CA, the Mender Gateway, and the device.

    ```bash
    ./certificates.sh
    ```

## Running the Gateway

The `install.sh` script starts the Mender Gateway in a Docker container. It uses the environment variables and certificates from the setup step.

```bash
./install.sh
```

## Simulating a Device

The `device.sh` script starts a simulated device in a Docker container and configures it to connect to the Mender Gateway.

```bash
./device.sh
```

After running this script, a new device should appear in your Mender UI, and you will be able to manage it through the gateway.

## Certificate Rotation

This repository includes a Mender Update Module for rotating device certificates. The `UpdateModule` directory contains the necessary files and a detailed guide on how to use it. Please refer to the `UpdateModule/README.md` for more information.

## Cleanup

The `cleanup.sh` script stops the Mender Gateway container and removes all the generated files, such as certificates and keys.

```bash
./cleanup.sh
```
