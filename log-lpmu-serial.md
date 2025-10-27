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

sona@sona-lp-n100-8gb:~$ ls -l /dev/ttyS0
crw-rw---- 1 root dialout 4, 64 Sep 21 09:09 /dev/ttyS0

```

permission for those ports is group dialout, so I add those permissions to my user

```
sudo usermod -a -G dialout $USER
sudo reboot
```

## Python

```
#!/usr/bin/python
#----------------------------------------------------------------
# IMPORTS
#----------------------------------------------------------------

import logging
import time
import serial
import struct

#----------------------------------------------------------------
# MAIN
#----------------------------------------------------------------

if __name__ == '__main__':
    # Initialize logs
    logging.basicConfig(
        level=logging.INFO,
        format='[%(asctime)s] %(levelname)s %(module)s:%(lineno)d > %(message)s ',
    )
    logging.info("Starting serial port scan")

    ln_working_ports = list()

    # Iterate through ttyS0 to ttyS30
    for port_num in range(31):
        port = f'/dev/ttyS{port_num}'
        try:
            logging.info(f"Attempting to open {port}")
            gcl_ser = serial.Serial(
                port=port,
                baudrate=115200,
                parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE,
                bytesize=serial.EIGHTBITS,
                timeout=0,
                write_timeout=1.0
            )
            gcl_ser.reset_input_buffer()
            gcl_ser.reset_output_buffer()
            logging.info(f"Successfully opened {port}")
            print(f"Serial: {gcl_ser}")

            x_continue = True
            while x_continue:
                if gcl_ser.is_open:
                    sb_message = f"TEST MESSAGE to port {port_num}"
                    print(f"SEND >{sb_message}<")
                    n_byte_sent = gcl_ser.write(sb_message.encode())
                    gcl_ser.close()

                    ln_working_ports.append(port_num)
                else:
                    x_continue = False
                    print("CLOSED")
                time.sleep(0.5)

        except serial.SerialException as e:
            logging.error(f"Failed to open {port}: {e}")
            if gcl_ser and gcl_ser.is_open:
                gcl_ser.close()
            continue

    print(f"Working ports: {ln_working_ports}")



``` 

With permissions solved, modify the script to scan the ports

```
sona@sona-lp-n100-8gb:~$ python3 Projects/test_serial.py 
[2025-09-21 13:12:10,196] INFO test_serial:21 > Starting serial port scan 
[2025-09-21 13:12:10,196] INFO test_serial:29 > Attempting to open /dev/ttyS0 
[2025-09-21 13:12:10,196] INFO test_serial:41 > Successfully opened /dev/ttyS0 
Serial: Serial<id=0x735859b30580, open=True>(port='/dev/ttyS0', baudrate=115200, bytesize=8, parity='N', stopbits=1, timeout=0, xonxoff=False, rtscts=False, dsrdtr=False)
SEND >TEST MESSAGE to port 0<
CLOSED
[2025-09-21 13:12:11,200] INFO test_serial:29 > Attempting to open /dev/ttyS1 
[2025-09-21 13:12:11,201] ERROR test_serial:59 > Failed to open /dev/ttyS1: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:11,201] INFO test_serial:29 > Attempting to open /dev/ttyS2 
[2025-09-21 13:12:11,201] ERROR test_serial:59 > Failed to open /dev/ttyS2: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:11,201] INFO test_serial:29 > Attempting to open /dev/ttyS3 
[2025-09-21 13:12:11,201] ERROR test_serial:59 > Failed to open /dev/ttyS3: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:11,201] INFO test_serial:29 > Attempting to open /dev/ttyS4 
[2025-09-21 13:12:11,202] INFO test_serial:41 > Successfully opened /dev/ttyS4 
Serial: Serial<id=0x735859a901f0, open=True>(port='/dev/ttyS4', baudrate=115200, bytesize=8, parity='N', stopbits=1, timeout=0, xonxoff=False, rtscts=False, dsrdtr=False)
SEND >TEST MESSAGE to port 4<
CLOSED
[2025-09-21 13:12:12,206] INFO test_serial:29 > Attempting to open /dev/ttyS5 
[2025-09-21 13:12:12,207] INFO test_serial:41 > Successfully opened /dev/ttyS5 
Serial: Serial<id=0x735859a8cd90, open=True>(port='/dev/ttyS5', baudrate=115200, bytesize=8, parity='N', stopbits=1, timeout=0, xonxoff=False, rtscts=False, dsrdtr=False)
SEND >TEST MESSAGE to port 5<
CLOSED
[2025-09-21 13:12:13,212] INFO test_serial:29 > Attempting to open /dev/ttyS6 
[2025-09-21 13:12:13,212] INFO test_serial:41 > Successfully opened /dev/ttyS6 
Serial: Serial<id=0x735859a8cf10, open=True>(port='/dev/ttyS6', baudrate=115200, bytesize=8, parity='N', stopbits=1, timeout=0, xonxoff=False, rtscts=False, dsrdtr=False)
SEND >TEST MESSAGE to port 6<
CLOSED
[2025-09-21 13:12:14,218] INFO test_serial:29 > Attempting to open /dev/ttyS7 
[2025-09-21 13:12:14,218] ERROR test_serial:59 > Failed to open /dev/ttyS7: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,219] INFO test_serial:29 > Attempting to open /dev/ttyS8 
[2025-09-21 13:12:14,219] ERROR test_serial:59 > Failed to open /dev/ttyS8: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,219] INFO test_serial:29 > Attempting to open /dev/ttyS9 
[2025-09-21 13:12:14,219] ERROR test_serial:59 > Failed to open /dev/ttyS9: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,220] INFO test_serial:29 > Attempting to open /dev/ttyS10 
[2025-09-21 13:12:14,220] ERROR test_serial:59 > Failed to open /dev/ttyS10: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,220] INFO test_serial:29 > Attempting to open /dev/ttyS11 
[2025-09-21 13:12:14,220] ERROR test_serial:59 > Failed to open /dev/ttyS11: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,220] INFO test_serial:29 > Attempting to open /dev/ttyS12 
[2025-09-21 13:12:14,221] ERROR test_serial:59 > Failed to open /dev/ttyS12: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,221] INFO test_serial:29 > Attempting to open /dev/ttyS13 
[2025-09-21 13:12:14,221] ERROR test_serial:59 > Failed to open /dev/ttyS13: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,221] INFO test_serial:29 > Attempting to open /dev/ttyS14 
[2025-09-21 13:12:14,222] ERROR test_serial:59 > Failed to open /dev/ttyS14: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,222] INFO test_serial:29 > Attempting to open /dev/ttyS15 
[2025-09-21 13:12:14,222] ERROR test_serial:59 > Failed to open /dev/ttyS15: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,222] INFO test_serial:29 > Attempting to open /dev/ttyS16 
[2025-09-21 13:12:14,222] ERROR test_serial:59 > Failed to open /dev/ttyS16: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,222] INFO test_serial:29 > Attempting to open /dev/ttyS17 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS17: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,223] INFO test_serial:29 > Attempting to open /dev/ttyS18 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS18: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,223] INFO test_serial:29 > Attempting to open /dev/ttyS19 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS19: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,223] INFO test_serial:29 > Attempting to open /dev/ttyS20 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS20: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,223] INFO test_serial:29 > Attempting to open /dev/ttyS21 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS21: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,223] INFO test_serial:29 > Attempting to open /dev/ttyS22 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS22: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,223] INFO test_serial:29 > Attempting to open /dev/ttyS23 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS23: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,223] INFO test_serial:29 > Attempting to open /dev/ttyS24 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS24: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,223] INFO test_serial:29 > Attempting to open /dev/ttyS25 
[2025-09-21 13:12:14,223] ERROR test_serial:59 > Failed to open /dev/ttyS25: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,224] INFO test_serial:29 > Attempting to open /dev/ttyS26 
[2025-09-21 13:12:14,224] ERROR test_serial:59 > Failed to open /dev/ttyS26: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,224] INFO test_serial:29 > Attempting to open /dev/ttyS27 
[2025-09-21 13:12:14,224] ERROR test_serial:59 > Failed to open /dev/ttyS27: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,224] INFO test_serial:29 > Attempting to open /dev/ttyS28 
[2025-09-21 13:12:14,224] ERROR test_serial:59 > Failed to open /dev/ttyS28: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,224] INFO test_serial:29 > Attempting to open /dev/ttyS29 
[2025-09-21 13:12:14,224] ERROR test_serial:59 > Failed to open /dev/ttyS29: Could not configure port: (5, 'Input/output error') 
[2025-09-21 13:12:14,224] INFO test_serial:29 > Attempting to open /dev/ttyS30 
[2025-09-21 13:12:14,224] ERROR test_serial:59 > Failed to open /dev/ttyS30: Could not configure port: (5, 'Input/output error') 
Working ports: [0, 4, 5, 6]

