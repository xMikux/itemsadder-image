#!/bin/sh

# Cleanup
cleanup() {
    echo "Shutting down gracefully..."
    pkill -f "java -jar paper.jar nogui"
    exit 0
}

# Setup RCON password
setup_rcon() {
    if [ -z "${RCON_ENV}" ]; then
        echo "Rcon env unset!"
        exit 1
    else
        echo "Setup rcon password..."
        sed -i "s/rcon.password=/rcon.password=${RCON_ENV}/g" server.properties
    fi
}

# Download Depends
download_plugins_depend() {
    wget -O paper.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/128/downloads/paper-1.21.1-128.jar
    wget -O plugins/VoidWorldGenerator.jar  "https://hangar.papermc.io/api/v1/projects/VoidWorldGenerator/versions/1.1.4/PAPER/download"
    wget -O plugins/LoneLibs.jar "https://github.com/LoneDev6/SpigotUtilities/releases/download/LoneLibs_1.0.58/LoneLibs_1.0.58.jar"
    wget -O plugins/ProtocolLib.jar "https://ci.dmulloy2.net/job/ProtocolLib/lastSuccessfulBuild/artifact/build/libs/ProtocolLib.jar"
} 

# Move External Plugin
move_external(){
    if [ -d "external/" ]; then
        echo "Find external folder, move files..."
        mv external/* plugins/
    else
        echo "External folder not exist..."
    fi
}

# Trap termination signals
trap 'cleanup' SIGTERM SIGINT

# Run functions
setup_rcon
download_plugins_depend
move_external

# Start Minecraft Server
java -jar paper.jar nogui &

wait