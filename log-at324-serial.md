# Serial

Connecting the AT324 to the computer was more trouble than expected

Windows 11 is incompetently designed and doen't load the driver

Key registers didn't help, doesn't load the driver

Two of my adapters don't work

Luckily the FTDI 232 does have a WIN11 blessed driver

[Blessed driver for FTDI232](https://ftdichip.com/drivers/)

Connecting the AT324 to the robot regulator, the programmer, the scope and the FTDI chip to the computer. Using UART0 PD1 TXO to send

![](/Images/2025-11-09-T1210_AT324_Serial_Scope.jpg)

Checking with scope that it works

![](/Images/2025-11-09-T1210_at324_scope_send_z.png)

FTDI chip

![](/Images/2025-11-09_12_16_IMG_20251109_121659.jpg)

Checking rx and tx. Sent SHAKA, and the firmware does send it back one at a time, I'm unloading it slowly for some reason, that's fine it's just done quick to work, the peripheral drivers I wrote a long while ago seems to work!

![](/Images/2025-11-09-T1212_At324_pc_receive_z_ftdi.png)