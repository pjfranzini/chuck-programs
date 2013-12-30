// A7_quantum_iterations.ck
// score.ck
// control our set of instruments using the tempo and scale classes
BPM t;
Myscale s;
// set up the allowed frequencies, the C Ionian mode
s.setScale([ 48, 50, 52, 53, 55, 57, 59, 60]);
// set a tempo (96 beats per minute) equivalent to a 0.625 quarternote
t.tempo(96.0);
Machine.add(me.dir()+"/hat.ck") => int hatID;
4.0 * t.qNote => now;
Machine.add(me.dir()+"/mando.ck") => int mandoID;
// 48 total fit in our length
4.0 * t.qNote => now;
Machine.add(me.dir()+"/cowbell.ck") => int cowbellID;
32.0 * t.qNote => now;
Machine.remove(mandoID);
Machine.remove(cowbellID);
8.0 * t.qNote => now;
Machine.remove(hatID);

