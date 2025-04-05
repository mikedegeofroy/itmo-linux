# Лабораторная Работа 5
__Выполнил: де Джофрой, Мишель__

> поторопился, не понял, что ID -> последние 2 цифры ИСУ (пробежался глазами)... Сделал 42, должен был быть 3455**70**. В рамках текущей ЛР `ID = 42` (выбрано на угад, но в основном как ответ на «главный вопрос жизни, Вселенной и всего такого» — 42, отссылка к «Путеводитель для путешествующих автостопом по галактике»)

## 1. Квоты на процессор для конкретного пользователя (cgroups v2):

### 1.1 Создайте пользователя: user-ID (например, user-72).

```
useradd user-42
```

### 1.2 Назначьте квоту процессора на основе номера пользователя:
- Если имя пользователя заканчивается на **0-30**: 30% CPU.
- Если имя пользователя заканчивается на **31-70**: 50% CPU.
- Если имя пользователя заканчивается на **71-99**: 70% CPU.

```bash
apt-get install cgroup-tools

mkdir /sys/fs/cgroup/user-42
echo "50000 100000" | sudo tee /sys/fs/cgroup/user-42/cpu.max
```

## 2. Ограничение памяти для процесса (cgroups):

### 2.1 Создайте cgroup для ограничения памяти, потребляемой процессом

```bash
cgcreate -g memory:/cg42
```

### 2.2 Ограничьте потребление памяти следующим образом: ID*10 + 500 МБ (например, ID=23 → 730 МБ).

LIMIT_MB=$((42 * 10 + 500))   # → 920
LIMIT_BYTES=$((LIMIT_MB * 1024 * 1024))  # → 964689920

```bash
cgset -r memory.limit_in_bytes=964689920 cg42
```

### 2.3 Запустите процесс и переместите его в созданную вами группу.

```
cgexec -g memory:cg42 tail -f /dev/zero &
```

### 2.4 Проверьте, что при исчерпании памяти процессом он прерывается ОС.

```
dmesg | tail -n 20
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/19190ff2-de20-47e3-aa77-3491a18a77a5" />

## 3. Ограничение дискового ввода-вывода для сценария резервного копирования (cgroups)

### 3.1 Скрипт резервного копирования (backup.sh) перегружает дисковую подсистему.

### 3.2 Ограничьте его до:
- Чтение: 1000 + <ID>*10 IOPS. (1420 IOPS)
- Запись: 500 + <ID>*10 IOPS. (920 IOPS)

### 3.3 Ограничьте его до:

```bash
cgcreate -g blkio:/backup
cgset -r blkio.throttle.read_iops_device="8:0 1420" backup
cgset -r blkio.throttle.write_iops_device="8:0 920" backup
```

### 3.4 Протестируйте с помощью fio или dd.

```bash
sudo apt install fio

fio --name=normal --rw=read --bs=4k --size=100M --filename=/tmp/testfile --runtime=10

sudo cgexec -g blkio:backup fio --name=limited --rw=read --bs=4k --size=100M --filename=/tmp/testfile2 --runtime=10

```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/50d136d4-b5a2-48c4-9d95-453994528d8f" />

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/c2a0556b-5da9-4888-9c00-a381be2da6a3" />

> Видим что при запуске первой команды — IOPS=291k, при запуске второй IOPS=110k

## 4. Закрепление к определенному ядру процессора для приложения

### 4.1 Настройте с помощью cgroups процесс команды top за процессором 0.

### 4.2 Используйте cpuset.cpus в cgroups.

### 4.3 Проверьте с помощью taskset -p <PID>. (требуется пакет sysstat)

```bash
cgcreate -g cpuset:/topgroup
cgset -r cpuset.cpus=0 topgroup
cgexec -g cpuset:topgroup top -b > temp.txt &
taskset -p 1409
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/90c8079b-67f3-4975-b71c-ea82555a2763" />

## 5. Динамическая корректировка ресурсов (cgroups)

### 5.1 Напишите сценарий для мониторинга нагрузки по CPU и динамического изменения cpu.max определенного процесса (его идентификатор задается как входной параметр скрипта).

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/6e93a37b-c942-4af3-9c6a-d99cdb2d053e" />

