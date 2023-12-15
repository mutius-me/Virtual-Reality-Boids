(

// Start the OSC server on port 57120
s.addr = NetAddr("127.0.0.1", 57120);
s.reboot;


s.waitForBoot {

	// Define an OSCdef for the /ball/position address pattern
	// This will trigger every time a message is received at that address
	OSCdef(\ballPosition, { |msg, time, addr, recvPort|
		var position;

		// The message arguments (the ball's position) start at index 1 of the msg array
		position = msg[1..3];

		// Post the position to the Post window for debugging
		position.postln;
	}, '/ball/position');

	// Define another OSCdef for the /ball/bounce address pattern
	OSCdef(\ballBounce, { |msg, time, addr, recvPort|
		// Post a message to the Post window when the ball bounces
		"Ball bounced!".postln;
	}, '/ball/bounce');

}
)