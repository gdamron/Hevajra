/****************************************/
/* GAMELAN CLASS                        */
/*                                      */
/* by Grant Damron: includes jegogan,   */
/* jublag, calung, ugal, pemade,  and   */
/* and kantil.  All instruments are     */
/* based on Gamelan Galak Tika's pelog  */
/* tuning. -- Measurements by Christine */
/* Southworth.                          */
/****************************************/


// TODO: work on envelopes of partials and amplitudes of both partials and attacks

public class GAMELAN
{
    
    /********************************************************/
    // INITIALIZE GEN 9 LOOKUP TABLE, ETC. 
	Phasor drive => Gen9 g9 => ADSR env1 => Gain env0;
	[ 1.,1.,0,   2., .008, 0,   2.76132, .004, 90,   4., .0005, 180,   5.33333, .004, 270,   5.6, .02, 0,   6.4, .04, 270,   7.4, .05, 225,   8.75, .05, 120,   9.64286, .06, 270,   11., .03, 0,   12.5, .03, 180,   16.5696, .05, 90 ] => g9.coefs;
    
    // INITIALIZE ATTACK NOISE
    Noise att1 => LPF lpf => HPF hpf => ADSR aenv => env0;
    Noise att2 => LPF lpf2 => HPF hpf2 => ADSR aenv2 => env0;
    
    public void connect( UGen u ) {
        0.0 => env0.gain;
        env0 => u;
    }
    
	/***************************************/
	/* Generic: instrument to generate       */
	/* tones according to pelog scale      */
	/***************************************/
	
	public void generic(float fund, float amp, float duration)
	{   
		0.9 *=> amp;
		0.2*amp => att1.gain;
		0.3*amp => att2.gain;
		
		// FOR ATTACK
		6000.0 => lpf.freq;
		4000.0 => hpf.freq;
		12000.0 => lpf2.freq;
		8000.0 => hpf2.freq;
		aenv.set(0::ms, 0::ms, 1., 6::ms);
		aenv2.set(0::ms, 0::ms, 1., 5::ms);
		
		makeNote(fund, amp, duration);
	}

    /***************************************/
    /* Kantil: instrument to generate       */
    /* tones according to pelog scale      */
    /***************************************/
    
    public void kantil(int degree, float amp, float duration)
    {   
        0.9 *=> amp;
        0.2*amp => att1.gain;
        0.3*amp => att2.gain;
        
        // Tuning based on Gamelan Galak Tika's pelog -- 0 triggers attack only
        [0.0, 611.581, 661.043, 827.835, 893.7948, 1152.22, 1232.011, 1333.128, 1663.032, 1792.553, 2295.512] @=> float tuning[];
        (tuning.cap()) %=> degree;               // 'wrap around' note if it is out of range
        tuning[degree] => float fund;
        
        // FOR ATTACK
        6000.0 => lpf.freq;
        4000.0 => hpf.freq;
        12000.0 => lpf2.freq;
        8000.0 => hpf2.freq;
        aenv.set(0::ms, 0::ms, 1., 6::ms);
        aenv2.set(0::ms, 0::ms, 1., 5::ms);
        
        makeNote(fund, amp, duration);
    }
        
        /************************************************************/
        
       
        
            
    /***************************************/
    /* Pemade: instrument to generate       */
    /* tones according to pelog scale      */
    /***************************************/
    
    public void pemade(int degree, float amp, float duration)
    {   
        0.95 *=> amp;
        0.2*amp => att1.gain;
        0.3*amp => att2.gain;
        
        // Tuning based on Gamelan Galak Tika's pelog -- 0 triggers attack only
        [0.0, 303.426, 326.514, 417.838, 451.631, 571.338, 612.26, 660.31, 829.214, 893.795, 1149.029] @=> float tuning[];
        (tuning.cap()) %=> degree;               // 'wrap around' note if it is out of range
        tuning[degree] => float fund;
        
        // FOR ATTACK
        6000.0 => lpf.freq;
        2000.0 => hpf.freq;
        12000.0 => lpf2.freq;
        8000.0 => hpf2.freq;
        aenv.set(0::ms, 0::ms, 1., 6::ms);
        aenv2.set(0::ms, 0::ms, 1., 5::ms);
        
        makeNote(fund, amp, duration);
    } 
    
    
    /***************************************/
    /* Ugal: instrument to generate       */
    /* tones according to pelog scale      */
    /***************************************/
    
