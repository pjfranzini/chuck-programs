// final -- seventh garden
// myscale.ck
// global scale Class
public class Myscale
{
    // global variables
    static int a2, as2, g2, a3, cs3, d3, e3, f3, g3, gs3, a4, c4, d4, e4, g4;
    // set up only the notes i need so that a typo will give an error

    fun void setScale()
    {
        // load in midi numbers for desired notes
        45 => a2; 
        46 => as2;
        43 => g2; 
        57 => a3;
        49 => cs3; 
        50 => d3;
        52 => e3; 
        53 => f3; 
        55 => g3;
        56 => gs3;
        69 => a4;
        60 => c4; 
        62 => d4;
        64 => e4; 
        67 => g4;
    }
    
    // provide an easy way to shift notes for harmony (second argument to function)
    // the intention is to call the function like this (if s is a scale)
    // s.note(s.a2,5)
    fun float note(int i, int j)
    {            
        return Std.mtof(i+j);
    }

    // cow notes are numbers to feed into cowbell.rate to get a varying pitch roughly matching
    // the corresponding note
    // cowbell peak frequency (acc to audacity) 472 hz, or approximately bflat4, or midi 70, hence the - 70
    fun float cowNote(int i, int j)
    {           
        i + j - 70 => float powerFactor;
        return Math.pow(2.0, powerFactor/12.);
    }  
}
