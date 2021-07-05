#!/bin/bash
clusterFolder=$1
cd $clusterFolder
for i in $clusterFolder/*.core; do
/seq2logo-2.1/Seq2Logo.py -f $i -o ${clusterFolder}/_logos_${i##*/}
done

