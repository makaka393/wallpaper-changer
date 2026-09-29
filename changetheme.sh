#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Использование: changetheme.sh <путь_к_обоям>"
    exit 1
fi

WALLPAPER=$(realpath "$1")
[ -f "$WALLPAPER" ] || { echo "Файл не найден: $WALLPAPER"; exit 1; }

if ! awww query > /dev/null 2>&1; then
    awww-daemon &
    sleep 0.5
fi

awww img "$WALLPAPER" --transition-fps 60 --transition-type wipe

wallust run "$WALLPAPER" --palette dark16
sed -i 's/#//g' ~/.cache/wallust/colors-hyprland.conf

hyprctl reload

pkill -SIGUSR1 kitty 2>/dev/null || true
pkill -x btop 2>/dev/null || true
