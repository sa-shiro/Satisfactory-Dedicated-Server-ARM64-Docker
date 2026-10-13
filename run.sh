#!/bin/bash
set -e

# Run container for debugging (COMMENT OUT 'entrypoint' INSIDE docker-compose.yml)
#sudo docker compose run -u root --rm --name satisfactory-server satisfactory-server

# Try running with screen, then tmux
if command -v screen &> /dev/null; then
  screen -dmS satisfactory sudo docker compose up
  
elif command -v tmux &> /dev/null; then
  tmux new -d -s satisfactory "sudo docker compose up"
  
else
  echo "No screen or tmux found" >&2
  exit 1
fi
