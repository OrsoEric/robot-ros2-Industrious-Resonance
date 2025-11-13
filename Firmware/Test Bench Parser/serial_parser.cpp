/****************************************************************
**	OrangeBot Project
*****************************************************************
**        /
**       /
**      /
** ______ \
**         \
**          \
*****************************************************************
**	Project
*****************************************************************
**  Brief
****************************************************************/

/****************************************************************
**	DESCRIPTION
****************************************************************
**	This file implements the UART command protocols for the OrangeBot
**  system, including ping, signature, revision, stop, and velocity commands.
****************************************************************/

/****************************************************************
**	HISTORY VERSION
****************************************************************
**	2025-11-09 - Initial implementation of UART command protocols
****************************************************************/

/****************************************************************
**	KNOWN BUGS
****************************************************************
**
****************************************************************/

/****************************************************************
**	TODO
****************************************************************
**	- Add error handling for invalid command parameters
**	- Implement proper timeout management for connection reset
**	- Add unit tests for all command handlers
****************************************************************/

/****************************************************************
**	INCLUDES
****************************************************************/

//Standard C Libraries
#include <stdint.h>

//Standard C++ libraries
#include <iostream>
#include <string>

//OS Libraries
//#define _WIN32_WINNT 0x0500	//Enable GetConsoleWindow
//#include <windows.h>

//User Libraries
//Include user log trace
#define ENABLE_DEBUG
#include "debug.h"
//Universal parser class
#include "uniparser.h"

/****************************************************************
**	NAMESPACES
****************************************************************/

//Never use a whole namespace. Use only what you need from it.
using std::cout;
using std::endl;

/****************************************************************
**	DEFINES
****************************************************************/

//UART Command IDs (0 and 255 are forbidden)
#define UART_CMD_PING           1
#define UART_CMD_SIGN           2
#define UART_CMD_REVISION       3
#define UART_CMD_STOP           4
#define UART_CMD_SET_VELOCITY   5
#define UART_CMD_SET_VELOCITY_TIMED 6

//Command dictionary. Command IDs 0 and 255 are forbidden
uint8_t uart_cmd[] =
{
	//Ping: No action. Effect is to reset the connection timeout
	UART_CMD_PING		, 'P', '\0',
	//Sign: Ask for board signature
	UART_CMD_SIGN		, 'F', '\0',
    //Sign: Ask for firmware revision
	UART_CMD_REVISION	, 'R', 'E', 'V', '\0',
    //STOP: set speed 0 to the motors
	UART_CMD_STOP		, 'S', 'T', 'O', 'P', '\0',
	//VELOCITY: R right engine L left engine (last forever until overwritten)
	UART_CMD_SET_VELOCITY     , 'V', 'R', '%', 's', 'L', '%', 's', '\0',
    //VELOCITY TIMED: R right engine L left engine T time of the motion
    UART_CMD_SET_VELOCITY_TIMED , 'V', 'R', '%', 's', 'L', '%', 's', 'T', '%', 'u', '\0',
	//Dictionary terminator
	'\0'
};

//Board Signature
const char *board_sign = "Industrious_Resonance";
//Firmware Revision
const char *board_revision = "2025-11-09";

/****************************************************************
**	MACROS
****************************************************************/

/****************************************************************
**	PROTOTYPES
****************************************************************/

extern bool test_bench( void );

//Zero argument function
extern void my_noarg_function( void );
//One argument function. Template based parameters
template <typename Ta>
extern void my_function( Ta arg_a );

template <typename Ta, typename Tb>
extern void my_function( Ta arg_a, Tb arg_b );

template <typename Ta, typename Tb, typename Tc>
extern void my_function( Ta arg_a, Tb arg_b, Tc arg_c );

template <typename Ta, typename Tb, typename Tc, typename Td>
extern void my_function( Ta arg_a, Tb arg_b, Tc arg_c, Td arg_d );

//Feed a string to the parser
extern void parser_executor( Orangebot::Uniparser &my_parser, uint8_t *ptr );

//UART Command Handlers
extern void handle_ping(void);
extern void handle_sign(void);
extern void handle_revision(void);
extern void handle_stop(void);
extern void handle_set_velocity(int16_t right_speed, int16_t left_speed);
extern void handle_set_velocity_timed(int8_t right_speed, int8_t left_speed, uint8_t time);

/****************************************************************
**	GLOBAL VARIABILES
****************************************************************/

//User::Dummy my_class;

/****************************************************************
**	FUNCTIONS
****************************************************************/

/****************************************************************************
**	Function
**	main |
****************************************************************************/
//! @return bool |
//! @brief Main entry point for OrangeBot project
//! @details Initializes the system and runs test bench
/***************************************************************************/

