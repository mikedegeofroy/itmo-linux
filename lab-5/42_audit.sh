#!/bin/bash

BASE_DIR="$HOME/overlay_42"
LOWER="$BASE_DIR/lower"
UPPER="$BASE_DIR/upper"
MERGED="$BASE_DIR/merged"
LOG="$BASE_DIR/42_audit.log"

echo "Дата: $(date)" >> "$LOG"
echo "" >> "$LOG"

echo "[WHITEOUT FILES]" >> "$LOG"
find "$UPPER" -name ".wh.*" | while read whfile; do
    filename=$(basename "$whfile" | sed 's/^\.wh\.//')
    lower_file="$LOWER/$filename"
    merged_file="$MERGED/$filename"

    echo "Обнаружен whiteout: $whfile" >> "$LOG"

    if [ -f "$lower_file" ]; then
        echo "Found in lower" >> "$LOG"
    else
        echo "Not found in lower" >> "$LOG"
    fi

    if [ -f "$merged_file" ]; then
        echo "Unexpected file" >> "$LOG"
    else
        echo "Not found in merge, as expected" >> "$LOG"
    fi

    echo "" >> "$LOG"
done

echo "[DONE] $LOG"

