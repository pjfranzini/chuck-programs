//A4 cymbals_were_despised
// sound chain
Gain master => dac;
SinOsc s1  => NRev r1 =>  master;
SinOsc s2  =>  NRev r2 => master;
SndBuf hihat => Pan2 p1 => master;
SndBuf hihat2 => Pan2 p2 => master;
.8 => master.gain;
// a tiny bit of reverb to keep things from sounding so flat
// please feel free to set to zero if you are a purist and insist that
// I shouldn't be using reverb yet...
.01 => r1.mix;
.01 => r2.mix;

me.dir() + "/audio/hihat_04.wav" => hihat.read;
me.dir() + "/audio/hihat_03.wav" => hihat2.read;
// set all playheads to end so no sound is made
hihat.samples() => hihat.pos;
hihat2.samples() => hihat2.pos;

[51, 53, 55, 56, 58, 60, 61, 63] @=> int EbMixolydian[];
//D#, F,  G, G#, A#, C,  C#, D# or
//Eb, F,  G, Ab, Bb, C,  Db, Eb

[63,  61,63,61,  60,  -1] @=> int phrase1[];
[1.0, .34,.33,.33, 1., 1.] @=> float beat1[];
[0.4, 0.5, .4, .3, .2, 0.] @=> float gain1[];
[61,  60,61,60,  58,  -1] @=> int phrase2[];

[60,   61,  60,  58, 60, 56, 55, 56] @=> int phrase3[];
[1.0, 1.0, 0.5, 0.5, 1.0,1.0,1.0,1.0] @=> float beat3[];
[0.3, 0.4, .5,  .5,  .4, .3,  .3, .3] @=> float gain3[];

[51,  56,  55,  60,  58, -1] @=> int phrase4[];
[1.0, 3.0, 1.0, 1.0, 1.0, 1.] @=> float beat4[];
[0.3, 0.5, .5,  .5,  .2, 0. ] @=> float gain4[];

[60,  61,  60,  58,  60,  56, 55, 56, -1] @=> int phrase5[];
[1.0, 1.0, 0.5, 0.5, 1.0, 1.0, 1.0, 1.0, 0] @=> float beat5[];
[0.3, 0.5, 0.3, 0.3, 0.5, .4, .3 , .2,  .0] @=> float gain5[];

[63,  61,  60,  -1] @=> int phrase6[];
[1.0, 1., 1., 1.] @=> float beat6[];
[0.6, .4,  .2, 0.] @=> float gain6[];
[61,  60,  58,  -1] @=> int phrase7[];

// set base note length as specified in instructions
.6::second => dur quarter;

// note[i] == -1 -- my way of denoting a pause
fun void playPhrase(int note[], float beat[], float gain[], float rel_gain, int interval)
{
    for (0 => int i; i<note.cap(); i++)
    {
        if (note[i] == -1)
        {
            quarter*beat[i] => now;
        }
        else
        {
            Std.mtof(note[i]) => s1.freq;
            Std.mtof(note[i]+interval) => s2.freq;
            playNote(gain[i], rel_gain, quarter*beat[i]);
        }
    }
}

// less for effect than to avoid clicks, ramp up each note from zero gain
// play it at desired gain
// ramp it back down
fun void playNote(float gain, float rel_gain, dur length)
{
    // Bring gain up and down in these steps
    0.001 => float gainstep;
    // in time intervals of this length
    .00005::second =>  dur timestep;
    // ramp up
    for (0 => float i; i < gain; i + gainstep => i)
    {
        i => s1.gain;
        i * rel_gain => s2.gain;
        timestep => now;
    }
    length - 2 * gain / gainstep * timestep => now; // advance time note length - ramp lengths
    //ramp down
    for (gain => float i; i > 0; i - gainstep => i)
    {
        i => s1.gain;
        i * rel_gain => s2.gain;
        timestep => now;
    }   
}
now/1::second => float starting;
fun void timeStamp(string label)
{
    <<<label, now /1::second - starting>>>;      
}
fun void cymbal(float speed, int count)
{
    0 => hihat.pos;
    Math.random2f(.20,.25) => hihat.gain;
    Math.random2f(speed,speed*1.2) => hihat.rate;
    Math.random2f(-1.,1.) => p1.pan;
    quarter*count => now;
}

fun void cymbal2(int start, float speed, float cgain)
{
    start => hihat2.pos;
    cgain => hihat2.gain;
    speed => hihat2.rate;
    Math.random2f(-1.,1.) => p1.pan;
}

timeStamp("Start");
playPhrase(phrase1, beat1, gain1, 0.3, 12);
playPhrase(phrase2, beat1, gain1, 0.3, 12);
timeStamp("1st line end");
playPhrase(phrase3, beat3, gain3, 0.3, 12);
timeStamp("2nd line end");
cymbal(.1,1);
cymbal2(0,.07,.4);
timeStamp("melody resumes, cymbal continues to resonate");
playPhrase(phrase4, beat4, gain4, 0.3, -12);
timeStamp("3rd line end");
playPhrase(phrase5, beat5, gain5, 0.3, -12);
timeStamp("4th line end");
cymbal(.1,1);
cymbal2(500,.1,.25);
timeStamp("melody resumes, cymbal continues to resonate");
playPhrase(phrase6, beat6, gain6, 0.3, -12);
playPhrase(phrase7, beat6, gain6, 0.3, -12);
timeStamp("5th line end");
playPhrase(phrase3, beat3, gain3, 0.3, -12);
cymbal2(0,.1,.1);
cymbal(.6,3);
timeStamp("end");
