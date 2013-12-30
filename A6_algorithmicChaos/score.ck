// score.ck
// A6_algorithmic_chaos

// Add your composition files when you want them to come in

Machine.add(me.dir() + "/drums.ck") => int drumID;
2.5::second => now;

Machine.add(me.dir() + "/flute.ck") => int fluteID;
7.5::second => now;

Machine.add(me.dir() + "/bass.ck") => int bassID;
7.5::second => now;

Machine.add(me.dir() + "/piano.ck") => int pianoID;
10::second => now;

Machine.remove(pianoID);
Machine.remove(fluteID);
1.25::second => now;

Machine.remove(bassID);

1.25::second => now;
Machine.remove(drumID);

