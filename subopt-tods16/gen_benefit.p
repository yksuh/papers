unset key
unset label
unset size
set encoding iso_8859_1
set xtics 4,1,13 font "Times-Roman, 18"
#set ytics -0.30,0.03,0.30 font "Times-Roman, 18"
set ytics ("-0.300" -0.3, "-0.270" -0.27, "-0.240" -0.24, "-0.210" -0.21, "-0.180" -0.18, "-0.150" -0.15, "-0.120" -0.12, "-0.0900" -0.09, "-0.0600" -0.06, "-0.0300" -0.03, "0" 0, "0.0300" 0.03, "0.0600" 0.06, "0.0900" 0.0900, "0.120" 0.12, "0.150" 0.15, "0.180" 0.18, "0.210" 0.21, "0.240" 0.24, "0.27" 0.27, "0.3" 0.3) font "Times-Roman, 18"
set term post eps enhanced
set output 'gen_benefit.eps'
#set key top left
set key at 6.8,-0.22
set format y "%.4f"
set xrange [3:14]
set yrange [-0.30:0.30]
set xlabel "{/Times-Bold-Italic Generation}" font "Times-Roman, 18"
set ylabel "{/Times-Bold-Italic Cumulative average relative delta}" font "Times-Roman, 18" 
set style line 1 lt 1 lw 1 pt 145 
set style line 2 lt 1 lw 3 pt 82
set style line 3 lt 1 lw 1 pt 147
set xzeroaxis lt 4
plot "gen_benefit.dat" using 1:($2) title "Not suboptimal" with linespoint ls 1,\
     "gen_benefit.dat" using 1:($3) title "Weighted (Net benefit)" with linespoint ls 2,\
     "gen_benefit.dat" using 1:($4) title "Suboptimal" with linespoint ls 3
set term X11; replot;
unset key;
