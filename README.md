## Synopsis

In this project, we created a **virtual reality** (VR) environment in Unity that is populated by flying artificial-life creatures called **boids**. The boids’ positional data is routed through OSC to SuperCollider in real-time, shaping a lush synthesizer soundscape in real-time. 

The player is given the freedom to move around in a ********VR playground********, experiencing the musical and visual patterns generated by the boids.

As such, the key themes for our project are **rule-based composition, human-computer interaction, and computer networking.**

## So, what are boids, anyway?

Boids—short for “bird-oid”—are an an **artificial life program** that simulate the flocking behavior of birds. Much like the Game of Life demo we saw in lecture, boids are an example of **emergent behavior**: complexity arises from the interaction between agents that follow a set of simple, clearly-defined rules. Namely, our project is a form of ************************************rule-based composition************************************.

Boids must follow three rules (per [Wikipedia](https://en.wikipedia.org/wiki/Boids)):

> **separation**: steer to avoid crowding local flockmates;
> 

> **alignment**: steer towards the average heading of local flockmates
> 

> **cohesion:** steer to move towards the average position (center of mass) of local flockmates
> 

More on Boids:

- [The original paper published by Craig W. Reynolds, the inventor of boids](http://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/)
- [A Stanford paper about boids](https://cs.stanford.edu/people/eroberts/courses/soco/projects/2008-09/modeling-natural-systems/boids.html)

[http://www.vergenet.net/~conrad/boids/](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbjVfVVM0STJwdVhNakNOb0lDT1NDcE9UMTl0d3xBQ3Jtc0tuTnhKUDV1dG9YRHIwczJST21WWmVudW9jODdtN1pIT1JTRkYwVFJkYUtvOXZ3bTUzZ2dhNGpQTGJsTHpMb1M5aVhqcDg1alBUZlg1NXJIMjA4VGJjQjc5a1ViWUxLdkMxMFVzc2cwdHRFVnJ4R1dtMA&q=http%3A%2F%2Fwww.vergenet.net%2F%7Econrad%2Fboids%2F&v=_d8M3Y-hiUs)

We did not write the C# implementation for the boids themselves, but instead used an existing script found [here](https://github.com/SebLague/Boids/tree/master). This was for a series of reasons:

- Programming this behavior turns out to be highly complex and requires very high-level knowledge of Unity. It felt out of scope of the project, as well as out of scope of our programming abilities in Unity (this was our first time developing anything with Unity, VR, and C#).
- We had other, more pressing technical priorities: 1) Implementing virtual reality using a Meta Quest 2 while integrating two separate platforms (SuperCollider and Unity); 2) implementing objects and scripts in Unity to fetch real-time positional data from the boids, including x, y, z coordinates and distance from the player; 2) routing this information to SuperCollider through OSC with minimal latency; and most importantly, 3) writing the SuperCollider code that would be able to receive data from OSC to create real-time, rule-based music that sounded convincing.

## Implementation and technical details

VR requires a series of packages that must be installed through Unity's package manager, as well as various Unity-specific implementation detail (e.g. creating a VR-plane for the player to walk on, a VR-camera object, etc.). Our project additionally made use of a lightweight, community-maintained OSC extension called [uOSC](https://github.com/hecomi/uOSC), which was necessary to send data from Unity to OSC.

In SuperCollider, OSC is natively supported, and requires setting up functions (listeners). One major challenge was being able to send and receive this data with low-latency, since each boid is mapped to a synthesizer and is receiving update information 60 times a second. The fix that worked here was to 1) cast the positional data from the boids (floats) into integers before sending them through OSC; 2) rreduce the number of updates per second to the synths in SuperCollider; and  3) planning the composition part so that it reacted smoothly to this rate of updates (each synth updates its parameters every half a second) and magnitude of inputs (integers from -20 to 20).
