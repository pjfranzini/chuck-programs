// A7_quantum_iterations.ck
// hat.ck
// atmospheric slow hihat
SndBuf hat => dac;
me.dir(-1)+"/audio/hihat_04.wav" => hat.read;

// global tempo and scale
BPM t;

while (1)  {
    // update our basic beat each measure
    t.lNote => dur note;
    Math.random2f(0.02,0.08) => hat.rate;
    Math.random2f(0.2,0.35) => hat.gain;
    0 => hat.pos;
    note => now;
}
