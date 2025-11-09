# robot-ros2-Industrious-Resonance
Constructing a ROS2 robot to experiment with using LLMs as poors man AGI. 

# SPECS

- moving by sunday 2025-08-24 
- uses the raspberry pi
    - runs Ubuntu 22
    - runs ROS2
- uses OrangeHat
- uses 18650 battieries
- sensors
    - Raspicam
    - Microphone
- actuators    
    - two main motors
    - Loudspeaker
- options:
    - screen

# Old Robots

Census of old robots

## JetBot-00 (2021-09)

This is a robot I assembled to test the Jetson Nano.

It powered up, moved motors has screen and a supply. I should disassemble it, the Jetson Nano is too small to run competent AI with 2GB RAM. The Jetson Nano also uses a custom linux with binary blobs and not a real linux.

![2021-09-JetBot-00-TOP](/Images/2019-05%20Jetbot00%20Top.jpg)

![2021-09-JetBot-00-BOT](/Images/2019-05%20Jetbot00%20Bottom.jpg)

I can technically mount a raspberry and make a robot out of it.

## OrangeBot (2020-10)

Large robot for the Pi Wars with DC Motors with Encoders. It's high spec but not suitable for this project.

![OrangeBot Pi Wars 2020](/Images/2023.jpg)

## Unnamed Lego Robot

This is a good effort to make a raspberry pi lego robot.

![Unnamed Lego Robot](/Images/2025-08-23-Unnamed%20Lego%20Robot.jpg)

# ROBOT 

I choose to start from the LEGO robot, it should be very close to working

## Mechanical

Using OpenSCAD to design the base

### Ball Holder

As pivot wheel, I think of using a 40mm tennis ball. I can make a 3D printed structure to hold it with low friction, I'm thinking of three holding arms and three structural arms. I went with OpenSCAD to make it

![](/Images/Design-Ball-Holder.png)

https://github.com/user-attachments/assets/4e690c88-9136-435e-aecc-3a0f2ad5ae8a

### Servo Holder

I reused some of my previous work but decided I should do pillars without overhangs since I'm printing them on the robot platform

![](/Images/2025-08-27_16_07_servo_pillars.jpg)

### Shell

Using Flux to generate possible images for the shell

Below is an idea I like that plays on the industrious resonance name, a shell that is weavy with interference patterns and a frontal lens

![](/Art/Shell_t6.png)


### Platform

![](/Images/2025-08-27T1725-Platform-norpi-nobat-noraspi.png)


### Assembly 

Place a raspberry, batteries and servomotors on an ellipse

![](/Images/2025-08-27-T083848%20OpenSCAD%20WIP.png)

Considerations
- I switch to a Latte Panda MU to improve on LLM performance
- In the future I do a proper LPMU carry board
- I need to think of battery holder

Base is a rectangle with tounded corner. Developed servo pillars, used 18650 battery holder and ping pong ball holder for pivot.

![](/Images/2025-11-07-T1749_Base_2P2S.png)

With the Lattepanda Mu electronics on top and base properly resized to carry it

![](/Images/2025-11-06-T1735_lpmu_assembly.png)

Considerations:
- Batteries are hard to reach, I'd like bottom facing battery holder, but how would supports work?
- I need a camara stand
- I need lips to attach a shell, or a border
- I need to decide on the electronics and spaces to platce that electronics
- I need to improve on the LPMU pillars, I need to make them through hole to the bottom
- I need a power switch

---

Lots of work on the robot
- 18650 inverse holder 2S2P, connected 4S1P
- border
- hole for switch
- support for regulator PCB
- hex nuts below for the lattepanda

I printed it in opaline PETG with supports, it came out really well! Tollerances for the battery holders are perfect!

![](/Images/2025-11-08-T2104_assembled_powered_above.jpg)

![](/Images/2025-11-08-T2104_assembled_powered_below.jpg)

Video of the assembly Process

