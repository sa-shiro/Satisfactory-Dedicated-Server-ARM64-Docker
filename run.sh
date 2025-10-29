#!/bin/bash
set -e

# Run container for debugging (COMMENT OUT 'entrypoint' INSIDE docker-compose.yml)
#sudo docker compose run -u root --rm --name satisfactory-server satisfactory-server


screen -dmS satisfactory sudo docker compose up
