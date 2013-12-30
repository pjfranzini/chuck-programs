// A7_quantum_iterations.ck
// sound chain (mandolin for mando)
Mandolin mando => NRev r => dac;

// global tempo and scale
BPM t;
Myscale s;
// use t and s objects to set note length and pitch
t.hNote => dur hnote;

// parameter setup
0.05 => r.mix;
.95 => mando.stringDamping;
0.02 => mando.stringDetune;
0.15 => mando.bodySize;
4 => int walk;
.2 => mando.gain;

fun void doFade()
{
    mando.gain() * .9 => mando.gain; 
    <<< mando.gain()>>>;
}

// loop
while(1)  
{
    for  (0 => int i; i< 6; i++)  { // 6 notes
        Math.random2(-2,2) +=> walk; // melody steps by 0, 1 or 2 semitones, up or down
        if (walk < 0) 1 => walk;  // keep melody within bounds
        if (walk >= 8) 6 => walk; //// keep melody within bounds
        s.note(walk) => mando.freq;
        1 => mando.noteOn;
        hnote => now;
        doFade();
    }

   2 * hnote => now;
}
