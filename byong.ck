//intialize reverb
NRev r => Pan2 p => dac;
.1 => r.mix;

// CREATE INSTRUMENTS AND ARRAY TO HOLD THEIR NAMES
// Create GAMELAN object
GAMELAN gam;
gam.connect(r);
gam.byong(8.0);