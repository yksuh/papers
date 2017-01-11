unset key
unset label
unset size
set encoding iso_8859_1
set xlabel "Task length (sec) in log_{2} scale" font "Times-Roman, 18"
set ytics auto font "Times-Roman, 18"
set format x "%L"
set logscale x 2
set format y "%L"
set term post eps enhanced
set key top left
set xrange [1:64]
set output 'overall_pt_diff.eps'
set ylabel "Max-Min diff. of PT in log_{2} scale" font "Times-Roman, 18"
set logscale y 2
plot "overall_pt_diff.dat" using 1:($2) title "Max-Min diff. of PT over increasing task length" with linespoint
set term X11; replot;
unset key;

