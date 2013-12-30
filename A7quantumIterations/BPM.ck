// A7_quantum_iterations.ck
// BPM.ck
// global Class to manage tempo and notelengths
public class BPM
{
    // global variables
    static dur myDuration[]; // note fix
    static dur qNote, hNote, lNote;
    
    fun void tempo(float beat)  {
        // beat = beats per minute; requirement "Make quarter Notes (main compositional pulse) 0.625::second"
        // translates to 96bpm
        
        60.0/(beat) => float SPB; // not doing this step leads to a long long time debugging why Chuck crashes
        SPB :: second => qNote;
        // and we get back our 0.625... Still, nice to think of tempo in bpm
        // so that's why I'm translating and retranslating...
        qNote*2 => hNote;
        qNote*4 => lNote;
               // store data in array
        [qNote, hNote, lNote] @=> myDuration; // not using this, but should work now if I wanted to

    }
}

