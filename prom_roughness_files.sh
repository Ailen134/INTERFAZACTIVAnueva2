# computes the mean and variance of the cm_*_.dat files columns
# for instance: to plot the average of the column 4 with its error bar
# plot "< bash prom_monitor.sh" u 0:4:(column(4+6)) w error


files="cm_*_.dat"

samples=$(ls $files | wc -l); 
paste $files | \
awk -v N=$samples '{\
for(i=0;i<6;i++){acum[i]=0; acum2[i]=0;}; \
for(j=1;j<=NF;j++){acum[(j-1)%6]+=$j;acum2[(j-1)%6]+=$j*$j}; \
for(i=0;i<6;i++){\
if(NR>1) printf("%f ",acum[i]/N);\
}; \
for(i=0;i<6;i++){\
if(NR>1) printf("%f ",sqrt(acum2[i]/N - acum[i]*acum[i]/(N*N)) );\
}; \
if(NR>1) printf("\n") \
}' > "roughness_"$samples"samples.dat"

file="roughness_"$samples"samples.dat"
echo $file

gnuplot -p -e "set term png; set output 'roughness.png'; set logs; plot '$file' u 4, '$file' u 4 w l"
