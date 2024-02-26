# Satisfactory Dedicated Server for ARM64 (Docker Container)

This Docker container provides a dedicated server for running Satisfactory on ARM64 architecture. It is based on [nitrog0d/palworld-arm64](https://github.com/nitrog0d/palworld-arm64).

---
# !!! IMPORTANT !!!

The server might crash when trying to place down Conveyor Belts, see the following links:

- (Reddit) [[Dedicated Server] Everytime I try to put conveyor belts server crashes](https://www.reddit.com/r/SatisfactoryGame/comments/187py9k/dedicated_server_everytime_i_try_to_put_conveyor/)
- (Satisfactory Q&A) [UPDATE 8 - UOBJECT MAX LIMIT CRASHES INCREASING - Early Access: 264901](https://questions.satisfactorygame.com/post/65613ca4d0053b102f18f4c2)

You might want to try running the Server outside of a Docker Container using FEXEmu and SteamCMD as this has not been tested yet.
---

## Getting Started

1. **Download or Clone Repository**:
   Download or clone this repository to your desired folder, for example, `satisfactory-server`.

2. **Set Up Permissions**:
   Create a folder named `satisfactory` and `config` (your savegame and server config will be stored in there) and grant full permissions to it:

   - Using `chmod`:
     ```
     sudo chmod 777 satisfactory
     sudo chmod 777 config
     ```
   - Using `chown` (replace **USER_ID:GROUP_ID** with the desired user's IDs, for example, `1000:1000`):
     ```
     sudo chown -R USER_ID:GROUP_ID satisfactory
     sudo chown -R USER_ID:GROUP_ID config
     ```
     (On Oracle Cloud Infrastructure (OCI), by default, the user with the ID `1000:1000` is `opc`. However, since this user is primarily intended for the setup process, it is advisable to utilize the `ubuntu` user with IDs `1001:1001`)

3. **Build the Docker Image**:
   Run the build script:

   ```
   sh build.sh
   ```

   If execution permission is denied, grant it:

   ```
   chmod +x build.sh
   ```

4. **Run the Docker Image**:
   After the build process completes, start the Docker image either by running:

   ```
   sh run.sh
   ```

   Or via Docker Compose in detached mode:

   ```
   sudo docker compose up -d
   ```

5. **Open Necessary Ports**:
   The following ports must be opened for the server to function properly:

   - TCP: `27015, 27036`
   - UDP: `7777, 15000, 15777, 27015, 27031-27036`
     Ensure these ports are open using the Linux firewall of your choice and also within the Security List of the Oracle Cloud Infrastructure Network.

6. **Default Port**:
   The default port for the server is `15777`.

Now your Satisfactory Dedicated Server for ARM64 is ready!. Enjoy your gaming experience with friends.

## Modifying Server Port Configuration

To alter the server port, you'll need to make adjustments in the `docker-compose.yml` file:

1. **docker-compose.yml**:
   Edit this file to expose the desired ports outside of the container and set the `$EXTRA_PARAMS` environment variable to configure additional parameters for the `FactoryServer.sh` script.

Ensure that these changes are made accurately to reflect your desired server port configuration.

### $EXTRA_PARAMS Options

| Option                     | Description                                                                                                                                                                                                                                           | Example                |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| -multihome=<ip address>    | Bind the server process to a specific IP address rather than all available interfaces                                                                                                                                                                 | -multihome=192.168.1.4 |
| -ServerQueryPort=<portnum> | Override the Query Port the server uses. This is the port specified in the Server Manager in the client UI to establish a server connection. This can be set freely. The default port is UDP/15777.                                                   | -ServerQueryPort=15000 |
| -BeaconPort=<portnum>      | Override the Beacon Port the server uses. As of Update 6, this port can be set freely. The default port is UDP/15000. If this port is already in use, the server will step up to the next port until an available one is found.                       | -BeaconPort=15001      |
| -Port=<portnum>            | Override the Game Port the server uses. This is the primary port used to communicate game telemetry with the client. The default port is UDP/7777. If it is already in use, the server will step up to the next port until an available one is found. | -Port=15002            |
| -DisablePacketRouting      | Startup argument for disabling the packet router (Automatically disabled with multihome)                                                                                                                                                              | -DisablePacketRouting  |

### Example usage:

```
EXTRA_PARAMS=-⁠ServerQueryPort=17531 -⁠BeaconPort=17532 -Port=17533
```

### Auto Update

If you want to check for game server updates, add the following to `docker-compose.yml`:
```
environment:
    - ALWAYS_UPDATE_ON_START=true
```
