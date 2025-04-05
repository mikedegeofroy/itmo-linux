#!/bin/bash

GROUP_NAME="cpu-dyn"
CGROUP_PATH="/sys/fs/cgroup/cpu/$GROUP_NAME"
PERIOD=100000
LOW_QUOTA=80000
HIGH_QUOTA=30000

LOW_LOAD_LIMIT=20
HIGH_LOAD_LIMIT=60

if [ -z "$1" ]; then
    echo "Usage: $0 <PID>"
    exit 1
fi

PID=$1

if [ ! -d "$CGROUP_PATH" ]; then
    sudo cgcreate -g cpu:/$GROUP_NAME
fi

sudo cgset -r cpu.cfs_period_us=$PERIOD $GROUP_NAME
sudo cgset -r cpu.cfs_quota_us=$LOW_QUOTA $GROUP_NAME

echo $PID | sudo tee $CGROUP_PATH/tasks > /dev/null

echo "[INFO] Monitoring pid $PID in cgroup $GROUP_NAME..."

while true; do
    CPU_USAGE=$(top -bn2 | grep "Cpu(s)" | tail -n1 | awk '{print 100 - $8}' | cut -d. -f1)

    if [ "$CPU_USAGE" -lt "$LOW_LOAD_LIMIT" ]; then
        sudo cgset -r cpu.cfs_quota_us=$LOW_QUOTA $GROUP_NAME
        echo "[LOW] CPU load: $CPU_USAGE% — Set quota to 80%"
    elif [ "$CPU_USAGE" -gt "$HIGH_LOAD_LIMIT" ]; then
        sudo cgset -r cpu.cfs_quota_us=$HIGH_QUOTA $GROUP_NAME
        echo "[HIGH] CPU load: $CPU_USAGE% — Set quota to 30%"
    else
        echo "[MID] CPU load: $CPU_USAGE% — No change"
    fi

    sleep 5
done

