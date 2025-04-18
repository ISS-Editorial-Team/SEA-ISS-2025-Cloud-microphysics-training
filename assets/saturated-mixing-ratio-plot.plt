#saturated-mixing-ratio-plot.plt

reset
set terminal qt enhanced font "Arial,16" size 800,600

set xlabel "Temperature"
set ylabel "Pressure"
set zlabel "Saturated Mixing Ratio" rotate by 90

set dgrid3d 50,50 spline
set hidden3d

splot \
  "saturated-mixing-ratio.dat" using 1:2:3 with lines lw 2 lc rgb "forest-green"   title "Surrogate Model Outputs", \
  ""                     using 1:2:4 with lines lw 2 lc rgb "skyblue"  title "Physics-based Model Outputs"
