# Longan Nano

It has a 32bit processor and a screen, it's ideal for this robot

I can also use my AT324 with screen and it would work fine, it's just bigger

## Install


[Official Instruction](https://longan.sipeed.com/en/get_started/pio.html)

[My tests made in 2020](https://fatherofmachines.blogspot.com/p/longan-nano-gd32vf103.html)


### Platform IO

```
Open VSCode -> click on the left extension -> search for PlatformIO -> click install plugin -> wait for the installation to complete -> restart VSCODE
```


### Toolchain (BRICKED)

```
platformio platform install gd32v
```


```
C:\Users\FatherOfMachines>platformio platform install gd32v

WARNING: This command is deprecated and will be removed in the next releases. 
Please use `pio pkg install` instead.

Platform Manager: Installing gd32v
UnknownPackageError: Could not find the package with 'gd32v' requirements for your system 'windows_amd64' 
```

Some research suggest it is bricked, it may be brought back to life but I think I'll just switch microcontroller for this application

https://community.platformio.org/t/could-not-find-the-package-with-gd32v-requirements-for-your-system-windows-amd64/39802/2

https://community.platformio.org/t/i-am-unable-to-install-sipeed-longan-nano-gd32v/34758/24

https://github.com/sipeed/platform-gd32v/issues/40

https://github.com/sipeed/platform-gd32v/issues/40#issuecomment-1880013602