awk -F "\"*,\"*" '{print $1}' /scratch/$1 > /scratch/yo.csv
sed 's/"//' /scratch/yo.csv > /scratch/yo2.csv
