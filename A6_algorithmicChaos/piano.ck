// piano.ck
// A6_algorithmic_chaos

// sound chain
Rhodey piano[4];
piano[0] => dac.left;
piano[1] => dac; 
piano[2] => dac;
piano[3] => dac.right; 

// chord 2D array
[[46,49,53,58],[48,53,58,48+12],[48,51,56,28+12]] @=> int chordz[][];

0.625::second => dur quarter;

fun void chord(int duration, int which)
{
    for( 0 => int i; i < 4; i++ )  
    {
        Std.mtof(chordz[which][i]) => piano[i].freq;
        Math.random2f(0.08,.25) => piano[i].noteOn;
    }
    duration * quarter => now;
}

// loop 
while( true )  
{
    Math.random2(0,2) => int which;
    Math.random2(2,6) => int duration;
    chord(duration,which);
}
