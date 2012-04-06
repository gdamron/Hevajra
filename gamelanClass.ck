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
    // INITIALIZE OSCILLATORS
    SinOsc h1 => ADSR env1 => Gain env0;
    SinOsc h2 => ADSR env2 => env0;
    SinOsc h3 => ADSR env3 => env0;
    SinOsc h4 => ADSR env4 => env0;
    SinOsc h5 => ADSR env5 => env0;
    SinOsc h6 => ADSR env6 => env0;
    SinOsc h7 => ADSR env7 => env0;
    SinOsc h8 => ADSR env8 => env0;
    SinOsc h9 => ADSR env9 => env0;
    SinOsc h10 => ADSR env10 => env0;
    SinOsc h11 => ADSR env11 => env0;
    SinOsc h12 => ADSR env12 => env0;
    SinOsc h13 => ADSR env13 => env0;
    // INITIALIZE ATTACK NOISE
    Noise att1 => LPF lpf => HPF hpf => ADSR aenv => env0;
    Noise att2 => LPF lpf2 => HPF hpf2 => ADSR aenv2 => env0;
    
    public void connect( UGen u ) {
        0.0 => env0.gain;
        env0 => u;
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
        fund => h1.freq;
        1 => h1.gain;
        env1.set((.004*T), (.0001*T), amp, (.9995*T));
        // h2, env2
        fund*2 => h2.freq;
        .008 => h2.gain;
        env2.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.6*ampScl));
        // h3, env3
        fund*2.76132 => h3.freq;
        .004 => h3.gain;
        env3.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.2*ampScl));
        // h4, env4
        fund*4 => h4.freq;
        .0005 => h4.gain;
        env4.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.25*ampScl));
        // h5, env5
        fund*5.33333 => h5.freq;
        .004 => h5.gain;
        env5.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.008*ampScl));
        // h6, env6
        fund*5.6 => h6.freq;
        .02 => h6.gain;
        env6.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.1*ampScl));
        // h7, env7
        fund*6.4 => h7.freq;
        .04 => h7.gain;
        env7.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.0075*ampScl));
        // h8, env8
        fund*7.4 => h8.freq;
        .05 => h8.gain;
        env8.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.005*ampScl));
        // h9, env9
        fund*8.75 => h9.freq;
        .05 => h9.gain;
        env9.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.0025*ampScl));
        // h10, env10
        fund*9.64286 => h10.freq;
        .06 => h10.gain;
        env10.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.0205*ampScl));
        // h11, env11
        fund*11 => h11.freq;
        .03 => h11.gain;
        env11.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.00013*ampScl));
        // h12, env12
        fund*12.5 => h12.freq;
        .03 => h12.gain;
        env12.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.00005*ampScl));
        // h13, env13
        fund*16.5696 => h13.freq;
        .05 => h13.gain;
        env13.set((.004*T), (.0001*T), (amp), (.9995*T)*(0.0005*ampScl));
        
        
        amp => env0.gain; 
        /**************************************************************/
        
        // TRIGGER THE NOTES
        // key on events
        env1.keyOn(); env2.keyOn(); env3.keyOn();
        env4.keyOn(); env5.keyOn();env6.keyOn(); env7.keyOn();
        env8.keyOn(); env9.keyOn(); env10.keyOn(); env11.keyOn();
        env12.keyOn(); env13.keyOn(); aenv.keyOn(); aenv2.keyOn();
        // advance to release
        1::ms => now;
        // key off starts release
        env1.keyOff(); env2.keyOff(); env3.keyOff();
        env4.keyOff(); env5.keyOff(); env6.keyOff(); env7.keyOff();
        env8.keyOff(); env9.keyOff(); env10.keyOff(); env11.keyOff();
        env12.keyOff(); env13.keyOff(); aenv.keyOff();aenv2.keyOff();
        // do it!
        noteT => now;
    }
}