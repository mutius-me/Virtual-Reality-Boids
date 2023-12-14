(
SynthDef(\triangleWave, { |out = 0, freq = 440, amp = 0.1|
    var signal, harmonics, n, harmonicFreq, amplitude, numHarmonics;

    numHarmonics = 32;

    // Function to generate harmonics
	harmonics = Array.fill(numHarmonics, { |i|
        n = 2 * i + 1; // nth harmonic (odd harmonics only)
        harmonicFreq = n * freq;
        amplitude = amp / (n * n); // Amplitude inversely proportional to the square of the harmonic number
        SinOsc.ar(harmonicFreq, 0, amplitude)
    });

    // Sum all the harmonics
    signal = harmonics.sum;

    // Output
    Out.ar(out, signal ! 2); // '! 2' to make it stereo
}).add;
)





y = Synth(\simpleSine, [\freq, 200]);


// Example usage
x = Synth(\triangleWave, [\freq, 2000, \numHarmonics, 10, \amp, 0.1]);

// To stop the sound after a while
x.free;
)


(
f = { |freq, x|
    var harmonics = Array.fill(x, { |i|
        var n = 2 * i + 1; // nth harmonic (odd harmonics only)
        var harmonicFreq = n * freq;
        var amplitude = 1 / (n * n); // Amplitude inversely proportional to the square of the harmonic number
        [harmonicFreq, amplitude]
    });
    harmonics
};
)

// Example usage:
(
~array = f.value(50, 10); // For frequency 20 and 5 harmonics


~random = ~array.choose;

~random[0];
~random[1];

x = Synth(\simpleSine, [\freq, ~random[0], \amp, ~random[1]]);
)

