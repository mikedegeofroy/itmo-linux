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







