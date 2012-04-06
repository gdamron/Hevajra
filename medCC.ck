// medCC.ck: listens to the accelerometer and xbee data
// of an external controler, sent as midi cc data

public class CC {
	
	// gloabal variable
	0 => int ccNum;
	0 => int param;
    0 => int dist;
	0 => int accX;
	0 => int accY;
	0 => int accZ;
	0 => int chan;
	
	// number of the device to open (see: chuck --probe)
	0 => int device;
	
	// get command line
	/*if( me.args() ) {
		me.arg(0) => Std.atoi => device;
		//me.arg(1) => Std.atoi => mod;
	}*/
	
	// the midi event
	MidiIn min;
	// the message for retrieving data
	MidiMsg msg;
	
	// open the device
	if( !min.open( device ) ) me.exit();
	
	// print out device that was opened
	<<< "MIDI device:", min.num(), " -> ", min.name() >>>;
	
	fun int getDist()
	{
		return dist;
	}
	
	fun int getAccX()
	{
		return accX;
	}
	
	fun int getAccY()
	{
		return accY;
	}
	
	fun int getAccZ()
	{
		return accZ;
	}
	
	fun int getChan()
	{
		return chan;
	}
	
	fun void updateCC()
	{
		while (true)
		{
			// wait on the event 'min'
			min => now;
			// get the message(s)
			while( min.recv(msg) )
			{
				(msg.data1 & 0x0f) => chan;
				msg.data2 => ccNum;
				msg.data3 => param;
				//<<<chan, ccNum, param>>>;
				if (ccNum == 1) {
					param => dist;
				} else if (ccNum == 2) {
					param => accX;
				} else if (ccNum == 3) {
					param => accY;
				} else if (ccNum == 0) {
					param => accZ;
				}
				//<<<chan, dist, accX, accY, accZ >>>;
			}
		}
	}
	
	fun void start()
	{
		spork ~ updateCC();
	}
}



