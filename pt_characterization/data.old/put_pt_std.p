unset key
unset label
unset size
set encoding iso_8859_1
set xlabel "Iterations" font "Times-Roman, 18"
set ytics auto font "Times-Roman, 18"
set format x "%L"
set logscale x 2
set format y "%L"
set term post eps enhanced
set key top left
set xrange [1:21000]
set yrange [0.5:2]
set output 'put_pt_20k_std.eps'
set ylabel "Std. of PT" font "Times-Roman, 18"
set logscale y 2
plot "put1_20k_summary.txt" using 1:9 title "PUT1" with linespoints ls 2, \
     "put2_20k_summary.txt" using 1:9 title "PUT2" with linespoints ls 3
set term X11; replot;
unset key;