int main()
{
	//----------------------------------------------------------------
	//	STATIC VARIABILE
	//----------------------------------------------------------------

	//----------------------------------------------------------------
	//	LOCAL VARIABILE
	//----------------------------------------------------------------

	//----------------------------------------------------------------
	//	CHECK AND INITIALIZATIONS
	//----------------------------------------------------------------

	//Start Debugging. Show function nesting level 0 and above
	DSTART( 0 );
	//Trace Enter main
	DENTER();

	//----------------------------------------------------------------
	//	BODY
	//----------------------------------------------------------------

	cout << "OrangeBot Projects\n";
	//print in the 'debug.log' file. works just like a fully featured printf
	DPRINT("OrangeBot Projects\n");

	test_bench();

	//----------------------------------------------------------------
	//	FINALIZATIONS
	//----------------------------------------------------------------

	//Trace Return from main
	DRETURN();
	//Stop Debugging
	DSTOP();

    return 0;
}	//end function: main

/****************************************************************************
**	Function
**	test_bench | void
****************************************************************************/
//! @param f bool
//! @return bool |
//! @brief Runs comprehensive tests for the parser with UART commands
//! @details Tests all implemented UART command protocols
/***************************************************************************/

bool test_bench( void )
{
	//Trace Enter with arguments
	DENTER();

	//----------------------------------------------------------------
	//	VARS
	//----------------------------------------------------------------

	//Create a new parser
	Orangebot::Uniparser my_parser;

	//----------------------------------------------------------------
	//	INIT
	//----------------------------------------------------------------

	//----------------------------------------------------------------
	//	BODY
	//----------------------------------------------------------------
	//! @details algorithm:

	//Register all UART commands with their handlers
    /*
	my_parser.add_cmd( "P", (void *)&handle_ping );
	my_parser.add_cmd( "F", (void *)&handle_sign );
	my_parser.add_cmd( "REV", (void *)&handle_revision );
	my_parser.add_cmd( "STOP", (void *)&handle_stop );
	my_parser.add_cmd( "VR%sL%s", (void *)&handle_set_velocity );
	*/
	my_parser.add_cmd( "VR%sL%sT%u", (void *)&handle_set_velocity_timed );

	//----------------------------------------------------------------
	//	TEST EXECUTION
	//----------------------------------------------------------------

	printf("---------------------------------------------------\n");
	printf("Testing UART Command Protocols\n");
	printf("---------------------------------------------------\n");

	// Test ping command
	parser_executor( my_parser, (uint8_t *)"P\0" );

	// Test signature command
	parser_executor( my_parser, (uint8_t *)"F\0" );

	// Test revision command
	parser_executor( my_parser, (uint8_t *)"REV\0" );

	// Test stop command
	parser_executor( my_parser, (uint8_t *)"STOP\0" );

	// Test velocity command
	parser_executor( my_parser, (uint8_t *)"VR+100L-50\0" );

	// Test timed velocity command
	parser_executor( my_parser, (uint8_t *)"VR+123L-123T234\0" );

	//----------------------------------------------------------------
	//	RETURN
	//----------------------------------------------------------------

	//Trace Return vith return value
	DRETURN_ARG("out: %d\n", 0);

	return true; //OK
}	//end main

/****************************************************************************
**	Function
**	handle_ping | void
****************************************************************************/
//! @brief Handles ping command - resets connection timeout
//! @details No action required, just resets the connection timeout
/***************************************************************************/
void handle_ping(void)
{
	DENTER();
	printf("EXE | %s  -> Ping received\n", __FUNCTION__);
	DRETURN();
	return;
}

/****************************************************************************
**	Function
**	handle_sign | void
****************************************************************************/
//! @brief Handles signature request command
//! @details Responds with board signature string
/***************************************************************************/
void handle_sign(void)
{
	DENTER();
	printf("EXE | %s  -> Board signature requested\n", __FUNCTION__);
	printf("Board Signature: %s\n", board_sign);
	DRETURN();
	return;
}

/****************************************************************************
**	Function
**	handle_revision | void
****************************************************************************/
//! @brief Handles firmware revision request command
//! @details Responds with firmware revision string
/***************************************************************************/
void handle_revision(void)
{
	DENTER();
	printf("EXE | %s  -> Firmware revision requested\n", __FUNCTION__);
	printf("Firmware Revision: %s\n", board_revision);
	DRETURN();
	return;
}

/****************************************************************************
**	Function
**	handle_stop | void
****************************************************************************/
//! @brief Handles stop command - sets motor speeds to zero
//! @details Stops all motors by setting speed to 0
/***************************************************************************/
void handle_stop(void)
{
	DENTER();
	printf("EXE | %s  -> Stop command received\n", __FUNCTION__);
	printf("Setting motor speeds to 0\n");
	DRETURN();
	return;
}

