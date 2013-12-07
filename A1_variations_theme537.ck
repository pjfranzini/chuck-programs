//A1_variations_theme537

// sound network -- define a triangle oscillator, a square, and a saw
TriOsc s => dac;
SqrOsc t => dac;
SawOsc u => dac;


// set variable names for re-used volumes
0.0 => float mute;
0.05 => float vlow;
0.15 => float low;
0.5 => float mid;
0.8 => float high;

// set variable names to store volumes (so can re-use them after muting)
float sgain;
float tgain;
float ugain;


//set variable names for note lengths
0.125::second => dur eighth; 
0.25::second => dur quarter;
0.375::second => dur quarterdot;
0.5::second => dur half;

// set initial volumes
mid => sgain;
mute => tgain;
mute => ugain;


// define some variables that define intervals and note frequencies on an equal-tempered scale
440. => float A4;
Math.pow(2.,1./12.) => float semitone;
Math.pow(semitone,2) => float tone;
Math.pow(semitone,3) => float third;
Math.pow(semitone,5) => float fourth;
Math.pow(semitone,7) => float fifth;
Math.pow(semitone,12) => float octave;
A4 / fourth => float E4;
A4 * tone => float B4;
A4 * third => float C4;
A4 * fourth => float D4;


// print string label and value of now in seconds (to check elapsed time of piece)
<<< "starting:", now/second >>>;

for (0 => int j; j < 5; j++)  {
    // initialize a frequency multiplier
    1. => float stepper;
    //in this loop the 6 measure unit created below is repeated 5 times in different keys and voices
    //in each repetition different oscillators are turned on in varying volumes
    if (j==1 || j==2){
        Math.pow(third,j) => stepper ;
    }
    else if (j==3){
        1/Math.pow(third,j) => stepper ;
    }
    if (j==1){
        vlow => tgain;}
    if (j>1){
        low => tgain;
        vlow => ugain;
    }
    if (j>2) {
        low => ugain;
        high => sgain;   
    }
        
    for (0 => int i; i < 3; i++)  {
        // in this loop a simple 8 beat (2 measures) motif is repeated in three different variations
        
        // set the volumes
        sgain => s.gain;
        tgain => t.gain;
        ugain => u.gain;
        // set the frequencies of the three oscillators
        stepper * E4 => s.freq;
        stepper * E4 / octave => t.freq;
        stepper * E4 / octave*fifth => u.freq;
        quarterdot => now;
        // a rest -- mute oscs, advance time, put volumes back to where they were
        mute => s.gain;
        mute => t.gain;
        mute => u.gain;
        eighth => now;
        sgain => s.gain;
        tgain => t.gain;
        ugain => u.gain;
        
        // depending which repetition we are on, some notes in the phrase are on or off
        if (i==0){
            stepper * A4 => s.freq;
            stepper * A4 / octave => t.freq;
            stepper * A4 / octave/fifth => u.freq;
            quarter => now;
        }
        if (i==0 || i==1){
            stepper * B4 => s.freq;
            stepper * B4 / octave => t.freq;
            stepper * B4 / octave/fifth => u.freq;
            quarter => now;
        }
        stepper * C4 => s.freq;
        stepper * C4 / octave => t.freq;
        stepper * C4 / octave/fifth => u.freq;
        quarter => now;
        if (i==1){
            stepper * D4 => s.freq;
            stepper * D4 / octave => t.freq;
            stepper * D4 / octave/fifth => u.freq;
            quarter => now;
            stepper * C4 => s.freq;
            stepper * C4 / octave => t.freq;
            stepper * C4 / octave/fifth => u.freq;
            quarter => now;
        }
        stepper * B4 => s.freq;
        stepper * B4 / octave => t.freq;
        stepper * B4 / octave/fifth => u.freq;
        quarter => now;
        if (i==0 || i==2){
            stepper * A4 => s.freq;
            stepper * A4 / octave => t.freq;
            stepper * A4 / octave/fifth => u.freq;
            half => now;
        }
        else{
            stepper * B4 => s.freq;
            stepper * B4 / octave => t.freq;
            stepper * B4 / octave/fifth => u.freq;
            quarter => now;   
        }
        if (i==2)
        {
            mute => s.gain;
            mute => t.gain;
            mute => u.gain;
            half => now;
            sgain => s.gain;
            tgain => t.gain;
            ugain => u.gain;
        }
        
    }
}
// print end of piece in seconds (to check elapsed time of piece)
<<< "finishing:", now /second >>>;
