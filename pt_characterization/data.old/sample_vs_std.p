unset key
unset label
unset size
set encoding iso_8859_1
set xlabel "Sample Size" font "Times-Roman, 18"
set ytics auto font "Times-Roman, 18"
#set format x "%L"
#set logscale x 2
#set format y "%L"
set term post eps enhanced
set key top left
set xrange [0:21000]
set yrange [0:2]
set output 'put_pt_std.eps'
set ylabel "Std. of PT" font "Times-Roman, 18"
#set logscale y 2
plot "put1_20k_std.dat" using 1:2 title "PUT1" with linespoints ls 2
     "put2_20k_std.dat" using 1:2 title "PUT2" with linespoints ls 2
set term X11; replot;
unset key;

