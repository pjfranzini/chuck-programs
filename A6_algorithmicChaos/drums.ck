// drums.ck
// A6_algorithmic_chaos

// sound chain
SndBuf hihat => dac;

// me.dirUp 
me.dir(-1) + "/audio/hihat_04.wav" => hihat.read;

// parameter setup
0. => hihat.gain;

// loop 
while( true )  
{
    0.15 => hihat.gain;
    Math.random2f(.05,.15) => hihat.rate;
    (Math.random2f(1,2) * 3) :: second => now;
    0 => hihat.pos;
}
