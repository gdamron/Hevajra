// global argument variables
int INSTR;
float AMP;


if (me.args())
{
    Std.atoi(me.arg(0)) => INSTR;
    Std.atof(me.arg(1)) => AMP;
}

fun void Phrase(int instr, float amp)
{
    //intialize reverb
    NRev r => Pan2 p => dac;
    .1 => r.mix;
    
    // CREATE INSTRUMENTS AND ARRAY TO HOLD THEIR NAMES
    // Create GAMELAN object
    GAMELAN gam;
    gam.connect(r);
    
    ["jeg", "jub", "cal", "ugal", "pem", "kan"] @=> string gamelan[];
    gamelan[instr] @=> string currentInstr;
    <<<currentInstr>>>;
    
    // the period 
    .56=> float timeDiv;
    timeDiv::second => dur T;
    int freq;
    
    // set random panning and amplitude
    Math.rand2(0, 1) => int lr;
    //Math.rand2f(0.05, 0.4) => float amp;
    
    // synchronize to period (for on-the-fly synchronization)
    // disable to create a more 'cloud-like' texture
    T - (now % T) => now; 
    
    // scale (pentatonic; in semitones) 
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] @=> int scale[];
    
    // variables for components that encourage variation
    1=> int counter;
    0=> int advance;
    1=> int root;
    float Tscale;
    .725*timeDiv=> float lngNote;
    .525*timeDiv=> float medNote;
    .35*timeDiv=> float shrtNote;
    
    // infinite time loop 
    while( true )
    {    
        // random weights for creating variation 
        Math.rand2(1, 6) => int weight1;
        Math.rand2(1, 5) => int weight2;
        Math.rand2(1, 10) => int weight3;
        // if counter == 1, first note is either C or D depending on weight1
        if (counter == 1) {
            if (weight1 < 2) {
                if (root == 1) {
                    0 => root;
                } else {
                    1 => root;
                }
                scale[root] => freq;
            } else { 
                scale[root] => freq; 
            }
            medNote=> Tscale;
            // cycle through middle portion of phrase    
        } else if (counter < (scale.cap()-2)) {
            scale[counter]-1 => freq;
            if (counter == (scale.cap()-3)) {
                if (weight2 > 1) {
                    medNote=> Tscale;
                } else { 
                    shrtNote=> Tscale;
                }
            } else {
                shrtNote=> Tscale;
            }
            // sometimes a higher note is added to the ended depending of weight2
        } else {
            if (weight2 > 1) {
                // a value of 1 for advance causes no note to be played
                1 => advance;
            } else {
                // occassionally it will the highest note depending on weight3
                if (weight3 > 1) {
                    scale[counter]-1 => freq;
                } else {
                    scale[counter] => freq;
                }
            }
            0 => counter;
            lngNote=> Tscale;   
        }     
        counter++;
        
        // advance time
        if (advance == 1) {
            // skip this note
            0 => advance;
            now => now;
        } else {
            if (currentInstr == "jeg") {
                -0.6+lr => p.pan;
                gam.jegogan(freq, amp, Tscale*4);
            } else if (currentInstr == "jub") {
                -0.5+lr => p.pan;
                gam.jublag(freq, amp, Tscale*2);
            } else if (currentInstr == "cal") {
                -0.2+lr => p.pan;
                gam.calun(freq, amp, Tscale*2);
            } else if (currentInstr == "ugal") {
                0.2-lr => p.pan;
                gam.ugal(freq, amp, Tscale);
            } else if (currentInstr == "pem") {
                0.5-lr => p.pan;
                gam.pemade(freq, amp, Tscale/2);
            } else if (currentInstr == "kan") {
                0.6-lr => p.pan;
                gam.kantil(freq, amp, Tscale/2);
            }
            now => now;
        }
    }
}
<<<INSTR>>>;<<<AMP>>>;
Phrase(INSTR, AMP);
