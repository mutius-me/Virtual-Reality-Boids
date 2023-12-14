
s.addr = NetAddr("127.0.0.1", 57120);

s.addr;

(
OSCdef(\exampleReceiver, { |msg|
    msg.postln;  // This will print the entire message to the Post window
    // Rest of your code...
}, '/boids/positions/0');
)

