//A2_chamber_maneuvers_at_dusk

// sound chain
SinOsc s1 => NRev r1 =>  dac;
SinOsc s2 => NRev r2 => dac;
SinOsc s3 => Pan2 p1 =>  dac;


// set up the allowed frequencies
[ 50, 52, 53, 55, 57, 59, 60, 62] @=> int Dorian[];
// D   E   F   G   A   B   C   D
[ 62, 64, 65, 67, 69, 71, 72, 74] @=> int DorianHigh[];
// D   E   F   G   A   B   C   D
[ 38, 40, 41, 43, 45, 47, 48, 50] @=> int DorianLow[];
// D   E   F   G   A   B   C   D
[ 60, 62, 64, 67, 69] @=> int SubsetHigh[];
// C   D   E   G   A
[ 48, 50, 52, 55, 57] @=> int SubsetLow[];


// set base note length as specified in instructions
.25::second => dur quarter;

// define a note length variable
dur note;

// initialize a composition length counter
0::second => dur compLength;
// randomize lengths, biased towards base note length
[1.0,1.0,1.0, 2.0] @=> float Lengths[];

//initialize volumes
0.0 => s1.gain;
0.0 => s2.gain;
0.0 => s3.gain;

// print string label and value of now in seconds (to check elapsed time of piece)
<<< "starting:", now/second >>>;
    
while (compLength < 10::second)
{
    // set reverb amounts
    .05 => r1.mix;
    .05 => r2.mix;
    // as compLength moves from 0 to 10 pan moves from 1 to -1
    1 - compLength/second/5. => p1.pan;
    // turn on voices gradually
    if (compLength < 2::second)
    {
        .03 + compLength/second/10. => s2.gain;
    }
    if (compLength > 2::second && compLength < 6::second)
    {
        (compLength/second - 2.)/20. => s1.gain;
    }
    if (compLength > 6::second && compLength < 10::second)
    {
        (compLength/second - 6.)/20. => s3.gain;
    }
    // one melody line that has more sustained notes, on a simpler note subset
    Std.mtof(SubsetHigh[Math.random2(0,4)]) => s3.freq;  
    
    for (0 => int i; i<4; i++) {
    // other melodies on a four count loop to be predominantly quarter notes
        Std.mtof(Dorian[Math.random2(0,7)]) => s1.freq;
        Std.mtof(DorianLow[Math.random2(0,7)]) => s2.freq;
        Lengths[Math.random2(0,3)]*quarter => note;
        note => now;
        // keep track of where we are in the composition
        compLength + note => compLength;
    }
}
while (compLength < 20::second)
{
    // set reverb amounts
    .15 => r1.mix;
    .00 => r2.mix;
    -1 + (compLength/second-10.)/5. => p1.pan;
    // adjust voices gradually
    if (compLength < 18::second)
    {
        .23 - (compLength/second-10.)/40. => s2.gain;
    }
    if (compLength > 14::second && compLength < 16::second)
    {
        .2 + (compLength/second - 14.)/20. => s1.gain;
    }
    if (compLength > 14::second && compLength < 16::second)
    {
        .2 - (compLength/second - 14.)/20. => s3.gain;
    }
    // one melody line that has more sustained notes, on a simpler note subset
    Std.mtof(SubsetLow[Math.random2(0,4)]) => s3.freq;  
    
    for (0 => int i; i<4; i++) {
        // other melodies on a four count loop to be predominantly quarter notes
        Std.mtof(DorianHigh[Math.random2(0,7)]) => s1.freq;
        Std.mtof(DorianLow[Math.random2(0,7)]) => s2.freq;
        Lengths[Math.random2(0,3)]*quarter => note;
        note => now;
        // keep track of where we are in the composition
        compLength + note => compLength;
    }
}
while (compLength < 28::second)
{
    // set reverb amounts
    .00 => r1.mix;
    .15 => r2.mix;
    1 - (compLength/second-20.)/5. => p1.pan;
    // adjust voices gradually
    if (compLength < 22::second)
    {
        .03 + (compLength/second-20.)/10. => s2.gain;
    }
    if (compLength < 22::second)
    {
        .3 - (compLength/second - 20.)/20. => s1.gain;
    }
    // bring them down at the end
    if (compLength > 24::second  && compLength < 26::second )
    {
        .1 - (compLength/second-24.)/10. => s1.gain;
    }
    if (compLength > 26::second  && compLength < 28::second )
    {
        .1 - (compLength/second - 26.)/40. => s3.gain;
    }
    if (compLength > 28::second  && compLength < 28::second )
    {
        .23 - (compLength/second - 26.)/40. => s2.gain;
    }
    // one melody line that has more sustained notes, on a simpler note subset
    Std.mtof(SubsetLow[Math.random2(0,4)]) => s3.freq;  
    
    for (0 => int i; i<4; i++) {
        // other melodies on a four count loop to be predominantly quarter notes
        Std.mtof(DorianHigh[Math.random2(0,7)]) => s1.freq;
        Std.mtof(Dorian[Math.random2(0,7)]) => s2.freq;
        Lengths[Math.random2(0,3)]*quarter => note;
        note => now;
        // keep track of where we are in the composition
        compLength + note => compLength;
    }
}
// chuck in a sustained note to finish the piece and bring the total to exactly 30 sec
30::second - compLength => now;

// print end of piece in seconds (to check elapsed time of piece)
<<< "finishing:", now /second >>>;