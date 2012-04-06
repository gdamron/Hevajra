
//intialize reverb
/*NRev r => Pan2 p => dac;
.1 => r.mix;*/
HPF hpf => dac;
20 => hpf.freq;

// synchronize to period (for on-the-fly synchronization)
// disable to create a more 'cloud-like' texture
//T - (now % T) => now;

// CREATE INSTRUMENTS AND ARRAY TO HOLD THEIR NAMES
// Create GAMELAN object
GAMELAN gam;
gam.connect(hpf);

gam.pemade(Std.atoi(me.arg(0)), 1, 24);