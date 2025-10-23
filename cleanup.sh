#!/bin/bash

#!/bin/bash

docker stop mender-gateway
docker rm mender-gateway

docker stop mender-client-certificates
docker rm mender-client-certificates

find . -maxdepth 1 -type f -not \( -name "*.sh" -o -name "*.md" -o -name "*.gitignore" -o -name "*.env" \) -delete
