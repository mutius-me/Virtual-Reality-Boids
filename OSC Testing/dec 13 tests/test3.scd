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

~harmonicsArray = f.value(150, 10); // For frequency 100 and 10 harmonics

// Function to play a random harmonic
~playRandomHarmonic = {
    var randomHarmonic = ~harmonicsArray.choose;
    Synth(\simpleSine, [\freq, randomHarmonic[0], \amp, randomHarmonic[1]]);
};
)


~x = Synth(\simpleSine, [\freq, ~harmonicsArray[0][0], \amp, ~harmonicsArray[0][1]]);
// Example usage: call this repeatedly to add random harmonics

~playRandomHarmonic.value;


