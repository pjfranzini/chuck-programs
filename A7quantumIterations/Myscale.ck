// A7_quantum_iterations.ck
// myscale.ck
// global scale Class
public class Myscale
{
    // global variables
    static int myScale[]; // making this static crashes ChucK
    static int doh, reh, mee, faa, sol, laa, tii, dooh; // seem to need this intermediate step
    

    fun void setScale(int scale[])
    {
        scale[0] => doh; // awkward as hell :(
        scale[1] => reh; // but just skipping this and doing a loop over
        scale[2] => mee; // scale[i] => myScale[i]; wasn't working for me      
        scale[3] => faa;
        scale[4] => sol;
        scale[5] => laa;
        scale[6] => tii;
        scale[7] => dooh;  

        // store data in array
        [doh, reh, mee, faa, sol, laa, tii, dooh] @=> myScale;
    }
    
    // 2 digit note numbers are a signal to shift up octave(s)
    // e.g., note[0] is C3, note[10] is C4, note[20] is C5 etc  
    fun float note(int i)
    {            
        return Std.mtof(myScale[i%10]+(i/10)*12);
    }

    // cow notes are numbers to feed into cowbell.rate to get a varying pitch roughly matching
    // the corresponding note
    // cowbell peak frequency (acc to audacity) 472 hz, or approximately bflat4, or midi 70, hence the - 70
    fun float cowNote(int i)
    {           
        myScale[i%10] + (i/10)*12 - 70 => float powerFactor;
        return Math.pow(2.0, powerFactor/12.);
    }
   
}