[Github is incompetently made and I have no way to embed a video bigger than 10MB](https://github.com/orgs/community/discussions/19403)

The video will work when you fork and open with VS Code with the preview MD. Otherwise download it and watch it.

[Link to the video of the assembly process of the battery and regulator](/Videos/2025-11-08-T2103_assembly_battery_regulator_480p.mp4)


## Electronics

### Raspberry Pi

It uses an OrangeHat, I remember it has a screen, UART, reset, and SERVO interpolation, it should be good to do a two axis rotation. It has an IMU, and the front numbers show change when I move it, it might be working!

I remember that if the OS isn't running, it keeps reset the OrangeHat and it stays offline, it's a deliberate design decision that works, it's why it wasn't showing anything.

Power regulator is good.

![Test OrangeHat Electronics](/Images/2025-08-23_T0956%20Test%20orangeHat.jpg)

### Lattepanda Mu

Using the Lattepanda Mu I need a different electronics setup

I think I'll do a Longan Nano because of the screen, use one of my regulators, and an adapter to connect the servomotors. Feels like a good experimental setup without committing too much

I would like encoders on the motors...

### Servomotors - Longan Nano

I need a board to move the servomotors and have a screen.

First choice was the Longan Nano, it's compact, powerful and has a nice screen and I deed lots of drivers.

[Longan Nano](https://fatherofmachines.blogspot.com/p/longan-nano-gd32vf103.html)

I tried and it's bricked on Platform IO. I can probably make it work.

[](/log-longan-nano.md)

### Servomotors - AT324PA

I made useful boards based on AT324 and others, the one from Unit Zero has already the servo adapters and works fine.

[Install Microchip Studio](https://www.microchip.com/en-us/tools-resources/develop/microchip-studio#Downloads), open project, recompile and upload, everything works!

![](/Images/2025-11-09-T0953_AT324_electronics_avrispmk2_programmer.jpg)

From here I need a firmware with the parser and uart in order to control it from an SBC

I'm thinking of doing it simple, possibly a mov speed duration instruction, that is very easy for the MCP server to produce, even if not very useful for doing useful applications. This is just an MVP.

## Firmware

SPECS:
- UART link
- Parser
- Ability to move servos
- Ability to display text on the screen


### Serial Commands

OrangeHat is programmed with the following functions

```
ARG_S8 = 's',
ARG_U8 = 'u',
ARG_S16 = 'S',
ARG_U16 = 'U',
ARG_U32 = 'D',
ARG_S32 = 'd'

//Register ping command. It's used to reset the communication timeout
f_ret = parser_tmp.add_cmd( "P", (void *)&ping_handler );
//Register the Find command. Board answers with board signature
f_ret |= parser_tmp.add_cmd( "F", (void *)&send_signature_handler );
//Platform set PPM command
f_ret |= parser_tmp.add_cmd( "PPM%u:%S:%S", (void *)&set_servo_ppm );
```

### Protocol





---

## Operating System and Raspicam Streaming

Now I need to choose a Raspberry and setup the OS.

I do have a Raspberry with Hailo 8L and raspiocam streaming already setup, test that instead, it saves lots of work!


![](Images/2025-08-23_T1034%20Test%20RPI5%20Hailo.jpg)

Power is good, now try with ping, putty and launching the streaming demo and enumerating the Hailo

- ETH0 (static): 192.168.1.65 
- User: raspi
- Password: raspi

![](Images/2025-08-23_T1034%20Test%20RPI5%20Hailo%20Putty.png)

![](Images/2025-08-23_T1034%20Test%20RPI5%20Hailo%20Webserver.jpg)

TODO: Do I really want to move to Ubuntu and have ROS2? If I'm already good like this perhaps I should drop the ROS2 requirement

### Raspberry Pi 5

Test that the power supply is good
- 10V 0.5A streaming with camera and connected via webserver

Connect with VS Code Remote

Make an application that clears the reset 

