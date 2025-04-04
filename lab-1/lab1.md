# Лабораторная Работа 1
__Выполнил: де Джофрой Мишель, M3308__

## 1)	выводит в файл work3.log построчно список всех пользователей в системе в следующем формате: «user NNN has id MM»;

```bash
#!/bin/bash

filename="work3.log"

echo "user {user} has id {id}" > "$filename"

while IFS=: read -r username _ id _ _ _ _
do
  echo "user $username has id $id" >> "$filename"
done < /etc/passwd
```

> Данные о пользователей и их id можно найти в файле /etc/passwd

## 2)	добавляет в файл work3.log строку, содержащую дату последней смены пароля для пользователя root;

```bash
last_change_date=$(sudo chage -l root | awk -F': ' '/Last password change/ {print $2}')

echo -e "\n\nLast root password change: $last_change_date" >> "$filename"
```

> Команда `chage -l {user}` дает данные о пароля пользователя, также команда `chage` позволяет настроить уведомления и обязательные изменения паролья для пользователя.


## 3)	добавляет в файл work3.log список всех групп в системе (только названия групп) через запятую;

```bash
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
```

> В файле `/etc/groups` хранятся сведения о группах

## 4)	делает так, чтобы при создании нового пользователя у него в домашнем каталоге создавался файл readme.txt с текстом «Be careful!»;

```bash
sudo echo "Be careful!" > "/etc/skel/readme.txt"
```

> Под `/etc/skel` хранится дефолтная файловая стрктура для пользователей, добавля туда файл `readme.txt` он будет присутствовать в домашней директории пользователей созданных с этого момента.

## 5)	создает пользователя u1 с паролем 12345678;

```bash
sudo useradd -m u1
echo "u1:12345678" | sudo chpasswd
```

> Надеюсь тут пояснений не надо, название команд сами за себя говорят

## 6)	создает группу g1;

```bash
sudo groupadd g1
```

> `groupadd`, `useradd` создают пользователей и групп.

## 7)	делает так, чтобы пользователь u1 дополнительно входил в группу g1;

```bash
sudo usermod -aG g1 u1
```

> `usermod -aG` -> user modify, add group 

## 8)	добавляет в файл work3.log строку, содержащую сведения об идентификаторе и имени пользователя u1 и идентификаторах и именах всех групп, в которые он входит;

```bash

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

```

> как раз команда `id` дает возможность получать эти сведения, прикольно научился выводить (было лень каждый раз прописывать, загуглил как вместе сделать)

## 9)	делает так, чтобы пользователь myuser дополнительно входил в группу g1 (если пользователя нет, то создайте его вручную);

```bash
sudo usermod -aG g1 debian
```

> Тут `myuser` -> debian

## 10)	добавляет в файл work3.log строку с перечнем пользователей в группе g1 через запятую;

```bash
users_in_g1=$(getent group g1 | cut -d: -f4)

echo "Users in g1: $users_in_g1" >> "$filename"
```

> `getent` - позволяет удобно выводить сведения в `/etc/*.` то есть например `getent passwd root` вывалит сведения о пользователe `root` в `/etc/passwd`

## 11)	делает так, что при входе пользователя u1 в систему вместо оболочки bash автоматически запускается /usr/bin/mc, при выходе из которого пользователь возвращается к вводу логина и пароля (если пакета mc нет, то отдельно установите его вручную);

```bash
sudo usermod -s /usr/bin/mc u1
```

## 12)	создает пользователя u2 с паролем 87654321;

```
sudo useradd -m u2
echo "u2:87654321" | sudo chpasswd
```

## 13)	в каталоге /home создает каталог test13, в который копирует файл work3.log два раза с разными именами (work3-1.log и work3-2.log);

```
sudo mkdir -p /home/test13
sudo cp "$filename" /home/test13/work3-1.log
sudo cp "$filename" /home/test13/work3-2.log
```

> Тут надо через sudo, тк `home` домашняя директория `root`

## 14)	сделает так, чтобы пользователи u1 и u2 смогли бы просматривать каталог test13 и читать эти файлы, только пользователь u1 смог бы изменять и удалять их, а все остальные пользователи системы не могли просматривать содержимое каталога test13 и файлов в нем. При этом никто не должен иметь права исполнять эти файлы;

> Тут отталкиваюсь от того, что проще всего

```bash
sudo groupadd g13

sudo usermod -aG g13 u1
sudo usermod -aG g13 u2

sudo chown -R u1:g13 /home/test13
sudo chmod 750 /home/test13

sudo chmod 640 /home/test13/work3-1.log
sudo chmod 640 /home/test13/work3-2.log
```

> `chown` - change owner, `chmod` - change mode, поменять владельца и поменять права доступа. 











