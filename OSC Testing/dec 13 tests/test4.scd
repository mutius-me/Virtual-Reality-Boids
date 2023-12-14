(
SynthDef(\stochasticWave, { |out = 0, freq = 440|
    var signal, env, filter, numHarmonics;

	numHarmonics = 10;

    // Generate harmonics with random amplitudes
    signal = Mix.fill(numHarmonics, {
        var harmonicFreq = (2 * Rand(0, numHarmonics) + 1) * freq;
        var amplitude = Rand(0.01, 0.1);
        SinOsc.ar(harmonicFreq, 0, amplitude)
    });

    // Envelope for amplitude shaping
    env = EnvGen.kr(Env.perc(0.01, 1, 0.2, -4), doneAction: 2);
    signal = signal * env;

    // Filter
    filter = LPF.ar(signal, Rand(400, 8000));

    // Output
    Out.ar(out, filter ! 2);
}).add;
)

// Play the sound
x = Synth(\stochasticWave, [\freq, 440, \numHarmonics, 10]);
