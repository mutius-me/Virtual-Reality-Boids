/*



      ___           ___           ___                       ___           ___
     /\  \         /\  \         /\__\                     /\__\         /\  \
    |::\  \        \:\  \       /:/ _/_       ___         /:/  /        /::\  \
    |:|:\  \        \:\  \     /:/ /\  \     /\__\       /:/  /        /:/\:\  \
  __|:|\:\  \   ___  \:\  \   /:/ /::\  \   /:/__/      /:/  /  ___   /:/ /::\  \   ___     ___
 /::::|_\:\__\ /\  \  \:\__\ /:/_/:/\:\__\ /::\  \     /:/__/  /\__\ /:/_/:/\:\__\ /\  \   /\__\
 \:\~~\  \/__/ \:\  \ /:/  / \:\/:/ /:/  / \/\:\  \__  \:\  \ /:/  / \:\/:/  \/__/ \:\  \ /:/  /
  \:\  \        \:\  /:/  /   \::/ /:/  /   ~~\:\/\__\  \:\  /:/  /   \::/__/       \:\  /:/  /
   \:\  \        \:\/:/  /     \/_/:/  /       \::/  /   \:\/:/  /     \:\  \        \:\/:/  /
    \:\__\        \::/  /        /:/  /        /:/  /     \::/  /       \:\__\        \::/  /
     \/__/         \/__/         \/__/         \/__/       \/__/         \/__/         \/__/
                    ___                                     ___
     _____         /\  \                     _____         /\__\
    /::\  \       /::\  \       ___         /::\  \       /:/ _/_
   /:/\:\  \     /:/\:\  \     /\__\       /:/\:\  \     /:/ /\  \
  /:/ /::\__\   /:/  \:\  \   /:/__/      /:/  \:\__\   /:/ /::\  \
 /:/_/:/\:|__| /:/__/ \:\__\ /::\  \     /:/__/ \:|__| /:/_/:/\:\__\
 \:\/:/ /:/  / \:\  \ /:/  / \/\:\  \__  \:\  \ /:/  / \:\/:/ /:/  /
  \::/_/:/  /   \:\  /:/  /   ~~\:\/\__\  \:\  /:/  /   \::/ /:/  /
   \:\/:/  /     \:\/:/  /       \::/  /   \:\/:/  /     \/_/:/  /
    \::/  /       \::/  /        /:/  /     \::/  /        /:/  /
     \/__/         \/__/         \/__/       \/__/         \/__/


Musical Boids.
Final Project 1; CPSC 431 at Yale University.
By Leonardo von Mutius & Neil Sachdeva.



  _____   ___  _ _____ _  _ ___  ___ ___
 / __\ \ / / \| |_   _| || |   \| __| __|
 \__ \\ V /| .` | | | | __ | |) | _|| _|
 |___/ |_| |_|\_| |_| |_||_|___/|___|_|


*/

(
SynthDef(\boidSynth, { |out = 0, freq = 440, amp = 0.1, posX = 0, posY = 0, posZ = 0|
    var audio;

    // Simple sine wave oscillator
    audio = SinOsc.ar(freq) * amp;

    // Additional sound processing can go here

    Out.ar(out, audio);
}).add;


/*

  ___ ___ _____    _   _ ___
 / __| __|_   _|__| | | | _ \
 \__ \ _|  | ||___| |_| |  _/
 |___/___| |_|     \___/|_|


*/

/*
DICTIONARY: ~boids
A dictionary to store boid information.
The data of each i-th boid is stored at index i.
Each entry is an array, where:
- index 0 is the boid distance (distance to the player)
- indices 1-3 are the x, y, & z coordinates of the boid
- index 4 is the boid's synth

*/
~boids = Dictionary.new;
~boidCount = 50;

~boidCount.do { |i|
	var entry;
	entry = Array.newClear(5);
	~boids.add(i -> entry);
};

/*

   ___  ___  ___
  / _ \/ __|/ __|
 | (_) \__ \ (__
  \___/|___/\___|


*/


OSCdef(\distanceReceiver0, { |msg|
    var boidIndex, distance;
	boidIndex = msg[1];
    distance = msg[2];
	~boids[boidIndex][0] = distance;
}, '/boids/distances/0');


OSCdef(\positionReceiver0, { |msg|
	var boidIndex, posX, posY, posZ;
    boidIndex = msg[1]; // Assuming the boid index is sent in the OSC address
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
	~boids[boidIndex][1] = posX;
	~boids[boidIndex][2] = posY;
	~boids[boidIndex][3] = posZ;

}, '/boids/positions/0');


~updateAllSynths = Routine({
    inf.do {
        ~boidCount.do { |boidIndex|
            var boidData = ~boids.at(boidIndex);
            if(boidData.notNil) {
                ~updateSynth.value(boidIndex, boidData[0], boidData[1], boidData[2], boidData[3]);
            };
        };
        1.wait;  // Wait for 1 second before the next iteration
    };
});


~updateAllSynths.play(~clock)
)


// // Function to update synth parameters based on received data
// ~updateSynth = { |boidIndex, distance, posX, posY, posZ|
// 	var synth = ~boidSynths.at(boidIndex);
// 	if(synth.isNil) {
// 		// If the synth does not exist, create it
// 		synth = Synth.new(\boidSynth);
// 		~boidSynths.put(boidIndex, synth);
// 	};
//
// 	distance = linexp(distance, 0, 15, 1, 0.01);
// 	// Update synth parameters
// 	synth.set(
// 		\amp, distance,
// 		\posX, posX,
// 		\posY, posY,
// 	\posZ, posZ);
// };
// )



