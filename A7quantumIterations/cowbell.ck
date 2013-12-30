// A7_quantum_iterations.ck
// cowbell.ck
// set up cow bell with time shifts to respond to pitch
SndBuf cowbell => JCRev rev => dac;
0.10 => rev.mix;
me.dir(-1)+"/audio/cowbell_01.wav" => cowbell.read;

SinOsc vib3 =>  SinOsc harmony => ADSR env3 => Chorus chor3 => NRev vr3 => Pan2 p3 => dac;
( 0.3::second, 0.25::second, 0.5, 0.3::second ) => env3.set; 
0.03 => chor3.modDepth; 
0.4 => chor3.modFreq;  
.5 => harmony.gain; // will fade out over length of cowbell part
.15  => cowbell.gain; // will come up over length of cowbell part
.03 => vr3.mix;
5.0 => vib3.freq; 
.05 => vib3.gain; 
2 => harmony.sync;
-0.9 => p3.pan; // SinOsc pan will vary from left to right over the length of piece

4 => int walk; // initialize walk variable
// global tempo and scale
BPM t;
Myscale s;
// use t and s objects to set note length and pitch
t.qNote => dur quarter;

fun void doPanAndFade()
{
    p3.pan() + 1.8*quarter/20::second => p3.pan;
    harmony.gain() * .95 => harmony.gain; 
    cowbell.gain() * 1.02 => cowbell.gain; 
    <<< p3.pan(), harmony.gain(), cowbell.gain()>>>;
}

fun void hrmny()
{
    while (1)  
    {
        s.note(walk)*1.5 => harmony.freq;
        env3.keyOn(1);
        doPanAndFade();
        quarter => now;
    }
}

spork ~ hrmny();

while (1)  {
    
    for  (0 => int i; i< Math.random2(3,8); i++)  { // play suites of 3 to 8 notes
        Math.random2(-2,2) +=> walk; // melody steps by 0, 1 or 2 semitones, up or down
        if (walk < 0) 1 => walk;  // keep melody within bounds
        if (walk >= 8) 6 => walk; //// keep melody within bounds
        s.cowNote(walk) => cowbell.rate;
       // <<< s.cowNote(walk) >>>;
        0 => cowbell.pos;
        quarter => now;
    }
    Math.random2(1,3) * quarter => now;  // take a pause of 1-3 quarters
}    
    
