# Лабораторная Работа 5
__Выполнил: де Джофрой, Мишель__

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



