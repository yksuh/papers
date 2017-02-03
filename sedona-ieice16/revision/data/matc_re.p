unset key
unset label
unset size
set datafile missing "?"
set logscale x 2
set logscale y 2
set encoding iso_8859_1
set xlabel "Matrix size in log scale" font "Times-Roman, 20"
set ylabel "Relative error in log scale" font "Times-Roman, 22"
set xtics ("1000x1000" 1000, "2000x2000" 2000, "4000x4000" 4000, "8000x8000" 8000) font "Times-Roman, 20"
set ytics auto font "Times-Roman, 18"
#set format y "10^{%L}"
set format "%2.0t{/Symbol \264}10^{%L}"
set term post eps enhanced
set key top font "Times-Roman, 18"
set xrange [900:9000]
set yrange [0.000001:0.001]
set output 'matc_re.eps'
plot "matc.dat" using 1:($3) title "ORG" with linespoint ls 5,\
     "matc.dat" using 1:($5) title "SED0NA" with linespoint ls 6
set term X11; 
replot;
unset key;
