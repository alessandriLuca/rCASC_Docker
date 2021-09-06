head -1 /scratch/GSM4224432_ATACLib10.csv > newdata.csv
 grep -w -F -f /scratch/toFilter.csv /scratch/GSM4224432_ATACLib10.csv >> /scratch/newdata.csv
 
