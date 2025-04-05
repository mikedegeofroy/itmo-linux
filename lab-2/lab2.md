# Лабораторная Работа 2
__Выполнил: де Джофрой Мишель, M3308__

<img width="720" alt="image" src="https://github.com/user-attachments/assets/117954d1-cf4e-4bd5-b9e1-cd9b9189fc0d" />

<img width="1495" alt="image" src="https://github.com/user-attachments/assets/1e16c14e-5bed-423f-a1a7-3c07d94c99c7" />

## 1. На первом добавленном диске создайте новый раздел, начинающийся с первого свободного
сектора и имеющий размер 500 МБайт.

```bash
sudo fdisk /dev/sdb
```

<img width="761" alt="image" src="https://github.com/user-attachments/assets/53d287b3-49f8-42ac-9f8c-7ff18e3599c2" />


## 2. Создайте файл в домашнем каталоге пользователя root и сохраните в него UUID созданного
раздела.

```bash
touch uuid.txt
blkid -s PARTUUID -o value /dev/sdb1 > uuid.txt
```

## 3. Создайте на созданном разделе файловую систему ext4 с размером блока 4096 байт.

```bash
mkfs.ext4 -b 4096 /dev/sdb1
```

<img width="736" alt="image" src="https://github.com/user-attachments/assets/451a8172-0541-4055-8335-c6a19d1f0a13" />

## 4. Выведите на экран текущее состояние параметров, записанных в суперблоке созданной файловой
системы.

```bash
tune2fs -l /dev/sdb1
```

<img width="747" alt="image" src="https://github.com/user-attachments/assets/674e0752-2a30-4efc-8453-c8d067fc2d40" />

## 5. Настройте эту файловую систему таким образом, чтобы ее автоматическая проверка запускалась через 2 месяца или каждое второе монтирование файловой системы.

```bash
tune2fs -i 2m -c 1 /dev/sdb1
```

<img width="611" alt="image" src="https://github.com/user-attachments/assets/3e54a98d-43a6-4032-a6bb-baef3c5c4b15" />


## 6. Создайте в каталоге /mnt подкаталог newdisk и подмонтируйте в него созданную файловую
систему.

```bash
mkdir /mnt/newdisk
mount /dev/sdb1 /mnt/newdisk
```

<img width="509" alt="image" src="https://github.com/user-attachments/assets/e78e8ef7-ca41-4e7f-b8f7-a1151b64f262" />

## 7. Создайте в домашнем каталоге пользователя root ссылку на смонтированную файловую систему

```bash
ln -s /mnt/newdisk /root/newdisk_link
```

<img width="597" alt="image" src="https://github.com/user-attachments/assets/9f986b1b-04cc-4b05-8fec-4d4360d44e5f" />

## 8. Создайте каталог с любым именем в смонтированной файловой системе.

<img width="461" alt="image" src="https://github.com/user-attachments/assets/fa8301ff-6ec4-426f-b6e8-f136defb3d0f" />

## 9. Включите автомонтирование при запуске операционной системы созданной файловой системы в /mnt/newdisk таким образом, чтобы было невозможно запускать исполняемые файлы, находящиеся в этой системе, а также с отключением возможности записи времени последнего доступа к файлу для ускорения работы с этой файловой системой. Перезагрузите операционную систему и проверьте доступность файловой системы. Проверьте невозможность запустить исполняемый файл, если он хранится в этой файловой системе.

```bash
echo "$(blkid /dev/sdb1 | awk '{print $2}' | tr -d '"')  /mnt/newdisk  ext4  defaults,noexec,noatime  0  2" | tee -a /etc/fstab
```

После запуска команды требуется `reboot`



