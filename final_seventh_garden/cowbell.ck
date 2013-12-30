// final -- seventh garden
// cowbell.ck
// set up cow bell with time shifts to respond to pitch
SndBuf cowbell => JCRev rev => Pan2 p2=> dac;
0.20 => rev.mix;
me.dir(-1)+"/audio/cowbell_01.wav" => cowbell.read;

Impulse imp => ResonZ harmony => dac; // impulse is click sound
400 => harmony.Q;  // the higher the Q (quality) the more resonant a filter is

harmony => NRev r => dac;

0  => cowbell.gain; // will come on in 2nd verse
.1 => r.mix;
0.5 => p2.pan; // SinOsc pan will vary from left to right over the length of piece

// global tempo and scale
BPM t;
Myscale s;
// use t and s objects to set note length and pitch
t.tNote => dur tnote;
int melody2[76];
int timing2[76];
// set up a sequence of notes
[s.d3, s.e3, s.f3, s.gs3, s.a3, s.e3, s.f3, s.gs3, s.a3, s.e3, 
 s.f3, s.cs3, s.d3, s.a2, s.as2, s.g2, s.g2, s.a2, s.as2, s.cs3, 
 s.d3, s.a2, s.as2, s.cs3, s.d3, s.a2, s.as2, s.g2, s.a2, s.a2,
 s.a2, 0, 0, s.d4, s.a3, s.d4, s.e4, s.a4, s.e4, s.d4, 
 s.a3, s.a4, s.e4, s.a3, s.d3, s.d4, s.a3, s.d3, s.g2, s.g3, 
 s.d3, s.g3, s.a3, s.d4, s.a3, s.g3, s.d3, s.g4, s.e4, s.c4, 
 s.a3, s.d4, s.c4, s.d4, s.e4, s.c4, s.d4, s.g3, s.a3, s.e3, 
 s.e3, s.d3, s.a2, s.a2, s.a2, 0] @=> melody2;

[2, 1, 1, 2, 1, 2, 2, 1, 2, 1,
 1, 2, 1, 2, 2, 1, 2, 1, 1, 2, 
 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 
 1, 2, 1, 2, 2, 1, 1, 2, 2, 1, 
 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 
 2, 1, 1, 2, 2, 1, 1, 2, 2, 1, 
 2, 1, 1, 2, 1, 2, 2, 1, 2, 1, 
 1, 2, 1, 2, 2, 1] @=> timing2;

fun void doPanAndFade()
{
    p2.pan() - 1*tnote/70::second => p2.pan;
   // <<<  cowbell.gain(), p2.pan()>>>;
}

fun void hrmny()
{
  while (1)  
  { 
      for  (0 => int i; i< 76; i++)  {
        if (melody2[i] == 0) {
          tnote * timing2[i] => now;
        }
        else {
          s.note(melody2[i],0)*3 => harmony.freq;
          //1 => harmony.noteOn;
          200.0 => imp.next; 
          doPanAndFade();
          tnote * timing2[i] => now;
        }
       }
    }
}

spork ~ hrmny();

while (1)  {
  for  (0 => int j; j< 2; j++)  {   
      // set up change of behavior for 2nd verse
      if (j == 1) {
          .2 => cowbell.gain;
      } 
    
     for  (0 => int i; i< 76; i++)  {
         if (melody2[i] == 0) {
             tnote * timing2[i] => now;
         }
         else {
             s.cowNote(melody2[i],0) => cowbell.rate;
             0 => cowbell.pos;
             tnote * timing2[i] => now;
         }
      }
  }
}    