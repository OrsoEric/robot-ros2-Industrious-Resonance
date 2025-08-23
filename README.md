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

## Electronics

It uses an OrangeHat, I remember it has a screen, UART, reset, and SERVO interpolation, it should be good to do a two axis rotation. It has an IMU, and the front numbers show change when I move it, it might be working!

I remember that if the OS isn't running, it keeps reset the OrangeHat and it stays offline, it's a deliberate design decision that works, it's why it wasn't showing anything.

Power regulator is good.

![Test OrangeHat Electronics](/Images/2025-08-23_T0956%20Test%20orangeHat.jpg)


