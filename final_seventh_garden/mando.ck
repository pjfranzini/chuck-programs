// final -- seventh garden
// sound chain 
TubeBell voice => NRev r => dac;
Mandolin voice2 => NRev r2 => dac;
Bowed voice3 => NRev r3 => dac;

SinOsc vib3 =>  SinOsc harmony => ADSR env3 => Chorus chor3 => NRev vr3 => Pan2 p3 => dac;
( 0.3::second, 0.25::second, 0.5, 0.3::second ) => env3.set; 
0.03 => chor3.modDepth; 
0.4 => chor3.modFreq;  
.0 => harmony.gain; // turned on in verse 2
.15 => vr3.mix;
5.0 => vib3.freq; 
.05 => vib3.gain; 
2 => harmony.sync;
-0.9 => p3.pan; // SinOsc pan will vary from left to right over the length of piece

.15 => voice.gain;  // base value .15 -- die off with slight jitter over piece
.15 => voice2.gain; // base value .25 -- have mandolin more in 1st verse
.1 => voice2.bodySize;  
.98 => voice2.stringDamping;
.0 => voice3.gain; // base value .5 -- violin more in 2nd
.9 => voice3.bowPressure ;
.5 => voice3.bowPosition; // vary .1-.9

// global tempo and scale
BPM t;
Myscale s;
// use t and s objects to set note length and pitch
t.tNote => dur tnote;
int melody1[55];
int timing1[55];
// set up a sequence of notes
[0, s.d4, s.a3, 0, s.d4, s.d3, 0, s.g4, s.d4,  0, 
    s.e4, s.a3,  0, s.d3, s.e3, s.f3, s.gs3, s.a3, s.e3, s.f3, 
    s.d3, s.gs3, s.a3, s.e3, s.f3, s.cs3, s.d3, s.a2, s.as2, s.g2, 
    s.g2, s.a2, s.as2, s.cs3, s.d3, s.a2, s.as2, s.g2, s.cs3, s.d3,
    s.a2, s.as2, s.g2, s.a2, s.a2, s.a2, 0, s.a3, s.e3, s.e3, s.d3, s.a2, s.a2, s.a2, 0] @=> melody1;

[3, 3, 6, 3, 3, 6, 3, 3, 6, 3, 3, 3, 3, 2, 1, 1, 2, 2, 1, 1, 1, 
   1, 2, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 1, 1, 2, 1,
   1, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 2, 7] @=> timing1;


// parameter setup
0.25 => r.mix;
0.25 => r2.mix;
0.25 => r3.mix;


fun void doFade()
{
    p3.pan() + 4*tnote/70::second => p3.pan;
    voice.gain() * Math.random2f(.96,.98) => voice.gain; 
   // <<< voice.gain(), p3.pan()>>>;
}
fun void hrmny()
{
    while (1)  
    {
       for  (0 => int j; j< 2; j++)  {   
          // set up change of behavior for 2nd verse
          if (j == 1) {
              .3 => harmony.gain;
          }             
                      
          for  (0 => int i; i< 55; i++)  {
              if (melody1[i] == 0) {
                  env3.keyOff(1);
                  tnote * timing1[i] => now;
              }
              else {
                 s.note(melody1[i],0) * 2 => harmony.freq;
                 env3.keyOn(1);
             //  doPanAndFade();
                 tnote * timing1[i] => now;
              }
           }
       }
     }
}

spork ~ hrmny();

// loop
while(1)  
{      
    
     for  (0 => int j; j< 2; j++)  {   
    // set up change of behavior for 2nd verse
        if (j == 1) {
            .1 => voice2.gain;
            .5 => voice3.gain;
            .9 => voice3.bowPosition;
        }    
        for  (0 => int i; i< 55; i++)  {
            if (melody1[i] == 0) {
                1 => voice.noteOff;
                1 => voice2.noteOff;
                1 => voice3.noteOff;
                tnote * timing1[i] => now;
            }
            else {
                s.note(melody1[i],0)*3 => voice.freq;
                s.note(melody1[i],0)*2 => voice2.freq;
                s.note(melody1[i],0) => voice3.freq;
                1 => voice.noteOn;
                1 => voice2.noteOn;
                1 => voice3.noteOn;
                tnote * timing1[i] => now;
                doFade();
                voice3.bowPosition()* Math.random2f(.95,.97) => voice3.bowPosition;
                    <<<voice3.bowPosition()>>>;
            }
         }      
     }
}
