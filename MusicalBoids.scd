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


  _____   ___  _ _____ _  _ ___  ___ ___ ___
 / __\ \ / / \| |_   _| || |   \| __| __/ __|
 \__ \\ V /| .` | | | | __ | |) | _|| _|\__ \
 |___/ |_| |_|\_| |_| |_||_|___/|___|_| |___/



*/
(
// s.addr;
// s.addr = NetAddr("127.0.0.1", 57110);

SynthDef(\harmonicSynthSine, { |out = 0, freq = 440, baseAmp = 0.1, ampMod = 1, panPos = 0, filterCutoff = 500|
    var signal, ampEnv, panned, filtered;


	ampMod = LinExp.kr(ampMod, 0, 8, 0.5, 0.01);
	ampMod = ampMod.lag(1);

	panPos = LinLin.kr(panPos, -20, 20, -1, 1);
	panPos = panPos.lag(1);

	filterCutoff = linexp(-20, 20, 300, 2000);
	filterCutoff = filterCutoff.lag(1);

    // Oscillator (you can change the waveform if needed)
    signal = SinOsc.ar(freq, 0, baseAmp * ampMod);

    // Pan
    panned = Pan2.ar(signal, panPos);

    // Filter
    filtered = LPF.ar(panned, filterCutoff);

    // Output
    Out.ar(out, filtered);
}).add;

SynthDef(\harmonicSynthTri, { |out = 0, freq = 440, baseAmp = 0.1, ampMod = 1, panPos = 0, filterCutoff = 500|
    var signal, ampEnv, panned, filtered;

	ampMod = LinExp.kr(ampMod, 0, 8, 0.5, 0.01);
	ampMod = ampMod.lag(1);

	panPos = LinLin.kr(panPos, -20, 20, -1, 1);
	panPos = panPos.lag(1);

	filterCutoff = linexp(-20, 20, 300, 2000);
	filterCutoff = filterCutoff.lag(1);

    // Oscillator (you can change the waveform if needed)
    signal = LFTri.ar(freq, 0, baseAmp * ampMod);

    // Pan
    panned = Pan2.ar(signal, panPos);

    // Filter
    filtered = LPF.ar(panned, filterCutoff);

    // Output
    Out.ar(out, filtered);
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
~boidCount = 25;

~boidCount.do { |i|
	var entry;
	entry = Array.newClear(5);
	~boids.add(i -> entry);
};


/*
CLOCK: ~updateClock
A clock used to run the update routine at regular intervals.
*/
~bpm = 120;
~updateClock = TempoClock(~bpm/60.0);



(
// Define the function to generate harmonics and amplitudes
f = { |freq, x|
    var harmonics = Array.fill(x, { |i|
        var n = 2 * i + 1; // nth harmonic (odd harmonics only)
        var harmonicFreq = n * freq;
        var amplitude = 1 / (n * n); // Amplitude inversely proportional to the square of the harmonic number
        [harmonicFreq, amplitude]
    });
    harmonics
};

// Given array of frequencies
~frequencies = [200, 250, 300, 375, 450];

// Create a dictionary to store harmonics
~harmonicsDict = Dictionary.new;

// Initialize a counter for dictionary keys
~key = 0;

// Iterate through each frequency and compute harmonics
~frequencies.do { |freq|
    // Generate harmonics and amplitudes for the current frequency
    var harmonics = f.value(freq, 5); // Change 5 to the desired number of harmonics

    // Create entries in the dictionary for each harmonic
    harmonics.do { |h, amp|
        ~harmonicsDict[~key] = [h, amp, freq];
        ~key = ~key + 1;
    };
};
);

/*

  _   _ ___ ___   _ _____ ___
 | | | | _ \   \ /_\_   _| __|
 | |_| |  _/ |) / _ \| | | _|
  \___/|_| |___/_/ \_\_| |___|


*/


 ~updateAllSynths = Routine({
	inf.do {
 		~boidCount.do { |boidIndex|
 			var boidData = ~boids[boidIndex];
 			if(boidData.notNil) {
 				~updateSynth.value(boidIndex, boidData[0], boidData[1], boidData[2], boidData[3]);
 			};
 		};
 		(0.5).wait;  // Wait for 1 beat before the next iteration
 	};
 });


// ~updateAllSynths = Routine({
// 	inf.do {
// 		var boidData = ~boids[0];
// 		boidData.postln;
// 		~updateSynth.value(0, boidData[0], boidData[1], boidData[2], boidData[3]);
//
// 		0.5.wait;
// 	};
// });


// ~updateAllSynths.play(~updateClock);


// Function to update synth parameters based on received data
~updateSynth = { |boidIndex, distance, posX, posY, posZ|
	var synth, freq, amp, oscillator;
	synth = ~boids[boidIndex][4];

	if(synth.isNil) {
		// If the synth does not exist, create it
		freq = ~harmonicsDict[boidIndex][0][0];
		amp = ~harmonicsDict[boidIndex][0][1];
		oscillator = [\harmonicSynthSine, \harmonicSynthTri].choose;
		~boids[boidIndex][4] = Synth(oscillator, [\freq, freq, \baseAmp, amp, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
	} {
		// "sugma".postln;
		synth.set(
			// \?, distance,
			\ampMod, posY,
			\panPos, posX,
			\filterCutoff, posZ
		);
	};
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

// Define the OSC listener
OSCdef(\triggerRoutine, { |msg, time, addr, recvPort|
    "OSC Message Received".postln;
	~updateAllSynths.play(~updateClock);
}, '/triggerRoutine/'); // Listening for OSC messages with address pattern '/triggerRoutine'



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


OSCdef(\positionReceiver1, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/1');

OSCdef(\positionReceiver2, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/2');

OSCdef(\positionReceiver3, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/3');

OSCdef(\positionReceiver4, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/4');

OSCdef(\positionReceiver5, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/5');

OSCdef(\positionReceiver6, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/6');

OSCdef(\positionReceiver7, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/7');

OSCdef(\positionReceiver8, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/8');

OSCdef(\positionReceiver9, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/9');

OSCdef(\positionReceiver10, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/10');

OSCdef(\positionReceiver11, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/11');

OSCdef(\positionReceiver12, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/12');

OSCdef(\positionReceiver13, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/13');

OSCdef(\positionReceiver14, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/14');

OSCdef(\positionReceiver15, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/15');

OSCdef(\positionReceiver16, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/16');

OSCdef(\positionReceiver17, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/17');


OSCdef(\positionReceiver18, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/18');

OSCdef(\positionReceiver19, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/19');

OSCdef(\positionReceiver20, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/20');

OSCdef(\positionReceiver21, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/21');

OSCdef(\positionReceiver22, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/22');

OSCdef(\positionReceiver23, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/23');

OSCdef(\positionReceiver24, { |msg|
    var boidIndex, posX, posY, posZ;
    boidIndex = msg[1];
    posX = msg[2];
    posY = msg[3];
    posZ = msg[4];
    ~boids[boidIndex][1] = posX;
    ~boids[boidIndex][2] = posY;
    ~boids[boidIndex][3] = posZ;
}, '/boids/positions/24');

)


