/******************************************/
/* offeringGam.ck: essentially, this is a */
/* score to implement the "offeringCalung"*/
/* compositional algorithm in several     */
/* layers.  Not incredibly interesting on */
/* its own, and certainly not an elegant  */
/* implementation.     by Grant Damron    */
/******************************************/

// include the GAMELAN class implemented by offeringCalung
Machine.add("gamelanClass.ck");
// add 8 iterations of offeringCalung.ck
Machine.add("offeringCalung.ck:2:0.2");
Std.rand2(4,12)::second => now;
Machine.add("offeringCalung.ck:4:0.1");
Std.rand2(3,8)::second => now;
Machine.add("offeringCalung.ck:5:0.1");
Std.rand2(3,8)::second => now;
Machine.add("offeringCalung.ck:0:0.1");
Std.rand2(3,8)::second => now;
Machine.add("offeringCalung.ck:1:0.2");
Std.rand2(3,8)::second => now;
Machine.add("offeringCalung.ck:0:0.1");
Std.rand2(3,8)::second => now;
Machine.add("offeringCalung.ck:5:0.1");
Std.rand2(3,8)::second => now;
Machine.add("offeringCalung.ck:3:0.225");
// hold for a little bit
Std.rand2(24,48)::second => now;
// and start removing them, but more quickling then they were added
Machine.remove(3);
Machine.remove(7);
Std.rand2(3,8)::second => now;
Machine.remove(4);
Machine.remove(8);
Std.rand2(3,8)::second => now;
Machine.remove(6);
Std.rand2(12,16)::second => now;
Machine.remove(5);
Machine.remove(9);
Std.rand2(12,16)::second => now;
Machine.remove(10);