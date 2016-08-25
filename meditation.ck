// argument variables 
int INSTR;
float TEMPO;
float AMP;


if (me.args())
{
	Std.atoi(me.arg(0)) => INSTR;
	Std.atof(me.arg(1)) => TEMPO;
	<<<"Tempo " + TEMPO>>>;
}

fun void Phrase (int instr, float amp) 
{
    //intialize reverb
    NRev r => Echo d =>  Pan2 p => dac;
    r => p => dac;
    d => Gain fb => d;
    0.5 => d.gain;
    0.75 => fb.gain;
    .15 => r.mix;
    0.45::second => d.delay;
	
	
    // CREATE INSTRUMENTS AND ARRAY TO HOLD THEIR NAMES
    // Create GAMELAN object
    GAMELAN gam;
    gam.connect(r);
    
    ["jeg", "jub", "cal", "ugal", "pem1", "pem2", "pem3", "pem4"] @=> string gamelan[];
    gamelan[instr] @=> string currentInstr;
    
    // set random panning and amplitude
    Math.random2(0, 1) => int lr; 
    
    // scale (pentatonic; in semitones) 
    [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ] @=> int scale[];
	// counter to control long vs short dur
	0 => int durCount;
	TEMPO * 2.0 / 3.0 => float longDur;
	longDur / 3.0 => float shortDur;
	float drt;

	byongNote(currentInstr, gam, p, lr);
	
	while (true) {
		int freq;
		Math.random2( 12, 48 ) => int length;
		int melody[length];


		for( 0 => int j; j < length; j++ ) {
			Math.random2(0, scale.cap()) => melody[j];
		}

		for (0 => int i; i < length; i++) {
			// set random durations
			//(Math.pow(2, (Std.rand2(0,4)))*.4)*Std.rand2(1,2) + Std.rand2f(-.002, .002) => drt;
			
			melody[i] => freq;

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
				-0.6+lr => p.pan;
				// [2, 1, 3, 2, 1, 3, 4, 5] @=> int motif[];
				// motif[i%8] => freq;
				gam.jegogan(freq, amp, drt);
			} else if (currentInstr == "jub") {
				-0.5+lr => p.pan;
				// [3, 4, 5, 2, 1, 3, 2, 1] @=> int motif[];
				// motif[i%8] => freq;
				gam.jublag(freq, amp, drt);
			} else if (currentInstr == "cal") {
				-0.2+lr => p.pan;
				// [2, 1, 3, 4, 5, 2, 1, 3] @=> int motif[];
				// motif[i%8] => freq;
				gam.calun(freq, amp, drt);
			} else if (currentInstr == "ugal") {
				0.2-lr => p.pan;
				// [2, 1, 3, 4, 5, 7, 8, 9, 6, 10] @=> int motif[];
				// motif[i] => freq;
				gam.ugal(freq, amp*1.1, drt);
			} else if (currentInstr == "pem1") {
				0.5-lr => p.pan;
				// [10, 9, 8, 7, 6, 4, 5, 2, 1, 3] @=> int motif[];
				// motif[i] => freq;
				gam.pemade(freq, amp, drt);
			} else if (currentInstr == "pem2") {
				0.6-lr => p.pan;
				// [7, 6, 4, 5, 2, 1, 3, 10, 9, 8] @=> int motif[];
				// motif[i] => freq;
				gam.pemade(freq, amp, drt);
			} else if (currentInstr == "pem3") {
				-0.55+lr => p.pan;
				// [4, 5, 2, 1, 3, 10, 9, 8, 7, 6] @=> int motif[];
				// motif[i] => freq;
				gam.kantil(freq, amp, drt);
			} else if (currentInstr == "pem4") {
				-0.65+lr => p.pan;
				// [1, 3, 10, 9, 8, 7, 6, 4, 5, 2] @=> int motif[];
				// motif[i] => freq;
				gam.kantil(freq, amp, drt);
			}
			// the notes can repeat
			if (Std.rand2(0, 4) != 0) i--;
			// occasionally, the duration can shift by 50%
			if (Std.rand2(0, 127) == 0) {
				T/3.0 => now;
			} else if (Std.rand2(0, 127) == 0) {
				T*2.0 => now;
			} else T => now;
		}
	}	
}

fun void byongNote(string instr, GAMELAN gam, Pan2 p, int lr) {

	4.0 => float drt;
	0.4 => float amp;

	if (instr == "jeg") {
		-0.6+lr => p.pan;
		gam.jegogan(3, amp, drt);
	} else if (instr == "jub") {
		-0.5+lr => p.pan;
		gam.jublag(3, amp, drt);
	} else if (instr == "cal") {
		-0.2+lr => p.pan;
		gam.calun(5, amp, drt);
	} else if (instr == "ugal") {
		0.2-lr => p.pan;
		gam.ugal(2, amp*1.1, drt);
	} else if (instr == "pem1") {
		0.5-lr => p.pan;
		gam.pemade(7, amp, drt);
	} else if (instr == "pem2") {
		0.6-lr => p.pan;
		gam.pemade(9, amp, drt);
	} else if (instr == "pem3") {
		-0.55+lr => p.pan;
		gam.kantil(7, amp, drt);
	} else if (instr == "pem4") {
		-0.65+lr => p.pan;
		gam.kantil(9, amp, drt);
	}

	drt::second => now;
}

Phrase(INSTR, Std.rand2f(0.2, 0.4)); 



