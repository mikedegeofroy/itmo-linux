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

> создаем группу g13, добавляем туда u1 и u2  
> дальше делаем u1 владельцем каталога, а группу — g13  
> права на каталог — 750:
> - u1 может всё  
> - u2 (через группу) может зайти и читать  
> - остальные не могут ничего

> права на файлы — 640:  
> - u1 может читать и редактировать  
> - u2 только читать  
> - никто не может исполнять

## 15) создает в каталоге /home каталог test14, в который любой пользователь системы сможет записать данные, но удалить любой файл сможет только пользователь, который его создал или пользователь u1

> Тут логика как у `/tmp` (sticky bit).  
> - Создаем каталог `/home/test14`  
> - Делаем `u1` владельцем (чтобы он мог удалять чужие файлы)  
> - Ставим режим `1777`:  
>   - Любой может записать файл (rwx для всех)  
>   - Но удалить файл может только владелец файла, `u1` (владелец каталога) или `root`.

```bash
sudo mkdir -p /home/test14
sudo chown u1:u1 /home/test14
sudo chmod 1777 /home/test14
```

## 16) копирует в каталог test14 исполняемый файл редактора nano и делает так, чтобы любой пользователь смог изменять с его помощью файлы, созданные в пункте 13

> Устанавливаем setuid на `nano`, сделав владельцем `u1`. Тогда при запуске `/home/test14/nano` любой пользователь получит эффективные права `u1` и сможет писать в файлы `/home/test13/`.  
> **Внимание**: реальный сценарий небезопасен, но так по условию задачи.

```bash
sudo cp /usr/bin/nano /home/test14/nano
sudo chown u1:u1 /home/test14/nano
sudo chmod 4755 /home/test14/nano
```

## 17) создает каталог test15 и создает в нем текстовый файл /test15/secret_file. Делает так, чтобы содержимое этого файла можно было вывести на экран, только зная имя файла, но узнать имена файлов в каталоге кроме как подбором было бы невозможно

> Ставим на каталог `711`:  
> - у владельца (root) полный доступ,  
> - у всех остальных только `x` (чтобы можно было зайти, зная имя),  
> - нет права `r` на каталог (нельзя сделать `ls`).  
> Файл при этом открыт на чтение (`644`), так что, зная точное имя, его можно прочитать, а `ls /home/test15` не покажет список.

```bash
sudo mkdir -p /home/test15
sudo chown root:root /home/test15
sudo chmod 711 /home/test15

sudo echo "secret" > "/home/test15/secret_file"
sudo chown root:root /home/test15/secret_file
sudo chmod 644 /home/test15/secret_file
```

## 18) Настроить sudo таким образом, чтобы пользователь u1 смог с помощью sudo и команды passwd менять пароли другим пользователям, но не смог бы использовать другие утилиты от имени root

> Создаем файл `/etc/sudoers.d/u1_passwd` и даем права `440`.  
> - `u1 ALL=(root) NOPASSWD: /usr/bin/passwd [A-Za-z0-9_]*`  
> Это означает, что `u1` может использовать `sudo passwd {any_user}`, но ничего другого.

```bash
echo "u1 ALL=(root) NOPASSWD: /usr/bin/passwd [A-Za-z0-9_]*" > "/etc/sudoers.d/u1_passwd"
sudo chmod 440 /etc/sudoers.d/u1_passwd
```

> Теперь `u1` может, например, `sudo passwd u2` без ввода пароля. При попытке `sudo nano ...` или любой другой команды от root система скажет "Sorry, user u1 is not allowed...".  
> Таким образом, только `passwd` доступен пользователю `u1` от имени root.


nb:

0 bit - sticky bit (suid, выполнять файл только с разрешениями владельца файла, sgid выполнять файл только с разрешениями группы файла)

1 bit - owner rules
2 bit - group rules
3 bit - the rest of the people rules

