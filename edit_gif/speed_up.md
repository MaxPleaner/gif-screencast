Find the current delay between frames:

`convert -limit memory 1 -limit map 1 -layers Optimize out.gif out_optimised.gif;`

Change the delay between frames:

`convert -delay 1x30 out.gif out_faster.gif`
