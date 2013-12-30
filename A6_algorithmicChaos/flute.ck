// flute.ck
// A6_algorithmic_chaos
SinOsc vib2 =>  SinOsc harmony => ADSR env2 => Chorus chor2 => NRev vr2 => dac;
( 0.4::second, 0.2::second, 0.6, 0.5::second ) => env2.set;
 0.01 => chor2.modDepth; 
0.1 => chor2.modFreq;  
.1 => harmony.gain; 
.02 => vr2.mix;
6.0 => vib2.freq; // vibrato reset below proportional to solo freq
.05 => vib2.gain; 
2 => harmony.sync;

SinOsc vib3 =>  SinOsc solo => ADSR env3 => Chorus chor3 => NRev vr3 => Pan2 p3 => dac;
( 0.4::second, 0.2::second, 0.6, 0.5::second ) => env3.set; 
0.02 => chor3.modDepth; 
0.3 => chor3.modFreq;  
.3 => solo.gain; 
.03 => vr3.mix;
6.0 => vib3.freq; // vibrato reset below proportional to solo freq
.05 => vib3.gain; 
2 => solo.sync;
-0.9 => p3.pan; // SinOsc pan will vary from left to right over the length of piece

// set base note length as specified in instructions
0.625::second => dur quarter;

// shared Bb Aeolian mode
[46,     49,     53, 54, 56, 58] @=> int scale[]; 

// 
fun void doPan()
{
    p3.pan() + 1.8*quarter/20::second => p3.pan;
    <<< p3.pan()>>>;
}

fun void hrmny()
{
    while (1)  
    {
       solo.freq()/2.0 => harmony.freq;
       env2.keyOn(1);
       quarter/8 => now;
   }
}

spork ~ hrmny();

while (1)  
{
    for  (0 => int i; i< Math.random2(3,8); i++)  { // play suites of 3,8 notes
       Math.random2(0,5) => int note;
       Math.mtof(scale[note])*2 => solo.freq;
       Math.mtof(scale[note])/8. => vib3.freq;
       env3.keyOn(1);
       doPan();
       (-.2  + Math.random2(1,3) ) * quarter/2 => now;
      .2 * quarter/2 => now;
       env3.keyOff(1);
   }
   Math.random2(2,4) *quarter => now;
}
