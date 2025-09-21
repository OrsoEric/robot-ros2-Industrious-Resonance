# Serial Ports

The Latte Panda Mu and the Lite Carrier boards have a number of serial interfaces

I need to find out how they are mapped to linux ubuntu and how to use them

# Dev Tree

```
sona@sona-lp-n100-8gb:~$ ls /dev/
autofs           i2c-7         nvme0     tty24  tty59      ttyS6
block            i2c-8         nvme0n1   tty25  tty6       ttyS7
btrfs-control    i2c-9         nvram     tty26  tty60      ttyS8
bus              initctl       port      tty27  tty61      ttyS9
char             input         ppp       tty28  tty62      udmabuf
console          kmsg          psaux     tty29  tty63      uhid
core             kvm           ptmx      tty3   tty7       uinput
cpu              log           pts       tty30  tty8       urandom
cpu_dma_latency  loop0         random    tty31  tty9       userfaultfd
cuse             loop1         rfkill    tty32  ttyprintk  userio
disk             loop10        rtc       tty33  ttyS0      vcs
dma_heap         loop11        rtc0      tty34  ttyS1      vcs1
dri              loop2         shm       tty35  ttyS10     vcs2
drm_dp_aux0      loop3         snapshot  tty36  ttyS11     vcs3
ecryptfs         loop4         snd       tty37  ttyS12     vcs4
fb0              loop5         stderr    tty38  ttyS13     vcs5
fd               loop6         stdin     tty39  ttyS14     vcs6
full             loop7         stdout    tty4   ttyS15     vcsa
fuse             loop8         tpm0      tty40  ttyS16     vcsa1
gpiochip0        loop9         tpmrm0    tty41  ttyS17     vcsa2
hidraw0          loop-control  tty       tty42  ttyS18     vcsa3
hidraw1          mapper        tty0      tty43  ttyS19     vcsa4
hpet             mcelog        tty1      tty44  ttyS2      vcsa5
hugepages        mei0          tty10     tty45  ttyS20     vcsa6
hwrng            mem           tty11     tty46  ttyS21     vcsu
i2c-0            mmcblk0       tty12     tty47  ttyS22     vcsu1
i2c-1            mmcblk0boot0  tty13     tty48  ttyS23     vcsu2
i2c-10           mmcblk0boot1  tty14     tty49  ttyS24     vcsu3
i2c-11           mmcblk0p1     tty15     tty5   ttyS25     vcsu4
i2c-12           mmcblk0p2     tty16     tty50  ttyS26     vcsu5
i2c-13           mmcblk0rpmb   tty17     tty51  ttyS27     vcsu6
i2c-14           mqueue        tty18     tty52  ttyS28     vfio
i2c-15           mtd           tty19     tty53  ttyS29     vga_arbiter
i2c-2            mtd0          tty2      tty54  ttyS3      vhci
i2c-3            mtd0ro        tty20     tty55  ttyS30     vhost-net
i2c-4            net           tty21     tty56  ttyS31     vhost-vsock
i2c-5            ng0n1         tty22     tty57  ttyS4      zero
i2c-6            null          tty23     tty58  ttyS5      zfs
```

ttySxxx should be serial interfaces, on the pi they are also mapped to ttyAMAxxx

```
PermissionError: [Errno 13] Permission denied: '/dev/ttyS1'
```

