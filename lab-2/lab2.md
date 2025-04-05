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
echo "$(blkid /dev/sdb1 | awk '{print $2}' | tr -d '"')  /mnt/newdisk  ext4  defaults,noexec,noatime  0  2" >> /etc/fstab
```

После запуска команды требуется `reboot`

<img width="638" alt="image" src="https://github.com/user-attachments/assets/5124256f-58a9-4347-bcd3-27188cf18df3" />

<img width="500" alt="image" src="https://github.com/user-attachments/assets/6beff830-dea1-44ba-b15f-6e3579206377" />

## 10. Увеличьте размер раздела и файловой системы до 1 Гб. Проверьте, что размер изменился.

```bash
fdisk /dev/sdb
reboot
df -BG
```

<img width="751" alt="image" src="https://github.com/user-attachments/assets/32009d90-8646-47d2-ae85-28416952613a" />

<img width="687" alt="image" src="https://github.com/user-attachments/assets/70a53031-fc91-44ca-8ffc-bfd3ff0b6c3a" />

## 11. Проверьте на наличие ошибок созданную файловую системы "в безопасном режиме", то есть в режиме запрета внесения каких-либо изменений в файловую систему, даже если обнаружены ошибки.

<img width="751" alt="image" src="https://github.com/user-attachments/assets/6a6456dd-dd76-4ebd-b832-02d50d8573e7" />


## 12. Создайте новый раздел, размером в 12 Мбайт. Настройте файловую систему, созданную в пункте 3 таким образом, чтобы ее журнал был расположен на разделе, созданном в этом пункте.

```bash
fdisk /dev/sdb
umount /mnt/newdisk
mke2fs -O journal_dev -b 4096 /dev/sdb2
reboot
```

<img width="853" alt="image" src="https://github.com/user-attachments/assets/98133bff-01b7-46b8-bddb-52efd3edafc3" />

> Тут есть ошибка, забыл указать размер, переделал, видно будет на след скрине.

<img width="625" alt="image" src="https://github.com/user-attachments/assets/19b1e129-6885-4ed7-9da3-a0b44c43237c" />

<img width="503" alt="image" src="https://github.com/user-attachments/assets/b8a39efc-5ac2-4a36-9bc6-f456353a842d" />


## 13. Создайте на 2 и 3-м добавленном диске разделы, занимающие весь диск. Инициализируйте для LVM все созданные разделы.

```bash
fdisk /dev/sdc
fdisk /dev/sdd
pvcreate /dev/sdc1 /dev/sdd1
```
<img width="744" alt="image" src="https://github.com/user-attachments/assets/23ee98ae-cc04-44cd-8a5d-c66fbaa623ef" />
<img width="755" alt="image" src="https://github.com/user-attachments/assets/2956e24b-33a5-4684-b914-f56083913be0" />
<img width="589" alt="image" src="https://github.com/user-attachments/assets/8ce809f7-452a-43be-b960-8d3f8b74ce58" />

## 14. На дисках 2 и 3 создайте чередующийся LVM том и файловую систему ext4 на весь том.

```bash
vgcreate vg_data /dev/sdc1 /dev/sdd1
lvcreate --type striped -i 2 -l 100%VG -n lv_striped vg_data
sudo mkfs.ext4 /dev/vg_data/lv_striped
```

<img width="748" alt="image" src="https://github.com/user-attachments/assets/3a5816da-104f-47e5-8b2e-89dc3e34793f" />

## 15. Смонтируйте том в каталог /mnt/vol01 и настройте автомонтирование.

```bash
mkdir /mnt/vol01
mount /dev/vg_data/lv_striped /mnt/striped
echo "/dev/vg_data/lv_striped /mnt/vol01 ext4 defaults 0 2" >> /etc/fstab
```

<img width="757" alt="image" src="https://github.com/user-attachments/assets/b5864882-9adc-4bfd-8ecc-601716411117" />

## 16. Получите информацию LVM о дисках, volume group и volume.

```bash
pvs
vgs
lvs
```

<img width="1092" alt="image" src="https://github.com/user-attachments/assets/70465c90-6ff5-4ead-a1ca-be0287dd87f0" />

## 17. Расширьте раздел на дополнительный диск используя туже volume group, что и в п. 14. Расширьте том на 100% нового диска.

```
fdisk /dev/sde
pvcreate /dev/sde1
vgextend vg_data /dev/sde1
sudo pvs /dev/sde1
```
<img width="592" alt="image" src="https://github.com/user-attachments/assets/4af7f8da-ed6b-40df-be22-9de5459b0812" />

## 18. Расширьте файловую систему на 100% нового диска (обратите внимание, что вам не пришлось отмонтировать раздел)

<img width="761" alt="image" src="https://github.com/user-attachments/assets/27409b77-31d3-48d0-946e-dde6c23c5812" />





