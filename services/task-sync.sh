#!/usr/bin/env bash

# Sync tasks with `task sync` periodically.
# This script is called by the task-sync service, which is a systemd timer.

# Default configuration file
TASKRC=${TASKRC:-$HOME/.taskrc}

notify() {
  if command -v notify-send &>/dev/null; then
    notify-send "Task Sync" "$1"
  fi
}

if [ "$(id -un)" = "root" ]; then
  echo "You don't want to run this script as root. Bye!"
  exit 1
fi

# lets source .profile to get the correct path
source ~/.profile

# Check if Taskwarrior is installed
if ! command -v task &>/dev/null; then
  echo "Taskwarrior is not installed. Exiting."
  exit 1
fi

# Check if the configuration file and sync.server setting exist
if [ ! -f "$TASKRC" ] || ! grep -q "sync.server" "$TASKRC"; then
  echo "No sync.server config found in $TASKRC. Exiting."
  exit 1
fi

# Check if connected to the internet
if ! ping -q -c 1 -W 1 8.8.8.8 &>/dev/null; then
  echo "Unable to connect to the internet. Exiting."
  exit 0 # We're OK with no internet connection
fi

# Sync tasks
echo "Syncing tasks..."
if task sync; then
  echo "Tasks synced successfully."
else
  echo "Task sync failed. Exiting."
  notify "Task sync failed. Please check the sync server and taskwarrior configuration."
  exit 1
fi
