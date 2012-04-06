// a few global variables
// same as rate serial communication speed in max (48000/9600=5)
5::samp => dur Tupdate;
5 => int channel;
0.0 => float baseFreq;
1.0 => float bend;
5000.0 => float filt;
float sinDist;
float ppp;
int currC;
int currX;
int prevX;
int currY;
int prevY;
int currZ;
int prevZ;
int currV;
int prevV;

// argument sets which midi channel to listen to
if (me.args() ) {
	me.arg(0) => Std.atoi => channel;
}

// Oscillators and mix
TriOsc s => Gain g => LPF f => Pan2 p => dac;
p => Gain g2 => NRev r => dac;

// CC object
CC cc;
cc.start();

// level to determine when shred exits
0.08 => float outGain;
// other levels
20000 => f.freq;
0.08 => g.gain;
1.0 => g2.gain;
1.0 => r.gain;
0.0 => s.gain;

3.2::second => dur T;

T - (now%T) => now;

// important arrays for scale, note durations, octaves and 'meter stretch'
[0, 2, 3, 7, 7, 9, 10, 12] @=> int scale[];
[0.25, .5, .75, 1.0, 1.25] @=> float durs[];
[2.0, 4.0, 4.0, 8.0, 8.0, 16.0] @=> float octaves[];
[1.0, 2.0, 4.0] @=> float durMult[];

fun void noController()
{
	octaves[Std.rand2(0,octaves.cap()-1)] => float oct;
	durMult[Std.rand2(0, durMult.cap()-1)] => float durMod;
	0 => int counter;
	0.0 => float fadeIn;
	2.0 => float oscGain;
	0.0 => s.gain;
	while ((oscGain - 1) > outGain)
	{
		durs[Std.rand2(0, durs.cap()-1)]*durMod::second => T;
		Std.mtof(scale[Std.rand2(0, scale.cap()-1)]+36)*oct => s.freq;
		Std.rand2f(-1.0, 1.0) => p.pan;
		T => now;
		if (counter < 40) {
			counter++;
			0.025 +=> fadeIn;
			fadeIn => s.gain;
			//<<<fadeIn>>>;
		} else {
			Math.pow(oscGain, 0.96) => oscGain;
			oscGain - 1 => s.gain;
			//<<<oscGain - 1>>>;
		}
	}
}

fun void doIt()
{
	octaves[Std.rand2(0,octaves.cap()-1)] => float oct;
	durMult[Std.rand2(0, durMult.cap()-1)] => float durMod;
	0 => int counter;
	0.0 => s.gain;
	while (true)
	{
		// randomize durations from durs[]
		durs[Std.rand2(0, durs.cap()-1)]*durMod::second => T;
		// pitches selected randomly from scale[]
		(Std.mtof(scale[Std.rand2(0, scale.cap()-1)]+36)*oct) => baseFreq;
		T => now;
	}
}

fun void listen()
{
	int avX;
	int avY;
	int avZ;
	int avV;
	while (true)
	{
		cc.getChan() => currC;
		if (currC == channel)
		{
			// get accelerometer data
			cc.getAccX() => currX;
			cc.getAccY() => currY;
			cc.getAccZ() => currZ;
			cc.getDist() => currV;
			//<<<currC, currX, currY, currZ, currV>>>;
			((currX+prevX)/2) => avX;
			((currY+prevY)/2) => avY;
			((currZ+prevZ)/2) => avZ;
			((currV+prevV)/2) => avV;
			//velocity from accelerometer causes slight pitch bend
			((currZ/30.0) - 1.0) / 50 - 0.02 => bend;
			baseFreq * (1 + bend) => s.freq;
			// Y tilt determines filter frequency
			Math.min(Std.fabs(((avY / 127.0)*20000)), 19900.0) => filt;
			Math.max(filt, baseFreq*1.25) => filt => f.freq;
			// X tilt determines panning
			(avX / 55.0) - 1.1 => ppp => p.pan;
			// distance determines gain
			Math.pow(((avV - 40) / 30.0), 2.0) => sinDist => s.gain; 
			//<<<bend, baseFreq, filt, ppp, sinDist>>>;
			currX => prevX;
			currY => prevY;
			currZ => prevZ;
			currV => prevV;
		}
		Tupdate => now;
	}
}

fun void play()
{
	if (channel == 5) {
		noController();
	} else {
		spork ~ listen();
		doIt();
	}
}

// fill variables with real values before messing with them
cc.getAccX() => currX => prevX;
cc.getAccY() => currY => prevY;
cc.getAccZ() => currZ => prevZ;
cc.getDist() => currV => prevV;
// start the fun
play();
//me.exit();