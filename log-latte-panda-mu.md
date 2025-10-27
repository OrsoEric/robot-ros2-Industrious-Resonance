# Unboxing N305 16GB (2025-08-25)

Seems bricked. I can force the power rails of the lite board on, but there is a regulator on the Mu whose power rails never go up, no matter what.

![](/Images/2025-08-25-T1924%20Unboxing%20Latte%20Panda%20Mu%20N305%2016GB.jpg)

# Unboxing N100 8GB (2025-09-20)

From Mouser got an N100 8GB, this powers on just fine and boots into a windows 11

![](/Images/2025-09-20-T0802%20Power%20On%20N100%208GB.jpg)

Requires screen mouse and keyboard to operate

Screen I used the touch screen I built for the Jetson Nano 2GB robot a while ago.

I got some cheap NVME M.2 256GB PCIe 3.0 4X

I connected the ethernet, and it works just fine, no issues

![](/Images/2025-09-20-T1015%20Peripherals.jpg)


Notice that there is no WiFI radio there. The board will make use of a M.2 wifi/bluetooth card. I could also use an ESP32 with AT commands.

# Install Ubuntu 24 LTS 

I'm going for a desktop ubuntu for now, since I'm debugging lots of things. I expect the software for the robot to use a ubuntu server instead. Also I plan to use a UART interface for ease.

Used Rufus to burn an ISO of Ubuntu 24 LTS for X86-64 AMD64

