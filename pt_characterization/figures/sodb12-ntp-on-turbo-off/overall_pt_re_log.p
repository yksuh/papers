unset key
unset label
unset size
set encoding iso_8859_1
set xlabel "Task Length (sec)" font "Times-Roman, 18"
set ytics auto font "Times-Roman, 18"
#set logscale x 2
set term post eps enhanced
set key top left
set xrange [0.8:2500]
set output 'overall_pt_re_log.eps'
set ylabel "Standard Deviation of Process Time (msec)" font "Times-Roman, 18"
plot "overall_pt.dat" using 1:($6)/($5) title "Rel. Err. of Process Time over Increasing Task Length" with linespoint
set term X11; replot;
unset key;

