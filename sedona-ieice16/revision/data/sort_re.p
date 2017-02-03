unset key
unset label
unset size
set datafile missing "?"
set logscale x 2
set logscale y 2
set encoding iso_8859_1
set xlabel "\# of elements in log scale" font "Times-Roman, 20"
set ylabel "Relative error in log scale" font "Times-Roman, 22"
set xtics ("100K" 100000, "200K" 200000, "400K" 400000, "800K" 800000, "1600K" 1600000, "3200K" 3200000) font "Times-Roman, 20"
set ytics auto font "Times-Roman, 18"
set format "%2.0t{/Symbol \264}10^{%L}"
set term post eps enhanced
set key top right font "Times-Roman, 18"
set xrange [90000:3500000]
set yrange [0.000001:0.001]
set output 'sort_re.eps'
plot "sort.dat" using 1:($3) title "ORG" with linespoint ls 5,\
     "sort.dat" using 1:($5) title "SEDONA" with linespoint ls 6 
set term X11; 
replot;
unset key;
