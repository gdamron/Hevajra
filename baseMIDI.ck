// argument variables 
int INSTR;
int AMP;

if (me.args())
{
	Std.atoi(me.arg(0)) => INSTR;
	Std.atoi(me.arg(1)) => AMP;
	<<<AMP>>>;
}

fun void Phrase (int instr, int amp) 
{	
	// OR create a MIDI out object
	MidiOut mout;
	MidiMsg msg;
	mout.open(0);
	if (!mout.open(0)) {me.exit();}
	128 => msg.data1;
	0 => msg.data2;
	0 => msg.data3;
	mout.send(msg);
    
    // set random panning and amplitude
    Math.rand2(0, 1) => int lr; 
	amp => int prevAmp;
	115 => int ampOut; 
	0 => int velCount;
	   
    // scale (pentatonic; in semitones) 
    [ 0, 3, 3, 5, 7, 7, 7, 7, 9, 10, 10, 10 ] @=> int scale[];
	
	// counter to control long vs short dur
	0 => int durCount;
	.26 => float shortDur;
	shortDur*3 => float longDur;
	float drt;
	
	while (true) {
		int freq; 
		int mNote;
		0 => int oct;
		for (0 => int i; i < 10; i++) {
			// set random durations
			//(Math.pow(2, (Std.rand2(0,4)))*.4)*Std.rand2(1,2) + Std.rand2f(-.002, .002) => drt;
			
			// set altenating short and long durations
			shortDur + Std.rand2f(-.001, .001) => drt;
			
			
			
			drt::second => dur T;
			
			if (instr==0) {
				
				[2, 1, 2, 1, 2, 1, 3, 1] @=> int motif1[];
				scale[motif1[i%8]] => freq;
				0 => oct;
				36 + freq + oct*12 => mNote;
				
			} else if (instr==1) {
				
				[3, 4, 5, 4, 5, 4, 4, 3] @=> int motif2[];
				scale[motif2[i%8]] => freq;
				1 => oct;
				36 + freq + oct*12 => mNote;
				
			} else if (instr==2) {
				
				[2, 1, 3, 4, 5, 2, 1, 3] @=> int motif3[];
				scale[motif3[i%8]] => freq;
				1 => oct;
				36 + freq + oct*12 => mNote;
				
			} else if (instr==3) {
				
				[2, 1, 3, 4, 5, 7, 8, 9, 6, 10] @=> int motif4[];
				scale[motif4[i]] => freq;
				2 => oct;
				36 + freq + oct*12 => mNote;
				
			} else if (instr==4) {
				
				[10, 9, 8, 7, 6, 4, 5, 2, 1, 3] @=> int motif5[];
				scale[motif5[i]] => freq;
				2 => oct;
				36 + freq + oct*12 => mNote;
				
			} else if (instr==5) {
				
				[7, 6, 4, 5, 2, 1, 3, 10, 9, 8] @=> int motif6[];
				scale[motif6[i]] => freq;
				3 => oct;
				36 + freq + oct*12 => mNote;
				
			} else if (instr==6) {
				
				[4, 5, 2, 1, 3, 10, 9, 8, 7, 6] @=> int motif7[];
				scale[motif7[i]] => freq;
				3 => oct;
				36 + freq + oct*12 => mNote;
				
			} else if (instr==7) {
				
				[1, 3, 10, 9, 8, 7, 6, 4, 5, 2] @=> int motif8[];
				scale[motif8[i]] => freq;
				3 => oct;
				36 + freq + oct*12 => mNote;
				
			}
			 
			144 => msg.data1;
			mNote => msg.data2;
			// occassional accent
			if (Std.rand2(0,3)==0) {
				amp + Std.rand2(24, 36) => msg.data3;
			} else {
				amp + Std.rand2(-4, 4) => msg.data3;
			}
			
			mout.send(msg);

			
			// the notes can repeat
			if (Std.rand2(0, 4) != 0) i--;
			T => now;
			if (i == 9) 0 => i;
			128 => msg.data1;
			0 => msg.data3;
			mout.send(msg);
		}
	}	
}

Phrase(INSTR, AMP); 



