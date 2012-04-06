// a few global variables
// same as rate serial communication speed in max (48000/9600=5)
5::samp => dur Tupdate;
0.0 => float baseFreq;
0 => int channel;

if (me.args()) {
	me.arg(0) => Std.atoi => channel;
}

// CC object
CC cc;
cc.start();

3.2::second => dur T;
T - (now%T) => now;

// important arrays for scale, note durations, octaves and 'meter stretch'
[0, 2, 3, 7, 7, 9, 10, 12] @=> int scale[];
[0.25, .5, .75, 1.0, 1.25] @=> float durs[];
[2.0, 4.0, 4.0, 8.0, 8.0, 16.0] @=> float octaves[];
[1.0, 2.0, 4.0] @=> float durMult[];

fun void doIt()
{
	octaves[Std.rand2(0,octaves.cap()-1)] => float oct;
	durMult[Std.rand2(0, durMult.cap()-1)] => float durMod;
	spork ~ listen() @=> Shred list;
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
	// Oscillators and mix
	SqrOsc s => Gain g => LPF f => Pan2 p => dac;
	p => Gain g2 => NRev r => dac;
	// other levels
	1.0 => g2.gain;
	20000 => f.freq;
	0.08 => g.gain;
	1.0 => r.gain;
	0.0 => s.gain;
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
			baseFreq + baseFreq * bend => s.freq;
			// Y tilt determines filter frequency
			Math.min(Std.fabs(((avY / 127.0)*20000)), 19900.0) => filt;
			Math.max(filt, baseFreq*1.25) => filt => f.freq;
			// X tilt determines panning
			(avX / 55.0) - 1.1 => ppp => p.pan;
			// distance determines gain
			Math.pow(((avV - 40) / 60.0), 2.0) => sinDist => s.gain; 
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
	doIt();
}

// fill variables with real values before messing with them
/*cc.getAccX() => currX => prevX;
cc.getAccY() => currY => prevY;
cc.getAccZ() => currZ => prevZ;
cc.getDist() => currV => prevV;*/
// start the fun
play();
//me.exit();