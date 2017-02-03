unset key
unset label
unset size
set datafile missing "?"
set logscale x 2
set logscale y 2
set encoding iso_8859_1
set xlabel "Matrix size in log scale" font "Times-Roman, 20"
set ylabel "Standard deviation (ms) in log scale" font "Times-Roman, 22"
set xtics ("1000x1000" 1000, "2000x2000" 2000, "4000x4000" 4000, "8000x8000" 8000) font "Times-Roman, 20"
set ytics auto font "Times-Roman, 18"
set term post eps enhanced
set key bottom font "Times-Roman, 18"
set xrange [900:9000]
set yrange [0.5:70]
set output 'matc_std.eps'
plot "matc.dat" using 1:($2) title "ORG" with linespoint ls 5,\
     "matc.dat" using 1:($4) title "SEDONA" with linespoint ls 6
set term X11; 
replot;
unset key;
