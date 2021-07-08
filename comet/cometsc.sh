#! /bin/bash
MATNAME=$1
echo -$MATNAME-
THREADS=$2
echo -$THREADS-
X=$3
echo -$X-
K=$4
echo -$K-
COUNTS=$5
echo -$COUNTS-
SKIPVIS=$6
echo -$SKIPVIS-
NCLUSTERS=$7
echo -$NCLUSTERS-
SEPARATOR=$8
echo -$SEPARATOR-
cd /scratch/
j="$MATNAME.*"

echo $j
REFORMAT="_clustering.output"
MATCLUSTERS="$MATNAME$REFORMAT"

if [ $SEPARATOR == ',' ]
then
  cat $MATNAME.csv | tr  ',' '\t' > markers.txt

  echo "$MATNAME.csv converted in markers.txt"

  cat $MATCLUSTERS.csv | tr  ',' '\t' > vis.txt
  
  echo "$MATCLUSTERS.csv converted in vis.txt"

else
  cat $MATNAME.txt > markers.txt

  echo "$MATNAME.txt converted in markers.txt"

  cat $MATCLUSTERS.txt > vis.txt

  echo "$MATCLUSTERS.txt converted in markers.txt"
fi

if [ $COUNTS == "True" ]
then
  Rscript /bin/log.R $MATNAME $NCLUSTERS
fi

Rscript /bin/vis.R $MATNAME $NCLUSTERS

if [ $THREADS > $NCLUSTERS ]
then
       THREADS=$NCLUSTERS
fi


Comet /scratch/markers.txt /scratch/vis.txt /scratch/cluster.txt /scratch/output -C $THREADS -X $X -K $K -skipvis $SKIPVIS

chmod -R 777 /scratch 