> Можно посмотреть сам скрипт в репозитории

### 5.2 Квота ЦП для процесса должна регулироваться в зависимости от общей нагрузки на систему:

  - Низкая нагрузка (CPU < 20%): 80% CPU.
  - Высокая нагрузка (CPU > 60%): 30% CPU.
    
<img width="1092" alt="image" src="https://github.com/user-attachments/assets/52ac1aa0-4fa6-4c0f-8217-0ffe93895dac" />

## 6. Создание изолированного имени хоста (пространство имен UTS)

### 6.1 Запустите оболочку (shell/bash) в отдельном namespace, в которой можно изменить имя хоста, не затрагивая хост.

### 6.1 Измените имя хоста внутри пространства имен на isolated-student-<ID>.

### 6.3 Проверьте изоляцию:
  - hostname # Должно отображаться «isolated-student-».
  - Проверьте имя хоста (в новом терминале): hostname
По-прежнему показывает оригинальное имя хоста.

```bash
unshare --uts --fork bash
hostname isolated-student-42
hostname

hostname
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/9cd23cc2-9133-4ae7-9060-134e6b176310" />

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/4387f5dd-40c7-4c6b-a48d-34ed877e25c1" />

## 7. Изоляция процессов (пространство имен PID)

### 7.1 Создайте пространство имен, в котором процессы хоста будут невидимы:
`unshare --pid --fork bash`

### 7.2 Смонтируйте новый каталог /proc:
`mount -t proc proc /proc`

### 7.3 Проверьте процессы:
`ps aux` # Показывает только 2-3 процесса (например, bash, ps).

### 7.4 Сравните с хостом (в новом терминале):
`ps aux` # Показывает все процессы хоста.

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/f6d0fe03-bc35-4476-a790-adedc3884d73" />

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/225695b2-ea42-4b41-b4e7-a80aee99283e" />

## 8. Изолированная файловая система (пространство имен Mount)

### 8.1 Создайте каталог, видимый только в пространстве имен:
`unshare --mount bash`

### 8.2 Создайте приватный каталог:
`mkdir /tmp/private_$(whoami)`

### 8.3 Смонтируйте временную файловую систему:
`mount -t tmpfs tmpfs /tmp/private_$(whoami)`

### 8.4 Проверьте изоляцию:
`df -h | grep private_$(whoami)` # Запишите в отчет результат.

### 8.5 Проверка на хосте (в новом терминале):
`df -h | grep private_$(whoami)`

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/1e1a456b-a2bd-49c8-bbe2-b12312102646" />

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/3b3467ed-72d7-4639-8a28-93eef4faacd9" />

## 9. Отключение доступа к сети (пространство имен Network)

### 9.1 Запустите командный интерпретатор bash без доступа к сети.
`unshare --net bash`

### 9.2 Проверьте сетевые интерфейсы:
`ip addr` # Запишите в отчет, что показывает команда.

### 9.3 Проверьте подключение:
`ping google.com`

### 9.3 Сравните с хостом (в новом терминале):
`ping google.com`

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/178b3c3d-167d-475b-96d4-1bb2839bc1c7" />

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/8716d6b9-19b6-415e-995b-d4baec15bc2a" />

## 10. Создайте и проанализируйте монтирование OverlayFS

#### Шаги:  
**a. Первоначальная настройка:**  

- Создайте каталоги:  
  ```bash
  mkdir -p ~/overlay_42/{lower,upper,work,merged}
  ```
  
- В каталоге `lower` создайте файл с именем `42_original.txt` с содержанием:  
  ```text
  Оригинальный текст из LOWER
  ```  
- Смонтируйте OverlayFS:  
  ```bash
  mount -t overlay overlay -o lowerdir=~/overlay_42/lower,upperdir=~/overlay_42/upper,workdir=~/overlay_42/work ~/overlay_42/merged
  ```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/5cce1e04-fa80-44c7-9b2b-cbf58d3b6d5c" />

**b. Имитация неполадки и отладка:**  
- Удалите файл `42_original.txt` из каталога `merged`.  
- Понаблюдайте: Какой файл(ы) появился(ись) в верхнем каталоге? Задокументируйте их имена и содержимое.  
- Измените каталог `merged`, чтобы *восстановить* `42_original.txt`, не размонтируя и не изменяя нижний уровень.

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/ce1d454c-20f4-410d-b6a2-d2fccfa27b9b" />

**c. Разработайте скрипт, который:**  
- Обнаруживает все `whiteout` файлы в верхнем каталоге `upper`.  
- Сравнивает содержимое нижнего и объединенного для выявления несоответствий.  
- Выводит отчет с именем `42_audit.log`.

```bash
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

    echo "Found whiteout: $whfile" >> "$LOG"

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
```

**d. Ответьте на вопросы:**  
- Как OverlayFS скрывает файлы из нижнего слоя при удалении в объединенном?

При удалении в merged слое, в слое lower (физическом) файлы не удаляются. В upper добавляется специальный whiteout файл, который прячет файл из lower слоя.
 
- Если вы удалите рабочий каталог `work`, сможете ли вы перемонтировать оверлей? Объясните, почему.

Если мы удалим work (вспомогательный каталог), то мы не сможем перемонтировать оверлей, т.к. он требует наличие lower, upper, work для инициализации

- Что произойдет с объединенным слоем, если верхний каталог будет пуст?

Если каталог upper пуст ⇒ нет whiteout файлов ⇒ в каталоге merged просто показываются все файлы из lower

## 11. Оптимизируйте Dockerfile для приведенного ниже приложения app.py

`app.py:`
```python
from flask import Flask
import socket
import os
app = Flask(__name__)
@app.route('/')
def container_info():
		# Get container IP
		hostname = socket.gethostname()
		ip_address = socket.gethostbyname(hostname)
		# Get student name from environment variable
		student_name = os.getenv('STUDENT_NAME', 'Rincewind')
		return f"Container IP: {ip_address} Student: {student_name}"
