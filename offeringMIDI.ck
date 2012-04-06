// the period 
.5::second => dur T;
int freq;

// set random octave
0 => int oct;

// synchronize to period (for on-the-fly synchronization)
// disable to create a more 'cloud-like' texture
T - (now % T) => now;

// the oscialtor/cheesy reverb patch 
//SinOsc s => JCRev r => dac; 

// OR create a MIDI out object
MidiOut mout;
MidiMsg msg;
mout.open(3);
//if (!mout.open(0)) {me.exit();}

// initialize
//.005 => s.gain; 
//.85 => r.mix;

// scale (pentatonic; in semitones) 
[ 0, 2, 7, 9, 10, 14 ] @=> int scale[];

// variables for components that encourage variation
1=> int counter;
0=> int advance;
1=> int root;
int mNote;
float Tscale;
.35=> float lngNote;
.3=> float medNote;
.25=> float shrtNote;

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
        lngNote=> Tscale;
        // cycle through middle portion of phrase    
    } else if (counter < (scale.cap()-1)) {
        scale[counter] => freq;
        if (counter == (scale.cap()-2)) {
            medNote=> Tscale;
        } else {
            shrtNote=> Tscale;
        }
        // sometimes a high D is added to the ended depending of weight2
    } else {
        if (weight2 > 1) {
            // a value of 1 for advance causes no note to be played
            1 => advance;
        } else {
            // occassionally it will be Eb depending on weight3
            if (weight3 > 1) {
                scale[counter] => freq;
            } else {
                scale[counter]+1 => freq;
            }
        }
        0 => counter;
        medNote=> Tscale;   
    }     
    counter++;
       
    // get the final freq
    (48 + freq + oct*12)=> mNote;
    // send MIDI data
    144=> msg.data1;
    mNote => msg.data2;
    32 => msg.data3;
    mout.send(msg);
    //<<<msg.data2>>>;
    // advance time
    if (advance == 1) {
        // skip this note
        0 => advance;
        now => now;
    } else {
        Tscale::T => now;
        // stop previous note
        //0=> msg.data3;
        128=> msg.data1;
        mout.send(msg);
    }
}