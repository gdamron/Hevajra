// the period 
.28::second => dur T;
float freq;

// set deom octave
Math.random2(0, 3) => int oct;

// synchronize to period (for on-the-fly synchronization)
// disable to create a more 'cloud-like' texture
T - (now % T) => now;
 
// the oscialtor/cheesy reverb patch 
TriOsc s => JCRev r => dac; 

// initialize
.005 => s.gain; 
.85 => r.mix;

// scale (pentatonic; in semitones) 
[ 0, 2, 7, 9, 10, 14 ] @=> int scale[];

// variables for components that encourage variation
1=> int counter;
0=> int advance;
1=> int root;
float Tscale;
.725=> float lngNote;
.525=> float medNote;
.4=> float shrtNote;

// infinite time loop 
while( true )
{    
    // random weights for creating variation 
    Math.random2(1, 6) => int weight1;
    Math.random2(1, 5) => int weight2;
    Math.random2(1, 10) => int weight3;
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
    } else if (counter < (scale.cap()-1)) {
        scale[counter] => freq;
        if (counter == (scale.cap()-2)) {
            if (weight2 > 1) {
                medNote=> Tscale;
            } else { 
                shrtNote=> Tscale;
            }
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
         lngNote=> Tscale;   
    }     
    counter++;
    // get the final freq
    Std.mtof(48 + freq + oct*12) => s.freq;
    // reset phase for extra bandwidth 
    0 => s.phase;
    // advance time
    if (advance == 1) {
        // skip this note
        0 => advance;
        now => now;
    } else {
        Tscale::T => now;
    }
 }