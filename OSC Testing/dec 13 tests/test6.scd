
// VERSION 1
/*(
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

// Print the resulting dictionary


~harmonicsDict.size.do { |i|
	~harmonicsDict[i].postln;

};
)*/

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
~key = 1;

// Iterate through each frequency and compute harmonics
~frequencies.do { |freq|
    // Generate harmonics and amplitudes for the current frequency
    var harmonics = f.value(freq, 5); // Change 5 to the desired number of harmonics

    // Create entries in the dictionary for each harmonic
    harmonics.do { |harmonicArray|
        ~harmonicsDict[~key] = harmonicArray;
        ~key = ~key + 1;
    };
};

// Print the resulting dictionary
~harmonicsDict.size.do { |i|
	~harmonicsDict[i].postln;
};

)


