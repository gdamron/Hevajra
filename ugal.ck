/***************************************/
/* Ugal: instrument to generate       */
/* tones according to pelog scale      */
/***************************************/

public class UGAL
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
        Noise att1 => LPF lpf => ADSR aenv => env0;
        Noise att2 => LPF lpf2 => HPF hpf => ADSR aenv2 => env0;
        1.0 => att1.gain;
        0.4 => att2.gain;
        
    /************************************************************/
    
    public void connect( UGen u ) {
        0.0 => env0.gain;
        env0 => u;
    }
    
    public void makeNote ( int degree, float amp, float duration)
    {
        // Tuning based on Gamelan Galak Tika's pelog -- 0 triggers attack only
        [0.0, 305.96, 328.147, 418.07, 451.13, 571.338, 611.92, 662.878, 827.531, 885.9, 1150.304] @=> float tuning[];
        (tuning.cap()-1) %=> degree;               // 'wrap around' note if it is out of range
        tuning[degree]*2 => float fund;  
                  
        // TIME VARIABLES:
        // If the bar is struck and allowed to ring, it lasts 24 seconds
        24 => int fullDecay;
        ((duration/fullDecay)*fullDecay) => float noteDur;
        noteDur::second => dur noteT;
        24::second => dur T;
        
        /**************************************************************/
        
        // DEFINE THE HARMONICS AND ENVELOPES
        // fundamental osc and env (h1, env1)
        fund => h1.freq;
        1 => h1.gain;
        env1.set((.0001*T), (.0001*T), amp, (.9998*T));
        // h2, env2
        fund*2 => h2.freq;
        .003 => h2.gain;
        env2.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.1);
        // h3, env3
        fund*2.76132 => h3.freq;
        .0004 => h3.gain;
        env3.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.05);
        // h4, env4
        fund*4 => h4.freq;
        .0004 => h4.gain;
        env4.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.25);
        // h5, env5
        fund*5.33333 => h5.freq;
        .003 => h5.gain;
        env5.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.008);
        // h6, env6
        fund*5.6 => h6.freq;
        .008 => h6.gain;
        env6.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.1);
        // h7, env7
        fund*6.4 => h7.freq;
        .015 => h7.gain;
        env7.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.0075);
        // h8, env8
        fund*7.4 => h8.freq;
        .04 => h8.gain;
        env8.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.005);
        // h9, env9
        fund*8.75 => h9.freq;
        .04 => h9.gain;
        env9.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.0025);
        // h10, env10
        fund*9.64286 => h10.freq;
        .05 => h10.gain;
        env10.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.0205);
        // h11, env11
        fund*11 => h11.freq;
        .025 => h11.gain;
        env11.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.00013);
        // h12, env12
        fund*12.5 => h12.freq;
        .025 => h12.gain;
        env12.set((.0001*T), (.0001*T), (amp), (.9998*T)*.00005);
        // h13, env13
        fund*16.5696 => h13.freq;
        .04 => h13.gain;
        env13.set((.0001*T), (.0001*T), (amp), (.9998*T)*0.0005);
        
        // FOR ATTACK
        600.0 => lpf.freq;
        8000.0 => lpf2.freq;
        1000.0 => hpf.freq;
        aenv.set(1::ms, 1::ms, 1., 12::ms);
        aenv2.set(1::ms, 1::ms, 1., 2::ms);

        1.0 => env0.gain; 
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
/* The end */