if __name__ == '__main__':
		app.run(host='0.0.0.0', port=5000)
```

`Dockerfile`
```Dockerfile
FROM python:latest
COPY . /app
WORKDIR /app
RUN pip install flask
CMD ["python", "app.py"]
```

**Улучшите Dockerfile с учетом лучших практик:**

- Используйте меньший базовый образ.
- Зафиксируйте версию образа.
- Запуск от имени пользователя, не являющегося root.
- Используйте кэширование слоев для зависимостей.
- Добавьте файл .dockerignore.

`Улучшенный Dockerfile:`
```Dockerfile
FROM python:3.11-slim

RUN useradd -m user1

COPY --chown=user1:user1 req.txt .
RUN pip install --no-cache-dir -r req.txt

COPY --chown=user1:user1 . /app
WORKDIR /app

USER user1

CMD ["python", "app.py"]
```

`.dockerignore`
```
__pycache__
*.pyc
*.pyo
*.pyd
.Python
env
pip-log.txt
pip-delete-this-directory.txt
.tox
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.log
.git
.mypy_cache
.pytest_cache
.hypothesis
```

## 12. Установка платформы публикации WordPress с помощью Docker Compose

**Задача:**  
Создать `docker-compose.yml` для запуска WordPress и MySQL/MariaDB с сохранением состояния при перезапуске контейнеров.  

**Используйте:**  
- Порт `<ID>+2000` для WordPress (например, ID = 65 → port = 2065).  
- Пароль базы данных: `[ваше_имя]_db_pass`.  
- Том с именем `[ваше_имя]-wp-data` для WordPress.

`docker-compose.yaml:`
```yaml
services:
  db:
    image: mysql:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: mike_db_pass
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: mike_db_pass
    volumes:
      - db-data:/var/lib/mysql

  wordpress:
    image: wordpress:latest
    restart: always
    depends_on:
      - db
    ports:
      - "2042:80"
    volumes:
      - wp-data:/var/www/html
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: mike_db_pass
      WORDPRESS_DB_NAME: wordpress

volumes:
  db-data:
  wp-data:
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/db1905d3-772a-4f72-8757-72ee382d0e1e" />

