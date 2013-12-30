// bass.ck
// A6_algorithmic_chaos

// sound chain (mandolin for bass)
Mandolin bass => NRev r => dac;

// shared jazz scale data
[ 46, 48, 49, 51, 53, 54, 56, 58] @=> int scale[]; 

// set base note length as specified in instructions
0.625::second => dur quarter;

// parameter setup
0.3 => r.mix;
1.0 => bass.stringDamping;
0.02 => bass.stringDetune;
0.05 => bass.bodySize;
4 => int walkPos;
.1 => bass.gain;

// loop
while(1)  
{
        for  (0 => int i; i< 6; i++)  { // 6 notes
            Math.random2(-2,2) +=> walkPos; 
            if (walkPos < 0) 1 => walkPos;
            if (walkPos >= scale.cap()) scale.cap()-2 => walkPos;
            Std.mtof(scale[walkPos]-24) => bass.freq;
            Math.random2f(0.05,0.5) => bass.pluckPos;
            1 => bass.noteOn;
            0.5 :: second => now;
            1 => bass.noteOff;
            0.125 :: second => now;
        }
        1 => bass.noteOff;
   2 * quarter => now;
}
