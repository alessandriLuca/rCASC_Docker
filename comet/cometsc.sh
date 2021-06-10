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
cd /scratch/$MATNAME/$NCLUSTERS
j="$MATNAME.*"
cp /scratch/$j /scratch/$MATNAME/
cp /scratch/$MATNAME/$j . 

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


Comet /scratch/$MATNAME/$NCLUSTERS/markers.txt /scratch/$MATNAME/$NCLUSTERS/vis.txt /scratch/$MATNAME/$NCLUSTERS/cluster.txt /scratch/$MATNAME/$NCLUSTERS/output -C $THREADS -X $X -K $K -skipvis $SKIPVIS

chmod -R 777 /scratch 
