.26::second => dur T;
T - (now % T) => now;

Machine.add("baseMIDI.ck:0:72");
Machine.add("baseMIDI.ck:1:72");
T*16 => now;
Machine.add("baseMIDI.ck:2:72");
Machine.add("baseMIDI.ck:3:72");
T*16 => now;
Machine.add("baseMIDI.ck:4:72");
Machine.add("baseMIDI.ck:5:72");
Machine.add("baseMIDI.ck:6:72");
Machine.add("baseMIDI.ck:7:72");