```

I was able to open with success: 

```
Working ports: [0, 4, 5, 6]
```

Now I can make a script to send data through those ports, and see with an oscilloscope if something goes through

# Python Send

Script to send messages via serial interface. Change the port number to the ones found above.

```
#!/usr/bin/python
#----------------------------------------------------------------
# IMPORTS
#----------------------------------------------------------------

import logging
import time
import serial
import struct

#Measure TX, RX is the same port

#THis port is marked Debug on the lite board
N_PORT = 0

#near the CR battery, marked 0
#N_PORT = 4

#near the CR battery, marked 1
#N_PORT = 5

#near the CR battery, marked 2
#N_PORT = 6

#----------------------------------------------------------------
# MAIN
#----------------------------------------------------------------

if __name__ == '__main__':
    # Initialize logs
    logging.basicConfig(
        level=logging.INFO,
        format='[%(asctime)s] %(levelname)s %(module)s:%(lineno)d > %(message)s ',
    )
    logging.info("Send")


    n_cnt = 0

    port = f'/dev/ttyS{N_PORT}'
    try:
        logging.info(f"Attempting to open {port}")
        gcl_ser = serial.Serial(
            port=port,
            baudrate=115200,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            bytesize=serial.EIGHTBITS,
            timeout=0,
            write_timeout=1.0
        )
        gcl_ser.reset_input_buffer()
        gcl_ser.reset_output_buffer()
        logging.info(f"Successfully opened {port}")

        x_continue = True
        while x_continue:
            if gcl_ser.is_open:
                sb_message = f"TEST MESSAGE >{n_cnt}<"
                n_cnt = n_cnt +1
                print(f"SEND >{sb_message}<")
                n_byte_sent = gcl_ser.write(sb_message.encode())

            else:
                print("CLOSED")
                x_continue = False
            time.sleep(0.5)

    except serial.SerialException as e:
        logging.error(f"Failed to open {port}: {e}")
        if gcl_ser and gcl_ser.is_open:
            gcl_ser.close()
        


```

# Oscilloscope

Now that I found responsive ports, I use an oscilloscope to measure where the signals come out.

I setup the 10X attenuation on the probe, I use the yellow wire of the fan to see if the scope works. I activate the serial decoder, and tune it to scale when I found it. Remember that idle is high.

Then I probe the TX pins, and voila, they are all there!

![](/Images/2025-09-21-T1332%20Measured%20Serial%20Port%20Mapping%20to%20Ubuntu%20Dev.png)

![](/Images/2025-09-21-T1328%20Oscilloscope%20Reading.png)