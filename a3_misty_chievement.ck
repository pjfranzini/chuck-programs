// Assignment 3 misty chievement
// note that this file must be saved to a folder containing the class "audio" folder to work
// snd chain

Gain master => dac;

SndBuf snare => NRev r1 => master;
SndBuf hihat =>  NRev r2 =>master;
SndBuf cowbell => Pan2 p1 =>  NRev r3 => master;
SinOsc s1 =>  Pan2 p2 => master;

.8 => master.gain;

// array of strings (paths)
// Use of an array of strings for loading sound files into SndBuf objects
string hihat_samples[4];
["01","02","03","04"] @=> string Labels[];

// load sound files
    // hihat loaded later 
    me.dir() + "/audio/cowbell_01.wav" => cowbell.read;
    me.dir() + "/audio/snare_01.wav" => snare.read;
// set all playheads to end so no sound is made
snare.samples() => snare.pos;
cowbell.samples() => cowbell.pos;

// set up the allowed frequencies
[ 50, 52, 53, 55, 57, 59, 60, 62] @=> int Dorian[];
// D   E   F   G   A   B   C   D
[ 62, 64, 65, 67, 69, 71, 72, 74] @=> int DorianHigh[];
// D   E   F   G   A   B   C   D

// allowed frequencies, in particular sequences
[64, 64, 64, 62, 60, 62, 60, 60, 60, 62, 64, 67] @=> int Riff[];
//e,  e,  e,  d,  c,  d,  c,  c,  c,  d,  e,  g

[62, 62, 62, 60, 59, 57, 55, 55, 55, 57, 59, 62] @=> int Riff2[];
//d,  d,  d,  c,  b,  a,  g,  g,  g,  a,  b,  d

[64, 64, 62, 60] @=> int RiffEnd[];
//e,  e,  d,  c

// setup an array to echo this with the cowbell, sounds like b
//comment later: this is wrong isn't it? if 1 gives c from b, 64 should be 5 and so on
[4,  4,  4,  2,  1,  2,  1,  1,  1,  2,  4,  7] @=> int RiffCow[];
[2,  2,  2,  0,  -1,  -3,  -5,  -5,  -5,  -3,  -1,  2] @=> int RiffCow2[];
[4,  4,  2 , 1] @=> int RiffCowEnd[];

// setup an array for the rythym of the beat 
[2,  2,  1,  1,  1,  1,  2,  2,  1,  1,  1,  1] @=> int RiffBeat[];
[2,  1 , 1, 5]  @=> int RiffBeatEnd[];

// set base note length as specified in instructions
.25::second => dur quarter;

//initialize volumes
0.0 => float gradual_gain;
gradual_gain => s1.gain;

// initialize a pan variable
0.0 => float swing;

// set reverb amounts
.1 => r1.mix;
.1 => r2.mix;
.25 => r3.mix;

//init some counter variables
0 => int measure;
0 => int beat;
0 => int riffCounter;
0 => int i;

// find lengths to prepare reversals
hihat.samples() => int numHihat;
cowbell.samples() => int numCowbell;

now/second => float starting;

while( now/second < starting + 30. )
{
    <<< beat, riffCounter, i, measure, now/1::second >>>;
    // beat goes from 0 to 15 (16 positions)
    
    //hi hat every 4 beats
    if (beat%4 == 0)
    {
        // read in a random hihat 
      me.dir() + "/audio/hihat_"+Labels[Math.random2(0, 3)]+".wav" => hihat.read;
      0 => hihat.pos;
      Math.random2f(.3,.4) => hihat.gain;
      // things get randommer and randommer as song goes on
      Math.random2f(.8-measure*.1,1.2+measure*.1) => hihat.rate;
      if (measure > 4 )
          // reverse the hihat sounds
      {
          numHihat => hihat.pos;
          -Math.random2f(.8-measure*.1,1.2+measure*.1) => hihat.rate;
      }
    }  
    
    //cowbell every other beat 
    if (beat == riffCounter)
    {
      0 => snare.pos;
      Math.random2f(.3,.45) => snare.gain;
      Math.random2f(.8-measure*.1,1.2+measure*.1) => snare.rate;
      if (measure > 1)
      { 
        0 => cowbell.pos;
        // gradually turn on cowbell and melody after 2nd measure; cap volume
        Math.min(.2,(measure - 2)*.05 + beat/16.0*.05) => gradual_gain;
        // have amplitude of panning get bigger as the piece goes on; cap at one
        Math.min(1, measure/5.) => swing;
        -swing + 2*swing*beat/16. => p1.pan;
        swing - 2*swing*beat/16. => p2.pan;
            <<< -swing + 2*swing*beat/16, swing - 2*swing*beat/16. >>>;
        gradual_gain*3 => cowbell.gain;
        gradual_gain => s1.gain;
        if (measure < 4){
          Math.pow(2.0,RiffCow[i]/12.) => cowbell.rate;
          Std.mtof(Riff[i]) => s1.freq;
        }
        else if (measure == 4 || measure == 6)  // counter melody
        {
          Math.pow(2.0,RiffCow2[i]/12.) => cowbell.rate;
          Std.mtof(Riff2[i]) => s1.freq;  
        }  
        else if (measure == 5)  // reverse cowbells, original melody
        {
          numCowbell => cowbell.pos;
          -Math.pow(2.0,RiffCow[i]/12.)/4. => cowbell.rate;
          Std.mtof(Riff[i]) => s1.freq;   
        }
        else if (measure == 7)  // end melody
        {
          Math.pow(2.0,RiffCowEnd[i]/12.) => cowbell.rate;
          Std.mtof(RiffEnd[i]) => s1.freq;  
        }      
         
      }
      
      // increment counters to get ready for next note
      if (measure < 7) 
      {
        (riffCounter + RiffBeat[i])%16 => riffCounter;
      }
      else   
      {
          (riffCounter + RiffBeatEnd[i])%16 => riffCounter;
      }      
      (i + 1) % 12 => i; 
    }  
    beat++;

    if (beat == 16) 
    {  
        // increment measure every 16th beat
        measure++;
        // and set beat number back to zero
        beat % 16 => beat;
    }
    quarter => now;
}