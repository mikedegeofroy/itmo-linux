#!/bin/bash

filename="work3.log"

sudo rm -f "$filename"

sudo rm -f "/etc/skel/readme.txt"

sudo usermod -s /bin/bash u1 2>/dev/null

sudo userdel -r u2 2>/dev/null

sudo userdel -r u1 2>/dev/null

sudo groupdel g1 2>/dev/null

sudo groupdel g13 2>/dev/null

sudo gpasswd -d debian g1 2>/dev/null

sudo rm -rf /home/test13

sudo rm -rf /home/test14

sudo rm -rf /home/test15

sudo rm -f /etc/sudoers.d/u1_passwd

echo 'Undone'
