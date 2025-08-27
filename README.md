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

Iterations

![](/Images/2025-08-27-T083848%20OpenSCAD%20WIP.png)

### Ball Holder

As pivot wheel, I think of using a 40mm tennis ball. I can make a 3D printed structure to hold it with low friction, I'm thinking of three holding arms and three structural arms. I went with OpenSCAD to make it

![](/Images/Design-Ball-Holder.png)

![](/Videos/Pivot%20Ball%20Holder.mp4)

### Shell

Using Flux to generate possible images for the shell

Below is an idea I like that plays on the industrious resonance name, a shell that is weavy with interference patterns and a frontal lens

![](/Art/Shell_t6.png)


## Electronics

It uses an OrangeHat, I remember it has a screen, UART, reset, and SERVO interpolation, it should be good to do a two axis rotation. It has an IMU, and the front numbers show change when I move it, it might be working!

I remember that if the OS isn't running, it keeps reset the OrangeHat and it stays offline, it's a deliberate design decision that works, it's why it wasn't showing anything.

Power regulator is good.

![Test OrangeHat Electronics](/Images/2025-08-23_T0956%20Test%20orangeHat.jpg)

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

## Interface OrangeHat with Raspberry Pi 5

Test that the power supply is good
- 10V 0.5A streaming with camera and connected via webserver

Connect with VS Code Remote

Make an application that clears the reset 

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