    public void ugal(int degree, float amp, float duration)
    {   
        1.0 => att1.gain;
        0.4 => att2.gain;
        
        // Tuning based on Gamelan Galak Tika's pelog -- 0 triggers attack only
        [0.0, 305.96, 328.147, 418.07, 451.13, 571.338, 611.92, 662.878, 827.531, 885.9, 1150.304] @=> float tuning[];
        (tuning.cap()) %=> degree;               // 'wrap around' note if it is out of range
        tuning[degree] => float fund;  
        
        // FOR ATTACK
        600.0 => lpf.freq;
        0 => hpf.freq;
        8000.0 => lpf2.freq;
        1000.0 => hpf2.freq;
        aenv.set(1::ms, 1::ms, 1., 12::ms);
        aenv2.set(1::ms, 1::ms, 1., 2::ms);
        
        makeNote(fund, amp, duration);
    }
    
    
    /***************************************/
    /* Calun: instrument to generate       */
    /* tones according to pelog scale      */
    /***************************************/
    
    public void calun(int degree, float amp, float duration)
    {   
        0.75 *=> amp;
        1.0 => att1.gain;
        0.4 => att2.gain;
        
        // Tuning based on Gamelan Galak Tika's pelog -- 0 triggers attack only
        [0.0, 212.306, 226.191, 285.669, 307.661, 331.623, 414.006, 449.881] @=> float tuning[];
        (tuning.cap()) %=> degree;               // 'wrap around' note if it is out of range
        tuning[degree] => float fund;  
        
        // FOR ATTACK
        600.0 => lpf.freq;
        0 => hpf.freq;
        6000.0 => lpf2.freq;
        1000.0 => hpf2.freq;
        aenv.set(1::ms, 1::ms, 1., 12::ms);
        aenv2.set(1::ms, 1::ms, 1., 2::ms);
        
        makeNote(fund, amp, duration);
    }
    
    /***************************************/
    /* Jublag: instrument to generate       */
    /* tones according to pelog scale      */
    /***************************************/
    
    public void jublag(int degree, float amp, float duration)
    {   
        0.75 *=> amp;
        1.0 => att1.gain;
        0.4 => att2.gain;
        
        // Tuning based on Gamelan Galak Tika's pelog -- 0 triggers attack only
        [0.0, 283.303, 303.089, 326.876, 417.606, 452.323] @=> float tuning[];
        (tuning.cap()) %=> degree;               // 'wrap around' note if it is out of range
        tuning[degree] => float fund;  
        
        // FOR ATTACK
        600.0 => lpf.freq;
        0 => hpf.freq;
        4000.0 => lpf2.freq;
        1000.0 => hpf2.freq;
        aenv.set(1::ms, 1::ms, 1., 12::ms);
        aenv2.set(1::ms, 1::ms, 1., 2::ms);
        
        makeNote(fund, amp, duration);
    }
    
    /***************************************/
    /* Jegogan: instrument to generate       */
    /* tones according to pelog scale      */
    /***************************************/
    
    public void jegogan(int degree, float amp, float duration)
    {   
        0.5 *=> amp;
        1.0 => att1.gain;
        0.4 => att2.gain;
        
        // Tuning based on Gamelan Galak Tika's pelog -- 0 triggers attack only
        [0.0, 138.929, 148.797, 162.084, 206.502, 222.46] @=> float tuning[];
        (tuning.cap()) %=> degree;               // 'wrap around' note if it is out of range
        tuning[degree] => float fund;  
        
        // FOR ATTACK
        600.0 => lpf.freq;
        0 => hpf.freq;
        3000.0 => lpf2.freq;
        1000.0 => hpf2.freq;
        aenv.set(1::ms, 1::ms, 1., 12::ms);
        aenv2.set(1::ms, 1::ms, 1., 2::ms);
        
        makeNote(fund, amp, duration);
    }
    
    /************************************/
    /* Function to actually generate    */
    /* the notes!                       */
    /************************************/
    
    
    private void makeNote ( float fund, float amp, float duration)
    {    
        // TIME VARIABLES:
		Math.pow(amp, 1+amp) => float ampScl;
        // If the bar is struck and allowed to ring, it lasts 24 seconds
        24*ampScl => float fullDecay;
        ((duration/fullDecay)*fullDecay) => float noteDur;
        noteDur::second => dur noteT;
        fullDecay::second => dur T;
        
        /**************************************************************/
        
        
        // DEFINE THE HARMONICS AND ENVELOPES
        // fundamental osc and env (h1, env1)
        fund => drive.freq;
        1 => g9.gain;
        env1.set((.004*T), (.0001*T), amp, (.9995*T));
        amp => env0.gain;
		 
        /**************************************************************/
        
        // TRIGGER THE NOTES
        // key on events
        env1.keyOn(); aenv.keyOn(); aenv2.keyOn();
        // advance to release
        1::ms => now;
        // key off starts release
        env1.keyOff(); aenv.keyOff();aenv2.keyOff();
        // do it!
        noteT => now;
    }
}