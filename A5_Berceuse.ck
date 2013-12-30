//A5 Berceuse
// sound chain
Mandolin voice1 => Chorus chor1 => Pan2 p1  => dac;
0.05 => chor1.modDepth; // depth of chorus modulation
0.5 => chor1.modFreq; // bring up amount of freq shift
0.6 => voice1.gain; //.6
0.2 => voice1.bodySize; // big body
-0.6 => p1.pan; // Mandolin soft left

Moog voice2 => NRev vr2 => Chorus chor2  => dac;
0.05 => chor2.modDepth; 
0.5 => chor2.modFreq; 
0.2 => voice2.gain; // .2
.15 => vr2.mix;

SinOsc vib3 =>  SinOsc voice3 => ADSR env3 => Chorus chor3 => NRev vr3 => Pan2 p3 => dac;
( 0.5::second, 0.1::second, 0.6, 0.5::second ) => env3.set; 
0.05 => chor3.modDepth; 
0.5 => chor3.modFreq;  
.4 => voice3.gain; // .4
.25 => vr3.mix;
6.0 => vib3.freq; // vibrato
2 => voice3.sync;
-0.9 => p3.pan; // SinOsc pan will vary from left to right over the length of piece

Moog voice4 => NRev vr4  => Pan2 p4 => dac; 
.15 => voice4.gain; //.15
.3 => vr4.mix;
0.6 => p4.pan; // Moog2 soft right

SndBuf hihat => dac;
me.dir() + "/audio/hihat_04.wav" => hihat.read;
// set playhead to end so no sound is made
hihat.samples() => hihat.pos;


// set up the allowed frequencies, the Db Phrygian mode
[ 49, 50, 52, 54, 56, 57, 59, 61] @=> int Phry[];
//c#   d   e  f#  g#   a   b  c#
//
// this set transposed to my original key to help me read off de-transposition
//[ 52, 53, 55, 57, 59, 60, 62, 64] // his shifted 3 semitones
//  e   f   g   a   b   c   d   e
//  0   1   2   3   4   5   6   7   lookup table to set up note array

[  -1, -1, -1, -1, -1] @=> int phrase0a[];
[ 6, 6, 6, 6, 6] @=> int phrase0b[];
[ 2, 2, 2, 2, 2] @=> int phrase0c[];
[ 1.5, 1., 1., 1.5, 1.] @=> float beat0[];


[14, 13, 14, 13, 6, 12, 12, 14, 16, 14, 13, -1] @=> int phrase1a[];
[6,  6,  6,  6,  7,  6,  7,  3,  4,  7, 6, -1] @=> int phrase1b[];
[2, 2, 2,   -1, -1, 2, -1, -1, -1, -1, 2, -1] @=> int phrase1c[];
[ 1.,1., 1., 1., 2, 1., 1., 1.,  2., 1., 2.,1.] @=> float beat1[];

[14, 13, 14, 13, 6, 12, 12, 13, 14, 13, 12, -1] @=> int phrase2a[];
[12, 11, 12, 2, 12, 11, 12, 2,  14, -1, 6, 6] @=> int phrase2b[];
[-1, -1, -1, 2, -1, -1, -1, -1, 2, 2, 2, 2] @=> int phrase2c[];
[1., 1., 1.,1.,  2, 1., 1., 1.,  2.,1., 3., 3.] @=> float beat2[];

// set base note length as specified in instructions
0.75::second => dur quarter;

// note[i] == -1 -- my way of denoting a pause
// 2 digit note numbers starting with 1 are a signal to lift an octave
fun void playPhrase(int noteA[], int noteB[], int noteC[], float beat[])
{
    for (0 => int i; i<beat.cap(); i++)
    {
        if (noteA[i] != -1)
        // first line
        {
            makeNote(noteA,i) => voice1.freq;
            // vary stringDamping from note to note; make sure it doesnt exceed 1
            Math.min(voice1.stringDamping() * Math.random2f(0.9,1.1),1) => voice1.stringDamping ;
            // vary voice2.gain; make sure it doesn't exceed .6
            Math.min(voice2.gain() + Math.random2f(-0.05,0.05), .6) => voice2.gain;
            voice1.freq()/2 => voice2.freq; // octave lower in voice 2
            voice1.noteOn(1);
            voice2.noteOn(1);
        }
        if (noteB[i] != -1)
        // second line
        {
            makeNote(noteB,i) => voice3.freq;
            env3.keyOn(1);
            doPan();
        }
        if (noteC[i] != -1)
            // third line
        {
            makeNote(noteC,i) => voice4.freq;
            voice4.noteOn(1);
        }
        
        quarter*beat[i] => now;
    }
}
// shifts an octave (and uses right note number) for 1* note numbers
fun float makeNote( int note[],int i)
{            
     return Std.mtof(Phry[note[i]%10]+(note[i]/10)*12);
 }
 
// calculate pan
fun void doPan()
{
    p3.pan() + 1.8*quarter/30::second => p3.pan;
    <<< p3.pan()>>>;
}
fun void cymbal2(int start, float speed, float cgain)
{
    start => hihat.pos;
    cgain => hihat.gain;
    speed => hihat.rate;
}
playPhrase(phrase0a, phrase0b, phrase0c, beat0);
cymbal2(1000,.02,.15);
playPhrase(phrase1a, phrase1b, phrase1c, beat1);
cymbal2(500,.05,.15);
playPhrase(phrase2a, phrase2b, phrase2c, beat2);


// smoothly end piece
voice1.noteOff(1);
voice2.noteOff(1);
env3.keyOff(1);
voice4.noteOff(1);
quarter*2 => now;
