# Serial Protocol

The scope of the protocol is to let the SBC send motion commands

It's meant to be compiled by a MCP server

So I'd like to have a sort of queue of commands, I am thinking speed duration


## Maze Runner

Below is the dictionary I used for Maze Runner

```cpp
//Command dictionary. Command IDs 0 and 255 are forbidden
U8 uart_cmd[] =
{
	//Ping: No action. Effect is to reset the connection timeout
	UART_CMD_PING		, 'P', '\0',
	//Sign: Ask for board signature
	UART_CMD_SIGN		, 'F', '\0',
	//Set Speed: R right engine L left engine
	UART_CMD_SETVEL	, 'V', 'R', '%', 'd', 'L', '%', 'd', '\0',
	//Dictionary terminator
	'\0'
};
//Board Signature
U8 *board_sign = (U8 *)"MazeRunner_05032";
```

In my uniparser, d is S32, so it's two S32 signed number this command, I send them to the board as bytes, not as ascii numbers

## Protocol

I need smaller numbers, I think I could do something like this

```cpp
//Command dictionary. Command IDs 0 and 255 are forbidden
U8 uart_cmd[] =
{
	//Ping: No action. Effect is to reset the connection timeout
	UART_CMD_PING		, 'P', '\0',
	//Sign: Ask for board signature
	UART_CMD_SIGN		, 'F', '\0',
    //Sign: Ask for firmware revision
	UART_CMD_REVISION	, 'REV', '\0',
    //STOP: set speed 0 to the motors
	UART_CMD_STOP		, 'STOP', '\0',
	//VELOCITY: R right engine L left engine (last forever until overwritten)
	UART_CMD_SET_VELOCITY     , 'V', 'R', '%', 's', 'L', '%', 's', '\0',
    //VELOCITY TIMED: R right engine L left engine T time of the motion
    UART_CMD_SET_VELOCITY_TIMED , 'V', 'R', '%', 's', 'L', '%', 's', 'T', '%', 'u', \0',
	//Dictionary terminator
	'\0'
};
//Board Signature
U8 *board_sign = (U8 *)"Industrious_Resonance";
//Firmware Revision
U8 *board_revision = (U8 *)"2025-11-09";
```
