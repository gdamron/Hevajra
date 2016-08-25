2.4 => float TEMPO;

//intialize reverb
NRev r => Pan2 p => dac;
.1 => r.mix;
	
if (me.args())
{
	Std.atoi(me.arg(0)) => TEMPO;
}

// CREATE INSTRUMENTS AND ARRAY TO HOLD THEIR NAMES
// Create GAMELAN object
GAMELAN gam;
gam.connect(r);

0 => int index;
TEMPO => float duration;
0.6 => float amp;

// wait for byong;
gam.gong(1.0, 8.0);
4::second => now;

while (true) {

	if (index == 0) gam.gong(amp, duration);
	else if (index == 1) gam.kenpur(amp, duration);
	else if (index == 2) gam.klentong(amp, duration);
	else if (index == 3) gam.kenpur(amp, duration);

	duration::second => now;

	index++;
	if (index > 3) {
		index - 4 => index;
	}
}