#!/bin/bash

# Script to start and stop the aesdsocket daemon.

# Path to the aesdsocket executable
DAEMON_PATH="/path/to/your/aesdsocket"  # Update this path to where aesdsocket is located

# Name of the daemon process
DAEMON_NAME="aesdsocket"

# Path to store the PID file
PID_FILE="/var/run/aesdsocket.pid"

# Start the daemon using start-stop-daemon
start() {
    echo "Starting $DAEMON_NAME..."
    # Use start-stop-daemon to start the daemon in the background with the -d option
    start-stop-daemon --start --quiet --background --pidfile $PID_FILE --make-pidfile \
                      --exec $DAEMON_PATH -- -d
    if [ $? -eq 0 ]; then
        echo "$DAEMON_NAME started successfully."
    else
        echo "Failed to start $DAEMON_NAME."
        exit 1
    fi
}

# Stop the daemon using start-stop-daemon
stop() {
    echo "Stopping $DAEMON_NAME..."
    # Use start-stop-daemon to stop the daemon gracefully using the PID file
    start-stop-daemon --stop --quiet --pidfile $PID_FILE --retry 10
    if [ $? -eq 0 ]; then
        echo "$DAEMON_NAME stopped successfully."
    else
        echo "Failed to stop $DAEMON_NAME."
        exit 1
    fi
}

# Check the status of the daemon
status() {
    if start-stop-daemon --status --pidfile $PID_FILE; then
        echo "$DAEMON_NAME is running."
    else
        echo "$DAEMON_NAME is not running."
    fi
}

# Main entry point to control the script
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac

exit 0

