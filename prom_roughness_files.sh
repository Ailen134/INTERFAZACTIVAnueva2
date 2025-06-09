files="cmlog_*_.dat"

samples=$(ls $files | wc -l)

paste $files | \
awk -v N=$samples '{\
  for(i=0;i<6;i++){acum[i]=0; acum2[i]=0;} \
  for(j=1;j<=NF;j++){\
    acum[(j-1)%6]+=$j; \
    acum2[(j-1)%6]+=$j*$j; \
  } \
  if(NR>1){ \
    # Promedios \
    for(i=0;i<6;i++){printf("%f ", acum[i]/N);} \
    # Desviación estándar \
    for(i=0;i<6;i++){printf("%f ", sqrt(acum2[i]/N - (acum[i]/N)**2));} \
    # Varianza (w^2) \
    for(i=0;i<6;i++){printf("%f ", acum2[i]/N - (acum[i]/N)**2);} \
    printf("\n"); \
  } \
}' > "roughness_"$samples"samples.dat"

file="roughness_"$samples"samples.dat"
echo $file

gnuplot -p -e "
  set term png;
  set output 'roughness.png';
  set logscale xy;
  set xlabel 'Tiempo (t)';
  set ylabel 'w^2 (varianza)';
  plot '$file' using 1:13 with lines title 'w^2';
"

