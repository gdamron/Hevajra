/* Testing*/

CALUN calun;
calun.connect(dac);
.06 => float duration;
(duration*1000)::ms => dur T;
1.0 => float amp;

while (true)
{
    Std.rand2(0,8) => int degree;
    calun.makeNote(degree, amp, duration);
    T => now;
}
    