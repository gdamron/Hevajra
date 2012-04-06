SinOsc s => Gain g => Pan2 p => dac;
p => Gain g2 => NRev r => dac;

// level to determine when shred exits
0.08 => float outGain;
// other levels
0.08 => g.gain;
1.0 => g2.gain;
1.0 => r.gain;
0 => s.gain;
0.2 => float velocity;

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
			<<<fadeIn>>>;
		} else {
			Math.pow(oscGain, 0.96) => oscGain;
			oscGain - 1 => s.gain;
			<<<oscGain - 1>>>;
		}
		
	}
}

doIt();
me.exit();


