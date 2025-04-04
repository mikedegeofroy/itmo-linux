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

echo "Done"
