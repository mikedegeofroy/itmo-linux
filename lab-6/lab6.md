# Лабораторная Работа 6
__Выполнил: де Джофрой Мишель, М3308__

Проблема:

Система застряла в boot loop, не может запуститься.

<img width="832" alt="image" src="https://github.com/user-attachments/assets/96f2d57d-0181-43c3-bb41-d0b10367d21b" />

Что я сделал:

1) Зашел в систему через recovery mode
2) ```systemctl get-default```
3) ```systemctl set-default multi-user.target```
4) ```ip a - заметим, что интерфейс не поднят```
5) ```ip link set enp0s1 up```
6) ```dhclient enp0s1```
7) ```apt update```
8) ```apt upgrade```
9) ```apt install --reinstall systemd bash login coreutils```
10) ```reboot```

окей, это раобтает, но почему?