[Download ISO](https://ubuntu.com/download/desktop/thank-you?version=24.04.3&architecture=amd64&lts=true)

With the USB burned, go into the bios, and change boot order. My used NVME shows with a random linux burned on it, ignore it.

![](/Images/2025-09-20-T0956%20N100%208GB%20Bios%20Change%20Boot%20Order.jpg)

It's painless to install and boot into ubuntu, on the EMMC 64GB drive, and wipe windows out. Secure Boot was disabled, cart that it could cause issues if active and trying dual boot.

![](/Images/2025-09-20-T1015%20Ubuntu%2024%20Ethernet%20IP.jpg)

# Install Ubuntu Server 24 LTS

[Ubuntu Server 24 ISO Download](https://mirror.dogado.de/ubuntu-releases/24.04.3/ubuntu-24.04.3-live-server-amd64.iso)

Use RUFUS to burn USB key

![](/Images/2025-10-26-T1022%20Burn%20Ubuntu%20Server%2024.png)

Go into bios

Use keyboard and screen

# Format NVME

This being linux, it's not easy to format a drive and use it


My first attempt to format and add the drive, it has some issues like weird folder names

<details>
<summary>2025-09-20 LP NVME Setup</summary>

```
sudo umount /dev/nvme0n1

sudo mkfs.ext4 /nvme0n1

mount | grep ext4

ls -ld /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0

sudo chown -R sona:sona /media/sona/

ls -ld /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0

mkdir /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0/models_llm

ls /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0

```

![](/Images/2025-09-20-T1106%20Enumerate%20Drives.jpg)

![](/Images/2025-09-20-T1108%20Format%20EXT4.jpg)

</details>

New instructions

First enumerate drives

```
lsblk

sona@lpn10016gb:~$ lsblk
mmcblk0      179:0    0  58.2G  0 disk
├─mmcblk0p1  179:1    0     1G  0 part /boot/efi
└─mmcblk0p2  179:2    0  57.2G  0 part /
mmcblk0boot0 179:8    0     4M  1 disk
mmcblk0boot1 179:16   0     4M  1 disk
nvme0n1      259:0    0 238.5G  0 disk
```

Target is the 256GB drive root ```nvme0n1```

Now that drive needs to be formatted ext4, mounted, and given user permission to be used, then create a folder for LLM models so they reside on the external NVME drive and not the EMMC compute module drive

```
sudo umount /dev/nvme0n1

sudo mkfs.ext4 /nvme0n1

lsblk
```



Now create a folder where driver can be mounted and mount the drive

```
ls /mnt/

sudo mkdir /mnt/external_disk

ls /mnt/

sudo mount /dev/nvme0n1 /mnt/external_disk

ls /mnt/

df -h

sudo chown -R sona:sona /mnt/external_disk

touch /mnt/external_disk/test_file.txt

ls /mnt/external_disk/
```

<details>
<summary>2025-10-26 LP NVME Setup LOGS</summary>

```
sona@lpn10016gb:~$ lsblk
mmcblk0      179:0    0  58.2G  0 disk
├─mmcblk0p1  179:1    0     1G  0 part /boot/efi
└─mmcblk0p2  179:2    0  57.2G  0 part /
mmcblk0boot0 179:8    0     4M  1 disk
mmcblk0boot1 179:16   0     4M  1 disk
nvme0n1      259:0    0 238.5G  0 disk

sona@lpn10016gb:~$ sudo mkfs.ext4 /dev/nvme0n1
mke2fs 1.47.0 (5-Feb-2023)
/dev/nvme0n1 contains a ext4 file system
        created on Sun Oct 26 11:03:49 2025
Proceed anyway? (y,N) y
Discarding device blocks: done
Creating filesystem with 62514774 4k blocks and 15630336 inodes
Filesystem UUID: 7e68a2d7-b91a-4a03-bfe4-43aae9666b18
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done

sona@lpn10016gb:~$ lsblk
NAME         MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
mmcblk0      179:0    0  58.2G  0 disk
├─mmcblk0p1  179:1    0     1G  0 part /boot/efi
└─mmcblk0p2  179:2    0  57.2G  0 part /
mmcblk0boot0 179:8    0     4M  1 disk
mmcblk0boot1 179:16   0     4M  1 disk
nvme0n1      259:0    0 238.5G  0 disk

sona@lpn10016gb:~$ ls /mnt/

sona@lpn10016gb:~$ sudo mkdir /mnt/external_disk

sona@lpn10016gb:~$ ls /mnt/
external_disk

sona@lpn10016gb:~$ sudo mount /dev/nvme0n1 /mnt/external_disk

sona@lpn10016gb:~$ ls /mnt/
external_disk

sona@lpn10016gb:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           1.6G  1.7M  1.6G   1% /run
efivarfs        192K   85K  103K  46% /sys/firmware/efi/efivars
/dev/mmcblk0p2   56G  6.7G   47G  13% /
tmpfs           7.7G     0  7.7G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/mmcblk0p1  1.1G  6.2M  1.1G   1% /boot/efi
tmpfs           1.6G   12K  1.6G   1% /run/user/1000
/dev/nvme0n1    234G   28K  222G   1% /mnt/external_disk

sona@lpn10016gb:~$ sudo chown -R sona:sona /mnt/external_disk

sona@lpn10016gb:~$ touch /mnt/external_disk/test_file.txt

sona@lpn10016gb:~$ ls /mnt/external_disk/
lost+found  test_file.txt
```

</details>

With this now I have an external, big, fast drive where I can dump the LLM models

# LLM Inference

The big reason to use the Latte Panda Mu is because Intel, unlike every other manufacturer like AMD, makes drivers for their iGPU, meaning I can theoretically get great performance.


[LM Studio as appimage.](https://installers.lmstudio.ai/linux/x64/0.3.26-6/LM-Studio-0.3.26-6-x64.AppImage)

Now, this being linux, it's not easy to install.

- right click execution permission, or do chmod from command line
- it still fails because there aren't permissions on tmp files (???)
- reboot
- move appimage on a dedicated folder in home
- double click, now after a while it starts

![](/Images/2025-09-20-T1135%20LM%20Studio%20Acceleration.jpg)

Make sure to select the NVME as target folder for the LLMs, I had to redo it after boot, I am not sure why, but the model still works, LM Studio will find them as long as you select the correct folder where to search the models. I suspect user/media changes the hex hash? Not sure.

![](/Images/2025-09-21-T1119%20LLM%20Folder.jpg)

LM Studio being competently made, uses a llama cpp Vulkan runtime that works out of the box

![](/Images/2025-09-20-T1144%20LM%20Studio%20Inference.jpg)

Performance is around 3T/s in answer speed for Qwen 3 4B Q4M, I did expect it to be faster, but it's miles faster than a Pi would be, I'll do further testing.

With this 8GB model, I have 4GB allocated to the iGPU. In theory, 8B Q3 should run.

TODO: Test OpenVINO runtimes and ollama and raspberry for comparison

# Raspicam (FAIL)

The Latte Panda Mu has a MIPI CSI 2 interface. I connected the raspicam, and it doesn't boot. I was afraid of having bricked everything, but disconnecting the raspicam makes it boot.

![](/Images/2025-09-20-T1222%20Raspicam.jpg)


# Remote Desktop (FAIL)

I want to remote into Ubuntu 24 on the LPMU

I tried to install install xrdp, and work out configuration to no avail. 

![](/Images/2025-09-20-T1034%20Remote%20Desktop%20from%20windows%20to%20ubuntu%20fail.jpg)

I think it's missing some shared objects? Not sure. I expected ubuntu to support remote desktop out of the box, and online guides have me install all sort of dependencies and open ports on the firewall that do not work. I can't connect.

# SSH

Again SSH didn't work out of the box, but it was easy to setup

```
sudo apt install openssh-server

sudo systemctl enable ssh

sudo systemctl status ssh

sudo ufw allow ssh

sudo reboot now

```

I can connect easily with Putty

![](/Images/2025-09-20-T1055.png)

# VS Code Remote

Having SSH and having VS Code, I can use my windows VS Code to develop and execute remotely code on the latte panda mu

- VS Code Remote
- On bottom left, there is the connect button
- On top center screen
- connect to host sona@192.168.1.239 
- it'll ask you linux continue, etc...
- if it fails, it's because windows is dumb and incompetent, and stores SSH key base on IP, so if your board moved to another IP, it'll fail. If so, go to user/you/.ssh and wipe the keys stored there known_host


![](/Images/2025-09-21-1202%20VS%20Code%20Remote.png)

On top left, you can open folder, and go to the home folder, and this way you have the terminal into the machine to execute python script, and the file explorer to create folders and script

![](/Images/2025-09-21-1212%20VS%20Code%20Python.png)

# TODO

### Test UART Ports