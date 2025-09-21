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

# Format NVME

This being linux, it's not easy to format a drive and use it

First enumerate the drives

```
lsblk
```

![](/Images/2025-09-20-T1106%20Enumerate%20Drives.jpg)

Our target is the 256GB drive root ```nvme0n1```

Now that drive needs to be formatted ext4, mounted, and given user permission to be used, then create a folder for LLM models so they reside on the external NVME drive and not the EMMC compute module drive

```
sudo umount /dev/nvme0n1

sudo mkfs.ext4/nvme0n1

mount | grep ext4

ls -ld /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0

sudo chown -R sona:sona /media/sona/

ls -ld /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0

mkdir /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0/models_llm

ls /media/sona/fe4d92e2-b743-4576-b445-e47f511902d0

```

![](/Images/2025-09-20-T1108%20Format%20EXT4.jpg)

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

LM Studio being competently made, uses a llama cpp Vulkan runtime that works out of the box

![](/Images/2025-09-20-T1144%20LM%20Studio%20Inference.jpg)

Performance is around 3T/s in answer speed for Qwen 3 4B Q4M, I did expect it to be faster, but it's miles faster than a Pi would be, I'll do further testing.

With this 8GB model, I have 4GB allocated to the iGPU. In theory, 8B Q3 should run.

TODO: Test OpenVINO runtimes and ollama and raspberry for comparison

# Raspicam (FAIL)

The Latte Panda Mu has a MIPI CSI 2 interface. I connected the raspicam, and it doesn't boot. I was afraid of having bricked everything, but disconnecting the raspicam makes it boot.

![](/Images/2025-09-20-T1222%20Raspicam.jpg)


# TODO

### Test UART Ports