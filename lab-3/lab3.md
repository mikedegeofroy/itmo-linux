<img width="1092" alt="image" src="https://github.com/user-attachments/assets/52584a61-8cc8-4aa8-af2c-67b274f62970" /># Лабораторная Работа 3
__Выполнил: де Джофрой Мишель, М3308__

## 1. Выведите список всех подключенных репозитариев

```bash
cat /etc/apt/sources.list
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/b3f8cdd9-20aa-4e92-b0f6-f7be81fd0928" />

## 2. Обновите локальные индексы пакетов в менеджере пакетов

```bash
sudo apt update
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/30aa8e3b-4c58-4474-b89e-9f92c83f3efe" />


## 3. Выведите информацию о метапакете build-essential

```bash
sudo apt show build-essential
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/7345b26e-581f-4666-9ebe-4a4293f33d69" />

## 4.Установите метапакет build-essential, при этом определите какие компоненты будут установлены, а какие обновлены

```bash
sudo apt install build-essential --simulate
sudo apt install build-essential
```

<img width="675" alt="image" src="https://github.com/user-attachments/assets/1587223b-4874-42ac-8730-3b8d87da2302" />

## 5. Найдите пакет, в описании которого присутствует строка «clone with a bastard algorithm»

```bash
sudo apt search "clone with a bastard algorithm"
```
<img width="1092" alt="image" src="https://github.com/user-attachments/assets/7fefada7-52a3-4c69-995f-b636e704b684" />

## 6. Скачайте в отдельную директорию в домашнем каталоге архив с исходными кодами найденного в п.5 пакета

```bash
apt source bastet
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/d2275a52-e14b-4a38-ab1a-2147d5a088a1" />

## 7. Установите пакет из исходных кодов, скаченных в п.6

```bash
sudo apt update
sudo apt install libboost-dev libncurses5-dev libncursesw5-dev libboost-program-options-dev -y

make
make all
```

## 8. Если в конфигурационном файле пакета нет параметров установки пакета в систему, то добавьте их, так, чтобы пакет устанавливался в /usr/local/bin и на него назначались права ---rwxr-xr-x. Проверьте выполнения этих директив.

Добавил install, хотя чисто в принципе можно было самому переместить готовый бинарник куда надо.

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/db0308c5-98ed-44ba-84ae-d55e1143052b" />

Круто, убил час на тетрис)

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/920451dc-6ceb-4983-8858-e60c78a8cbce" />

## 9. Проверьте, что любой пользователь может запускать установленный пакет, но не тратьте на это более 5 минут

```
sudo adduser debian2
su - debian2
bastet
```
  
<img width="1092" alt="image" src="https://github.com/user-attachments/assets/8ef4082d-17ab-4f0e-9246-5d813d27a996" />

## 10. Создайте файл task10.log, в который выведите список всех установленных пакетов.

```
apt list --installed > task10.log
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/d9a8f0db-d1a7-4a28-b9f9-3e944deb7459" />

## 11. Создайте файл task11.log, в который выведите список всех пакетов (зависимостей), необходимых для установки и работы компилятора gcc.

```
apt-cache depends gcc > task11.log
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/9c73ae9c-5718-4e9b-a5b1-7372f164e8b6" />


## 12. Создайте файл task12.log, в который выведите список всех пакетов (зависимостей), установка которых требует установленного пакета libgpm2.

```
apt-cache rdepends libgpn2 > task12.log
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/aa64c9fb-131b-41e4-908d-451ba2516806" />

## 13. Создайте каталог localrepo в домашнем каталоге пользователя root и скопируйте в него c сайта http://snapshot.debian.org/package/htop/ пять разных версий пакета htop. Это можно сделать с помощью wget или просто передав файлы на виртуальную машину используя протокол ssh и утилиту scp

```bash
mkdir localrepo
wget https://snapshot.debian.org/archive/debian/20250312T144852Z/pool/main/h/htop/htop_3.4.0-2_arm64.deb
wget https://snapshot.debian.org/archive/debian/20240113T150425Z/pool/main/h/htop/htop_3.3.0-2_arm64.deb
wget https://snapshot.debian.org/archive/debian/20220502T205642Z/pool/main/h/htop/htop_3.2.0-1_amd64.deb
wget https://snapshot.debian.org/archive/debian/20050312T000000Z/pool/main/h/htop/htop_0.5-1_arm.deb
wget https://snapshot.debian.org/archive/debian/20180427T151608Z/pool/main/h/htop/htop_2.2.0-1_arm64.deb
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/5abe708f-fce5-41b2-b547-dd1829d0e79b" />

## 14. Сгенерируйте в каталоге репозитория файл Packages, который будет содержать информацию о доступных пакетах в репозитории и Создайте файл Release, содержащий описание репозитория

```bash
dpkg-scanpackages --multiversion . /dev/null > Packages
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/a1f769ca-3819-467d-9ba7-571ab11cc00b" />

## 15. Обновите кэш apt

```
apt update
```

## 16. Выведите список подключенных репозитариях и краткую информацию о них.

```bash
cat /etc/apt/sources.list
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/f0fa8de4-bec6-48ac-a9df-300a85d83e33" />

## 17. Создайте файл task16.log в который выведите список всех доступных версий htop

```
apt-cache madison htop > task16.log
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/dddb316b-1e8e-4f2b-baea-12ce7a367902" />

## 18. Установите предпоследнюю версию пакета

```bash
apt install htop=3.2.2-2
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/f464fb55-fdc0-4bd4-aca8-4394c6b88463" />

## 19. Скачайте из сетевого репозитория пакет nano. Пересоберите пакет таким образом, чтобы после его установки, появлялась возможность запустить редактор nano из любого каталога, введя команду newnano. Для работы с пакетом следует использовать dpkg-deb, а для установки dpkg. В файле протокола работы опишите использованные команды.

```bash
mkdir newnano
wget https://ftp.debian.org/debian/pool/main/n/nano/nano_8.3-1_arm64.deb
dpkg-deb -R nano_8.3-1_arm64.deb nano-package
cd nano-package/usr/bin
mv nano newnano
cd ../../..
vim nano-package/DEBIAN/control
dpkg-deb -b nano-package newnano.deb
sudo dpkg -i newnano.deb
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/3c72d56d-b582-4a5c-83db-7456ddb62c4f" />

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/a10a51e5-d0de-4f59-846d-35de98eac902" />

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/c422e4b3-5455-4c67-b510-b1c6415b79c2" />


## ### 20. Бонусный вопрос с подвохом - что есть в APT?

apt - обертка над apt-get, apt-cache, dpkg, debconf, apt-key и другими пакетами. А так там можно найти все что нужно)

