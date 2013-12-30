// final -- seventh garden
// BPM.ck
// global Class to manage tempo and notelengths
public class BPM
{
    // global variables
    static dur myDuration[]; // note fix
    static dur qNote, hNote, lNote, tNote;
    
    fun void tempo(float beat)  {
        
        60.0/(beat) => float SPB; // not doing this step leads to a long long time debugging why Chuck crashes
        SPB :: second => qNote;
        qNote*2 => hNote;
        qNote*4 => lNote;
        qNote/3.0 => tNote;
               // store data in array
        [qNote, hNote, lNote, tNote] @=> myDuration; // not using this, but should work now if I wanted to
    }
}

