PulseOsc s => Gain g => LPF f => Pan2 p => dac;
p => Gain g2 => BPF r => dac;

CC cc;
cc.start();

// level to determine when shred exits
0.08 => float outGain;
// other levels
10000 => f.freq;
0.08 => g.gain;
1.0 => g2.gain;
1.0 => r.gain;
0 => s.gain;

3.2::second => dur T;

T - (now%T) => now;

[0, 2, 3, 7, 7, 9, 10, 12] @=> int scale[];
[0.25, .5, .75, 1.0, 1.25] @=> float durs[];
[2.0, 4.0, 4.0, 8.0, 8.0, 16.0] @=> float octaves[];
[1.0, 2.0, 4.0] @=> float durMult[];

fun void doIt()
{
	octaves[Std.rand2(0,octaves.cap()-1)] => float oct;
	durMult[Std.rand2(0, durMult.cap()-1)] => float durMod;
	0 => int counter;
	0.0 => float fadeIn;
	2.0 => float oscGain;
	0.0 => s.gain;
	0.0 => float ggg;
	1.0 => float bend;
	5000.0 => float filt;
	while (true)
	{
		// randomize durations from durs[]
		durs[Std.rand2(0, durs.cap()-1)]*durMod::second => T;
		// velocity from accelerometer causes slight pitch bend
		((cc.getAccZ()/30.0) - 1.0) / 50 - 0.02 => bend;
		// pitches selected randomly from scale[]
		(Std.mtof(scale[Std.rand2(0, scale.cap()-1)]+36)*oct) => float baseFreq;
		baseFreq + baseFreq * bend => s.freq;
		// Y tilt determines filter frequency
		Math.min(Std.fabs(((cc.getAccY() / 127.0)*10000)), 9900.0) => filt;
		Math.max(filt, baseFreq) => filt => f.freq;
		// X tilt determines panning
		(cc.getAccX() / 55.0) - 1.1 => float ppp => p.pan;
		// distance determines gain
		Math.pow(((cc.getDist() - 40) / 60.0), 2.0) => float sinDist => s.gain; 
		<<<bend, baseFreq, filt, ppp, sinDist>>>;
		T => now;
	}
}

doIt();
me.exit();


