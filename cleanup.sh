#!/bin/bash

#!/bin/bash

docker stop mender-gateway
docker rm mender-gateway

find . -maxdepth 1 -type f -not \( -name "*.sh" -o -name "*.md" \) -delete
