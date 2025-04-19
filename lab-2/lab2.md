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
vgextend vg_data /dev/sde1 /dev/sde2
lvextend -i 2 -l +100%FREE /dev/vg_data/lv_striped
```

<img width="1009" alt="image" src="https://github.com/user-attachments/assets/c6b694f1-4f16-4d0d-b2d5-60bac2793e95" />

> Пришлось пару раз переделать, тк lvs почему-то не показывал, как используются все дкиски, теперь вот

<img width="1112" alt="image" src="https://github.com/user-attachments/assets/b49c9842-37fa-45c8-a678-711527f7d3a9" />


## 18. Расширьте файловую систему на 100% нового диска (обратите внимание, что вам не пришлось отмонтировать раздел)

```bash
resize2fs /dev/vg_data/lv_striped
```

<img width="994" alt="image" src="https://github.com/user-attachments/assets/191ad9ec-1db9-4cba-a24a-d51058fa9e35" />

## 19. Получите информацию LVM о дисках, volume group и volume.

```bash
pvs
vgs
lvs
```

<img width="1112" alt="image" src="https://github.com/user-attachments/assets/a8483466-a242-49ee-98df-5f7cd248003b" />

## 20. На машине server установите службу nfs-kernel-server, разрешите запуск и запустите ее.

```bash
apt install nfs-kernel-server
systemctl enable nfs-server
```

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/ae6781f5-aa6e-4bfb-a299-d7bb074bc75f" />

## 21. Сделайте так, чтобы к каталогу /mnt/vol01 можно было получить доступ через NFS, при этом установите параметры, которые:
### a. Разрешают доступ к каталогу только с IP адресов сети ваших виртуальных машин.
### b. Разрешают монтировать каталог для записи.

```bash
sudo useradd nfsnobody
sudo chown nfsnobody:nfsnobody /mnt/vol01

id nfsnobody

echo "/mnt/vol01 192.168.100.1/24(rw,sync,no_subtree_check,anonuid=1001,anongid=1001)" >> /etc/exports
exportfs -a
```

## 22. На компьютере client осуществите монтирование сетевого ресурса в каталог /var/remotenfs.

```bash
apt install nfs-common
sudo mount -t nfs 192.168.100.1:/mnt/vol01 /var/remotenfs
```

## 23. Убедитесь, что монтирование удалось. Скопируйте в каталог remotenfs любой файл.

```bash
sudo touch banana
ls -l /var/remotenfs
```

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/7d67fe9a-d95a-4632-bda0-8cd1590fea81" />

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/3265ccd6-fcaa-4ea2-a470-9333f591dc62" />

## 24. Получите информацию о inode любого файла, выведите информацию о логическом размещении файла на диске

```bash
sudo stat /var/remotenfs/banana
sudo filefrag -e /var/remotenfs/banana
```

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/e6d3779c-1ac4-4936-8d62-ac6bf7f1c2ea" />


## 25. Создайте мягкую и жесткую ссылки на файл, посмотрите информацию о их логическом расположении, inode, найдите отличия и сходства, чем они объясняются

```bash
ln /mnt/vol01/banana /mnt/vol01/banana_hard
ln -s /mnt/vol01/banana /mnt/vol01/banana_soft
```

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/3487bf0c-b97f-493a-85a0-b88e9ca8a564" />

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/dc1a1540-765f-412b-97ad-8da6f3674757" />

<img width="1063" alt="image" src="https://github.com/user-attachments/assets/f86b1553-4791-4e3c-99d8-ea7de23c85e3" />

Отличия:

- Имеют разные права доступа (у softlink 777)
- hardlink и test.txt имеют одинаковый inode, а у softlink inode другой



