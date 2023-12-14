// Import the necessary OSC library
OSCFunc.trace(true); // Optional: for debugging, to see incoming OSC messages

(
// Define a function to handle incoming distance data
OSCdef(\handleDistances0, { |msg, time, addr, recvPort|
    var distances = msg[1..];
	// msg.postln; // Print the entire message for debugging

	distances[0].postln; // Process the distances array here
}, '/boids/distances/0');


OSCdef(\handleDistances1, { |msg, time, addr, recvPort|
    var distances = msg[1..];
	// msg.postln; // Print the entire message for debugging

    distances.postln; // Process the distances array here
}, '/boids/distances/1');
)


OSCdef(\handleDistances, { |msg, time, addr, recvPort|
    var distances = msg[1..];
	// msg.postln; // Print the entire message for debugging

    distances.postln; // Process the distances array here
}, '/boids/distances/0');


(
// Define a function to handle incoming position data
OSCdef(\handlePositions, { |msg, time, addr, recvPort|
    var positions = msg[1..];
    positions.postln; // Process the positions array here
    // Since positions are sent as an array of Vector3, you need to parse them accordingly
}, '/boids/position/0');
)



// Optionally, add code to stop listening to OSC messages when needed
// OSCdef(\handleDistances).free;
// OSCdef(\handlePositions).free;
