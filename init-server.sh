#!/bin/bash

function installServer() {
  # Add '-beta experimental' before 'validate' if you want to play on the experimental branch (check if CSS has updated the branch first!!!)
  FEXBash './steamcmd.sh +@sSteamCmdForcePlatformBitness 64 +force_install_dir "/satisfactory" +login anonymous +app_update 1690800 validate +quit'
}

function main() {
  # Fix for steamclient.so not being found
  mkdir -p /home/steam/.steam/sdk64
  ln -s /home/steam/Steam/linux64/steamclient.so /home/steam/.steam/sdk64/steamclient.so

  cd /home/steam/Steam

  # Check if we have proper read/write permissions to /satisfactory
  if [ ! -r "/satisfactory" ] || [ ! -w "/satisfactory" ]; then
    echo 'ERROR: I do not have read/write permissions to /satisfactory! Please run "chown -R 1000:1000 satisfactory/" on host machine, then try again.'
    exit 1
  fi

  # Check for SteamCMD updates
  echo 'Checking for SteamCMD updates...'
  FEXBash './steamcmd.sh +quit'

  # Check if the server is installed
  if [ ! -f "/satisfactory/FactoryServer.sh" ]; then
    echo 'Server not found! Installing...'
    installServer
  fi
  # If auto updates are enabled, try updating
  if [ "$ALWAYS_UPDATE_ON_START" == "true" ]; then
    echo 'Checking for updates...'
    installServer
  fi

  echo 'Starting server...'

  # Go to /satisfactory
  cd /satisfactory

  # Start server
  FEXBash "./FactoryServer.sh $EXTRA_PARAMS"
}

main