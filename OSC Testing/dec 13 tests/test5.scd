(
SynthDef(\harmonicSynthSine, { |out = 0, freq = 440, baseAmp = 0.1, ampMod = 1, panPos = 0, filterCutoff = 500|
    var signal, ampEnv, panned, filtered;

	ampMod = ampMod.lag(1);
	panPos = panPos.lag(1);
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

	ampMod = ampMod.lag(1);
	panPos = panPos.lag(1);
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

);

(
~a0 = Synth(\harmonicSynthSine, [\freq, 200, \baseAmp, 0.1, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~a1 = Synth(\harmonicSynthTri, [\freq, 400, \baseAmp, 0.05, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~a2 = Synth(\harmonicSynthSine, [\freq, 600, \baseAmp, 0.025, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~a3 = Synth(\harmonicSynthTri, [\freq, 800, \baseAmp, 0.0125, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);


~cs0 = Synth(\harmonicSynthSine, [\freq, 250, \baseAmp, 0.1, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~cc1 = Synth(\harmonicSynthTri, [\freq, 500, \baseAmp, 0.05, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~cs2 = Synth(\harmonicSynthSine, [\freq, 750, \baseAmp, 0.025, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);


~e0 = Synth(\harmonicSynthSine, [\freq, 300, \baseAmp, 0.1, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~e1 = Synth(\harmonicSynthTri, [\freq, 600, \baseAmp, 0.05, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~e2 = Synth(\harmonicSynthSine, [\freq, 900, \baseAmp, 0.025, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);

~gs0 = Synth(\harmonicSynthSine, [\freq, 375, \baseAmp, 0.1, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~gs1 = Synth(\harmonicSynthTri, [\freq, 750, \baseAmp, 0.05, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~gs2 = Synth(\harmonicSynthSine, [\freq, 1125, \baseAmp, 0.025, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
~gs3 = Synth(\harmonicSynthTri, [\freq, 1500, \baseAmp, 0.0125, \ampMod, 1, \panPos, 0, \filterCutoff, 500]);
);


~pitches = [200, 250, 300, 375];
~harmonics = Array.fill(5, { |i|
        var n = i + 1; // Harmonic number
        var harmonicFreq = n * freq;
        var amplitude = 1 / n; // Amplitude inversely proportional to the harmonic number
        SinOsc.ar(harmonicFreq, 0, amplitude)
    });


(
Routine.run({
    inf.do({
        ~a0.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));
		~a1.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));
		~a2.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));
        ~a3.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));

		~cs0.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));
		~cs1.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));
		~cs2.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));

		~e0.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));
		~e1.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));
		~e2.set(\ampMod, rrand(0.1, 1.5), \panPos, rrand(-1, 1), \filterCutoff, rrand(300, 2000));
        1.wait;
    });
});
);