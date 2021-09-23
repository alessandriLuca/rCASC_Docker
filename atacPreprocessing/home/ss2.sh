head -1 /scratch/$1 > newdata.csv
 grep -w -F -f /scratch/toFilter.csv /scratch/$1 >> /scratch/newdata.csv
 
