// final -- seventh garden
// score.ck
// control our set of instruments using the tempo and scale classes
BPM t;
Myscale s;
s.setScale();
// set a tempo 
float beat;
66.0 => beat;
t.tempo(beat);
Machine.add(me.dir()+"/mando.ck") => int mandoID;
Machine.add(me.dir()+"/cowbell.ck") => int cowbellID;

76.0 * t.qNote => now;
Machine.remove(mandoID);
Machine.remove(cowbellID);