/****************************************************************************
**	Function
**	handle_set_velocity | int16_t, int16_t
****************************************************************************/
//! @brief Handles velocity command - sets motor speeds
//! @param right_speed Speed for right motor
//! @param left_speed Speed for left motor
//! @details Sets the speed of both motors to specified values
/***************************************************************************/
void handle_set_velocity(int16_t right_speed, int16_t left_speed)
{
	DENTER_ARG("in: Right=%d, Left=%d\n", right_speed, left_speed);
	printf("EXE | %s  -> Set velocity command\n", __FUNCTION__);
	printf("Right motor speed: %d\n", right_speed);
	printf("Left motor speed: %d\n", left_speed);
	DRETURN();
	return;
}

/****************************************************************************
**	Function
**	handle_set_velocity_timed | int16_t, int16_t, uint8_t
****************************************************************************/
//! @brief Handles timed velocity command - sets motor speeds for specific time
//! @param right_speed Speed for right motor
//! @param left_speed Speed for left motor
//! @param time Duration in seconds
//! @details Sets the speed of both motors for specified duration
/***************************************************************************/
void handle_set_velocity_timed(int8_t right_speed, int8_t left_speed, uint8_t time)
//void handle_set_velocity_timed(int16_t right_speed, int16_t left_speed, uint8_t time)
{
	DENTER_ARG("in: Right=%d, Left=%d, Time=%d\n", right_speed, left_speed, time);
	printf("EXE | %s  -> Set velocity timed command\n", __FUNCTION__);
	printf("Right motor speed: %d\n", right_speed);
	printf("Left motor speed: %d\n", left_speed);
	printf("Duration: %d seconds\n", time);
	DRETURN();
	return;
}

/****************************************************************************
**	@brief Function
**	my_noarg_function
****************************************************************************/
//! @return
//! @details
//! one to four arguments with template based mixed types
//! overload the templated functions to get different number of arguments
/***************************************************************************/

void my_noarg_function( void )
{
	DENTER();
	printf( "EXE | %s  -> void\n", __FUNCTION__ );
	DRETURN();
	return;
}

template <typename Ta>
void my_function( Ta arg_a )
{
	DENTER_ARG("in: %d\n", arg_a );
	printf("EXE | %s  -> void | arg: %d\n", __FUNCTION__, arg_a );
	DRETURN();
	return;
}

template <typename Ta, typename Tb>
void my_function( Ta arg_a, Tb arg_b )
{
	DENTER_ARG("in: %d %d\n", arg_a, arg_b );
	printf("EXE | %s  -> void | arg: %d %d\n", __FUNCTION__, arg_a, arg_b );
	DRETURN();
	return;
}

template <typename Ta, typename Tb, typename Tc>
void my_function( Ta arg_a, Tb arg_b, Tc arg_c )
{
	DENTER_ARG("in: %d %d %d\n", arg_a, arg_b, arg_c );
	printf("EXE | %s  -> void | arg: %d %d %d\n", __FUNCTION__, arg_a, arg_b, arg_c );
	DRETURN();
	return;
}

template <typename Ta, typename Tb, typename Tc, typename Td>
void my_function( Ta arg_a, Tb arg_b, Tc arg_c, Td arg_d )
{
	DENTER_ARG("in: %d %d %d %d\n", arg_a, arg_b, arg_c, arg_d );
	printf("EXE | %s  -> void | arg: %d %d %d %d\n", __FUNCTION__, arg_a, arg_b, arg_c, arg_d );
	DRETURN();
	return;
}

/****************************************************************************
**	Function
**	parser_executor | Orangebot::Uniparser &, uint8_t *
****************************************************************************/
//! @param parser |
//! @param str |
//! @brief Feeds a string to the parser for processing
//! @details Processes each character in the input string and feeds it to the parser
/***************************************************************************/

void parser_executor( Orangebot::Uniparser &my_parser, uint8_t *ptr )
{
	//Trace Enter with arguments
	DENTER_ARG("in: %d\n", 0);

	//----------------------------------------------------------------
	//	VARS
	//----------------------------------------------------------------

	//----------------------------------------------------------------
	//	INIT
	//----------------------------------------------------------------

	//----------------------------------------------------------------
	//	BODY
	//----------------------------------------------------------------

	uint8_t t = 0;
	//While: String not over
	while ((t == 0) || ((t >= 1) && !((ptr[t] == '\0') && (ptr[t-1] == '\0'))))
	{
		//Print char
		if ((ptr[t] >= '0') || (ptr[t] >= 'z') || (ptr[t] == '-') || (ptr[t] == '+'))
		{
			printf("feed: >0x%x< >%c<\n", ptr[t], ptr[t]);
		}
		else
		{
			printf("feed: >0x%x<\n", ptr[t]);
		}
		//Feed char to parser
		my_parser.parse(ptr[t]);
		//Next char
		t++;
		if (t> 128)
		{
			printf("infinite loop detected. Maybe you forgot \\0 at end of string?\n");
			exit(0);
		}
	}

	//----------------------------------------------------------------
	//	RETURN
	//----------------------------------------------------------------

	//Trace Return vith return value
	DRETURN();

	return; //OK
}	//end function: parser_executor | Orangebot::Uniparser & | uint8_t *
