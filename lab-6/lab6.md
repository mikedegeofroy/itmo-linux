# Лабораторная Работа 6
__Выполнил: де Джофрой Мишель, М3308__

Проблема:

Система застряла в boot loop, не может запуститься.

<img width="832" alt="image" src="https://github.com/user-attachments/assets/96f2d57d-0181-43c3-bb41-d0b10367d21b" />

Что я сделал:

1) Зашел в систему через recovery mode
2) ```systemctl get-default```
  <img width="729" alt="image" src="https://github.com/user-attachments/assets/1feee0cd-8ea8-4cbc-80dc-94fa637d244e" />
4) ```systemctl set-default multi-user.target```
5) ```ip a - заметим, что интерфейс не поднят```
6) ```ip link set enp0s1 up```
7) ```dhclient enp0s1```
8) ```apt update```
9) ```apt upgrade```
10) ```apt install --reinstall systemd bash login coreutils```
11) ```reboot```

окей, это раобтает, но почему?
