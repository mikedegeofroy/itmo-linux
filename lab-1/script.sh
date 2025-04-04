#!/bin/bash

filename="work3.log"

echo "User, Id" > "$filename"

while IFS=: read -r username _ uid _ _ _ _
do
  echo "$username, $uid" >> "$filename"
done < /etc/passwd

last_change_date=$(sudo chage -l root | awk -F': ' '/Last password change/ {print $2}')

echo -e "\n\nLast root password change: $last_change_date" >> "$filename"

echo -e "\n\nGroups" >> "$filename"

groups=""
for group in $(cut -d: -f1 /etc/group); do
  if [ -z "$groups" ]; then
    groups="$group"
  else
    groups="$groups, $group"
  fi
done
echo "$groups" >> work3.log

sudo echo "Be careful!" > "/etc/skel/readme.txt"

sudo useradd -m u1
echo "u1:12345678" | sudo chpasswd

sudo groupadd g1

sudo usermod -aG g1 u1

u1_uid=$(id -u u1)
u1_name=$(id -nu u1)
u1_group_uids=$(id -G u1)
u1_group_names=$(id -Gn u1)

{
  echo "UID: $u1_uid"
  echo "Name: $u1_name"
  echo "Group UIDs: $u1_group_uids"
  echo "Group Names: $u1_group_names"
} >> "$filename"

sudo usermod -aG g1 debian

users_in_g1=$(getent group g1 | cut -d: -f4)

echo "Users in g1: $users_in_g1" >> "$filename"

sudo usermod -s /usr/bin/mc u1

sudo useradd -m u2
echo "u2:87654321" | sudo chpasswd

sudo mkdir -p /home/test13
sudo cp "$filename" /home/test13/work3-1.log
sudo cp "$filename" /home/test13/work3-2.log

sudo groupadd g13

sudo usermod -aG g13 u1
sudo usermod -aG g13 u2

sudo chown -R u1:g13 /home/test13
sudo chmod 750 /home/test13

sudo chmod 640 /home/test13/work3-1.log
sudo chmod 640 /home/test13/work3-2.log

sudo mkdir -p /home/test14
sudo chown u1:u1 /home/test14

sudo chmod 1777 /home/test14

sudo cp /usr/bin/nano /home/test14/nano
sudo chown u1:u1 /home/test14/nano

sudo chmod 4755 /home/test14/nano

sudo mkdir -p /home/test15
sudo chown root:root /home/test15

sudo chmod 711 /home/test15

sudo echo "secret" > "/home/test15/secret_file"
sudo chown root:root /home/test15/secret_file

sudo chmod 644 /home/test15/secret_file

echo "u1 ALL=(root) NOPASSWD: /usr/bin/passwd [A-Za-z0-9_]*" > "/etc/sudoers.d/u1_passwd"
sudo chmod 440 /etc/sudoers.d/u1_passwd

echo "Done"
