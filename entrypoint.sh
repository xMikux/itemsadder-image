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
    wget -O paper.jar "https://fill-data.papermc.io/v1/objects/8de7c52c3b02403503d16fac58003f1efef7dd7a0256786843927fa92ee57f1e/paper-1.21.8-60.jar"
    wget -O plugins/VoidWorldGenerator.jar  "https://github.com/HydrolienF/VoidWorldGenerator/releases/download/1.3.7/VoidWorldGenerator-1.3.7.jar"
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
