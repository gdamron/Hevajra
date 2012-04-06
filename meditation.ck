// argument variables 
int INSTR;
float AMP;


if (me.args())
{
	Std.atoi(me.arg(0)) => INSTR;
}

fun void Phrase (int instr, float amp) 
{
    //intialize reverb
    NRev r => Pan2 p => dac;
    .04 => r.mix;
	
	
    // CREATE INSTRUMENTS AND ARRAY TO HOLD THEIR NAMES
    // Create GAMELAN object
    GAMELAN gam;
    gam.connect(r);
    
    ["jeg", "jub", "cal", "ugal", "pem1", "pem2", "pem3", "pem4"] @=> string gamelan[];
    gamelan[instr] @=> string currentInstr;
    
    // set random panning and amplitude
    Math.rand2(0, 1) => int lr; 
    
    // scale (pentatonic; in semitones) 
    [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] @=> int scale[];
	// counter to control long vs short dur
	0 => int durCount;
	2.4 => float longDur;
	longDur/3 => float shortDur;
	float drt;
	
	while (true) {
		int freq; 
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
				-0.6+lr => p.pan;
				[2, 1, 3, 2, 1, 3, 4, 5] @=> int motif[];
				motif[i%8] => freq;
				gam.jegogan(freq, amp, drt);
			} else if (currentInstr == "jub") {
				-0.5+lr => p.pan;
				[3, 4, 5, 2, 1, 3, 2, 1] @=> int motif[];
				motif[i%8] => freq;
				gam.jublag(freq, amp, drt);
			} else if (currentInstr == "cal") {
				-0.2+lr => p.pan;
				[2, 1, 3, 4, 5, 2, 1, 3] @=> int motif[];
				motif[i%8] => freq;
				gam.calun(freq, amp, drt);
			} else if (currentInstr == "ugal") {
				0.2-lr => p.pan;
				[2, 1, 3, 4, 5, 7, 8, 9, 6, 10] @=> int motif[];
				motif[i] => freq;
				gam.ugal(freq, amp*1.1, drt);
			} else if (currentInstr == "pem1") {
				0.5-lr => p.pan;
				[10, 9, 8, 7, 6, 4, 5, 2, 1, 3] @=> int motif[];
				motif[i] => freq;
				gam.pemade(freq, amp, drt);
			} else if (currentInstr == "pem2") {
				0.6-lr => p.pan;
				[7, 6, 4, 5, 2, 1, 3, 10, 9, 8] @=> int motif[];
				motif[i] => freq;
				gam.pemade(freq, amp, drt);
			} else if (currentInstr == "pem3") {
				-0.55+lr => p.pan;
				[4, 5, 2, 1, 3, 10, 9, 8, 7, 6] @=> int motif[];
				motif[i] => freq;
				gam.pemade(freq, amp, drt);
			} else if (currentInstr == "pem4") {
				-0.65+lr => p.pan;
				[1, 3, 10, 9, 8, 7, 6, 4, 5, 2] @=> int motif[];
				motif[i] => freq;
				gam.pemade(freq, amp, drt);
			}
			// the notes can repeat
			if (Std.rand2(0, 4) != 0) i--;
			// occasionally, the duration can shift by 50%
			if (Std.rand2(0, 127) == 0) {
				T*.5 => now;
			} else if (Std.rand2(0, 127) == 0) {
				T*2.0 => now;
			} else T => now;
		}
	}	
}

Phrase(INSTR, Std.rand2f(0.25, 0.45)); 



