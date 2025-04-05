# Лабораторная Работа 4
__Выполнил: де Джофрой Мишель, М3308__

## Часть 1. Получение информацию о времени загрузки.

### 1.1 Выведите информацию о времени, затраченном на загрузку системы

```bash
systemd-analyze
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/729ca070-cf7e-47ff-9341-720e88b6f922" />

### 1.2 Выведите список всех запущенных при страте системы сервисов, в
порядке уменьшения времени, затраченного на загрузку сервиса

```bash
systemd-analyze blame
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/e11a47f0-0635-4822-afe2-e075206202e8" />

### 1.3 Выведите список сервисов, запуск которых с необходимостью предшествовал запуску сервиса sshd.

```bash
systemctl list-dependencies sshd --before
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/696bef09-2243-40b6-8eea-ad7bb1a4f4c8" />

### 1.4 Сформируйте изображение в формате svg с графиком загрузки системы сохраните его в файл.

```bash
systemd-analyze plot > boot.svg
```

## Часть 2. Управление юнитами.

### 2.1 Получите список всех запущенных юнитов сервисов

```bash
systemctl list-units --type=service --state=running
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/84ca9ea3-b1cd-4c7a-b15f-fed5bfa820e2" />

### 2.2 Выведите перечень всех юнитов сервисов, для которых назначена автозагрузка

```bash
systemctl list-unit-files --type=service --state=enabled
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/7b76d565-8292-4112-b42b-a1ce6447da94" />

### 2.3 Определите от каких юнитов зависит сервис sshd

```bash
systemctl list-dependencies sshd
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/81310f3b-35ea-427a-932b-4120d6e6fcde" />

### 2.4 Определите запущен ли сервис cron, если нет, запустите его

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/fa75f96d-95f4-4377-b9e7-8ecc434ee1a5" />

### 2.5 Выведите все параметры юнита cron, даже те, которые были назначены автоматически, и не были прописаны в файле юнита

```bash
systemctl show -a cron
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/bcf42930-c70b-46db-8b19-cb442575348f" />

### 2.6 Запретите автозагрузку сервиса cron, но оставите ему возможность запускаться по зависимостям

```bash
systemctl disable cron
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/2c434a27-5c13-4a7d-9aea-6e1733e74787" />

## Часть 3. Создание сервиса

### 3.1 Создайте собственный сервис mymsg. Сервис mymsg должен: 1) при старте системы записывать в системный журнал дату и время 2) должен запускаться только если запущен сервис network

```bash
vim  /etc/systemd/system/mymsg.service
```

```bash
[Unit]
Description=message service
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo "MyMsg Service started at $(date)" | systemd-cat -t mymsg'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/c5be841f-eefe-40e3-a2f5-9942766cf82b" />

### 3.2 Настройте автоматический запуск сервиса mymsg при старте системы

```bash
systemctl enable mymsg
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/6288eb29-cab4-4d68-88a7-f80c9fc52754" />


## Часть 4. Работа с системным журналом

### 4.1 Выведите на консоль системный журнал. Убедитесь, что сервис mymsg отработал корректно

```bash
journalctl
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/2bd47507-fbe8-473e-81f7-b92607eea1a5" />


<img width="1092" alt="image" src="https://github.com/user-attachments/assets/d84aa25b-cc36-48b7-85a0-88597f14b820" />


### 4.2 Выведите на консоль все сообщения системного журнала, касающиеся сервиса mymsg

```bash
journalctl -t mymsg
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/5fa3ac33-6999-449a-a67a-8fa3a1a21762" />

### 4.3 Выведите на экран все сообщения об ошибках в журнале

```bash
journalctl -p 3
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/9916907a-b85e-494e-993d-5af69836e71d" />

### 4.4 Определите размер журнала

```
journalctl --disk-usage
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/ff84e5d2-16e7-4287-8eac-e0efd4be4ed0" />

## Часть 5. Создание и настройка .mount юнита

### 5.1 Подготовьте файловую систему:
- Создайте новый раздел на диске или используйте существующий
- отформатируйте его в файловую систему ext4.
- Создайте директорию для монтирования /mnt/mydata

```bash
fdisk /dev/sdb
lsblk
mkfs.ext4 /dev/sdb1
mkdir /mnt/mydata
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/0907e32b-49fc-49f8-9f5e-e006a199b840" />

### 5.2 Создание .mount юнита

- Создайте файл .mount юнита в /etc/systemd/system/mnt-mydata.mount.
- Настройте юнит следующим образом:
    - Добавьте описание юнита в секцию [Unit].
    - В секции [Mount] укажите устройство, точку монтирования, тип файловой системы и опции.
    - В секции [Install] укажите, что юнит должен быть активирован при достижении multi-user.target.
- Сохраните файл и выйдите из редактора

```bash
vim /etc/systemd/system/mnt-mydata.mount
```

```bash
[Unit]
Description=Mount Unit
After=local-fs.target
Requires=local-fs.target

[Mount]
What=/dev/sdb1
Where=/mnt/mydata
Type=ext4
Options=defaults

[Install]
WantedBy=multi-user.target
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/7d11050f-0ffe-4f14-9542-d96995898332" />

### 5.3 Запуск и проверка .mount юнита

- Включите и запустите юнит.
- Проверьте статус юнита.
- Убедитесь, что раздел смонтирован.

```bash
systemctl daemon-reload
systemctl enable mnt-mydata.mount
systemctl status mnt-mydata.mount
mount | grep /mnt/mydata
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/49369393-0dac-4c6e-afea-a7bb7343988d" />

## Часть 6. Использование .automount для отложенного монтирования

### 6.1 Подготовьте соответствующий .mount-юнит

- После выполнения Части 5 у вас должен был остаться юнит для монтирования /mnt/mydata
- Убедитесь, что при остановке раздел отмонтируется, а монтируется обратно только при запуске юнита или перезагрузке системы

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/c08cdeba-0937-4ed3-b70d-d55ede21a1f5" />

### 6.2 Создание .automount юнита

- Создайте файл .automount юнита в /etc/systemd/system/mnt-mydata.automount.
- Настройте юнит следующим образом:
    - Добавьте описание юнита в секцию [Unit].
    - В секции [Automount] точку монтирования и время до размонтирования (TimeoutIdleSec)
    - В секции [Install] укажите, что юнит должен быть активирован при достижении multi-user.target.
- Сохраните файл и выйдите из редактора

```bash
vim /etc/systemd/system/mnt-mydata.automount
```

```bash
[Unit]
Description=Automount Unit

[Automount]
Where=/mnt/mydata
TimeoutIdleSec=60

[Install]
WantedBy=multi-user.target
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/171b1101-3efe-4b33-b745-9eae7a6c378d" />

### 6.3 Запуск и проверка .automount юнита

- Включите и запустите .automount юнит.
- Проверьте статус юнита и убедитесь, что раздел монтируется при обращении к точке монтирования.
- Убедитесь, что раздел размонтируется после завершения работы

```bash
systemctl daemon-reload
systemctl enable mnt-mydata.automount
systemctl start mnt-mydata.automount
systemctl status mnt-mydata.automount
```


<img width="1092" alt="image" src="https://github.com/user-attachments/assets/7e33ff54-1b04-4620-8458-fd06c6da572f" />


```bash
mount | grep mydata
ls /mnt/mydata
mount | grep mydata
```

через таймаут

```bash
mount | grep mydata
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/79217c1b-be67-4f96-84c4-a6593b7ae5fc" />

## Вопросы и задания






