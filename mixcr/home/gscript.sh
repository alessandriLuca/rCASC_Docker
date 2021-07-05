#!/bin/bash
name=$1
jobName=$2
cluster=$3
motifLength=$4
maxDelLength=$5
maxInsLength=$6
numbOfSeed=$7
penalityFactorIntCluster=$8
backGroundAminoFreq=$9
seqWeightType=${10}
/gibbscluster-2.0/gibbscluster -f /scratch/{$name} -R /scratch/res -g $cluster -H /bin/R -P $jobName -l $motifLength -D $maxDelLength -I $maxInsLength -S $numbOfSeed -b $penalityFactorIntCluster -z $backGroundAminoFreq -c $seqWeightType  
