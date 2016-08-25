// argument variables 
int INSTR;
float AMP;
GAMELAN gam;

if (me.args())
{
	Std.atoi(me.arg(0)) => INSTR;
}

fun void Phrase (int instr, int amp) 
{	
	// OR create a MIDI out object
	MidiOut mout;
	MidiMsg msg;
	//mout.open(0);
	//if (!mout.open(0)) {me.exit();}
	128 => msg.data1;
	0 => msg.data2;
	0 => msg.data3;
	//mout.send(msg);
    
    // set random panning and amplitude
    Math.random2(0, 1) => int lr; 
	amp => int prevAmp;
	115 => int ampOut; 
	0 => int velCount;
	   
    // scale (pentatonic; in semitones) 
    [ 0, 3, 3, 5, 7, 7, 7, 7, 9, 10, 10, 10 ] @=> int scale[];
	["jeg", "jub", "cal", "ugal", "pem1", "pem2", "pem3", "pem4"] @=> string gamelan[];
    gamelan[instr] @=> string currentInstr;
	// counter to control long vs short dur
	0 => int durCount;
	2.4 => float longDur;
	longDur/3 => float shortDur;
	float drt;
	
	while (true) {
		int freq; 
		int mNote;
		0 => int oct;
		for (0 => int i; i < 10; i++) {
			// set random durations
			//(Math.pow(2, (Std.rand2(0,4)))*.4)*Std.rand2(1,2) + Std.rand2f(-.002, .002) => drt;
			
			// set altenating short and long durations
			if (durCount == 0) {
				1 => durCount;
				longDur + Std.rand2f(-.001, .001) => drt;
			} else {
				0 => durCount;
				shortDur + Std.rand2f(-.001, .001) => drt;
			}
			
			
			drt::second => dur T;
			if (currentInstr == "jeg") {
				//-0.6+lr => p.pan;
				[2, 1, 3, 2, 1, 3, 4, 5] @=> int motif[];
				scale[motif[i%8]] => freq;
				0 => oct;
                gam.jegogan(freq, amp, drt);
			} else if (currentInstr == "jub") {
				//-0.5+lr => p.pan;
				[3, 4, 5, 2, 1, 3, 2, 1] @=> int motif[];
				scale[motif[i%8]] => freq;
				1 => oct;
				gam.jublag(freq, amp, drt);
			} else if (currentInstr == "cal") {
				//-0.2+lr => p.pan;
				[2, 1, 3, 4, 5, 2, 1, 3] @=> int motif[];
				scale[motif[i%8]] => freq;
				1 => oct;
				gam.calun(freq, amp, drt);
			} else if (currentInstr == "ugal") {
				//0.2-lr => p.pan;
				[2, 1, 3, 4, 5, 7, 8, 9, 6, 10] @=> int motif[];
				scale[motif[i]] => freq;
				2 => oct;
				gam.ugal(freq, amp*1.1, drt);
			} else if (currentInstr == "pem1") {
				//0.5-lr => p.pan;
				[10, 9, 8, 7, 6, 4, 5, 2, 1, 3] @=> int motif[];
				scale[motif[i]] => freq;
				2 => oct;
				gam.pemade(freq, amp, drt);
			} else if (currentInstr == "pem2") {
				//0.6-lr => p.pan;
				[7, 6, 4, 5, 2, 1, 3, 10, 9, 8] @=> int motif[];
				scale[motif[i]] => freq;
				2 => oct;
				gam.pemade(freq, amp, drt);
			} else if (currentInstr == "pem3") {
				//-0.55+lr => p.pan;
				[4, 5, 2, 1, 3, 10, 9, 8, 7, 6] @=> int motif[];
				scale[motif[i]] => freq;
				3 => oct;
				gam.pemade(freq, amp, drt);
			} else if (currentInstr == "pem4") {
				//-0.65+lr => p.pan;
				[1, 3, 10, 9, 8, 7, 6, 4, 5, 2] @=> int motif[];
				scale[motif[i]] => freq;
				3 => oct;
				gam.pemade(freq, amp, drt);
			}
			
			
			24 + freq + oct*12 => mNote;
			144 => msg.data1;
			mNote => msg.data2;
			amp => msg.data3;
			
			//mout.send(msg);
			
			// the notes can repeat
			if (Std.rand2(0, 4) != 0) i--;
			// occasionally, the duration can shift by 50%
			if (Std.rand2(0, 127) == 0) {
				T*.5 => now;
			} else if (Std.rand2(0, 127) == 0) {
				T*2.0 => now;
            } else {
                T => now;
            }
            
			if (i == 9) 0 => i;
			128 => msg.data1;
			0 => msg.data3;
			//mout.send(msg);
			// control velocities
			if (prevAmp < 116) {
				1 +=> prevAmp;
				prevAmp => amp;
				<<<prevAmp>>>;
			} else if (velCount < 20) {
				116 => amp;
				velCount++;
				<<<velCount>>>;
			} else if (ampOut > 3) {
				2 -=> ampOut;
				ampOut => amp;
				<<<ampOut>>>;
			} else { me.exit(); }
		}
	}	
}

Phrase(INSTR, 8); 



