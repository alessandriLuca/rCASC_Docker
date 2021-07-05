#!/bin/bash
name=$1
cd /scratch
chmod -R 777 /scratch/
mkdir -p /scratch/trim
mkdir -p /scratch/reports


for i in ./*.fastq*; do
  gzip -d $i
done
for i in ./*.fastq*; do
  /tmp/temp/seqtk/seqtk trimfq -q 0.02 -l 350 $i > /scratch/trim/${i[@]/.fastq/_trim.fastq}
done

fileNumber=$(ls /scratch/*.fastq | wc -l)
if [[ "$fileNumber" -eq 2 ]]; 
then 

a=$(ls /scratch/trim/*fastq | grep _1)
b=$(ls /scratch/trim/*fastq | grep _2)

/tmp/temp/mixcr-1.8.1/mixcr align -s hsa --threads 12 -p rna-seq -OallowPartialAlignments=true -OvParameters.geneFeatureToAlign=VTranscriptWithout5UTRWithP --not-aligned-R1 ${a[@]/.fastq/_unaligned.fastq} --not-aligned-R2 ${b[@]/.fastq/_unaligned.fastq} --report /scratch/reports/_align_report.txt $a $b res.vdjca -f
/tmp/temp/mixcr-1.8.1/mixcr   assemble --threads 12 -OseparateByV=true -OseparateByJ=true -OseparateByC=false --report /scratch/reports/ass_report.txt res.vdjca res.clna
  /tmp/temp/mixcr-1.8.1/mixcr   exportClones -o -t TRB -cloneId -count -fraction -vHit -dHit -jHit -cHit    -vFamily -dFamily -jFamily -cFamily -vHitScore -dHitScore -jHitScore -cHitScore -nFeature CDR3 -nFeature VCDR3Part -nFeature DCDR3Part -nFeature JCDR3Part -nFeature VJJunction -nFeature VDJunction -nFeature DJJunction -aaFeature CDR3 -aaFeature VCDR3Part -aaFeature DCDR3Part -aaFeature CDR1 -aaFeature CDR2  res.clna ${name}_finalRes.txt

fi  

if [[ "$fileNumber" -eq 1 ]]; 
then 
a=$(ls /scratch/trim/*fastq)

/tmp/temp/mixcr-1.8.1/mixcr align -s hsa --threads 12 -p rna-seq -OallowPartialAlignments=true -OvParameters.geneFeatureToAlign=VTranscriptWithout5UTRWithP --not-aligned-R1 ${a[@]/.fastq/_unaligned.fastq} --report /scratch/reports/_align_report.txt $a res.vdjca -f
/tmp/temp/mixcr-1.8.1/mixcr   assemble --threads 12 -OseparateByV=true -OseparateByJ=true -OseparateByC=false --report /scratch/reports/ass_report.txt res.vdjca res.clna
  /tmp/temp/mixcr-1.8.1/mixcr   exportClones -o -t TRB -cloneId -count -fraction -vHit -dHit -jHit -cHit    -vFamily -dFamily -jFamily -cFamily -vHitScore -dHitScore -jHitScore -cHitScore -nFeature CDR3 -nFeature VCDR3Part -nFeature DCDR3Part -nFeature JCDR3Part -nFeature VJJunction -nFeature VDJunction -nFeature DJJunction -aaFeature CDR3 -aaFeature VCDR3Part -aaFeature DCDR3Part -aaFeature CDR1 -aaFeature CDR2  res.clna ${name}_finalRes.txt



fi
awk -F "\"*\t\"*" '{print $23 "\t" $2 "\t" $3}' ${name}_finalRes.txt > ${name}_filtered_final_Res.txt 
awk -F "\"*\t\"*" '{print ">" "'${name}'" "_" $1 "\n" $23}' ${name}_finalRes.txt > ${name}_temp_multipleFasta.fasta
sed '1,2d' ${name}_temp_multipleFasta.fasta > ${name}_multipleFasta.fasta
rm ${name}_temp_multipleFasta.fasta




awk -F "\"*\t\"*" '{print $23}' ${name}_finalRes.txt > ${name}_temp_multiplepep.txt
sed '1,1d' ${name}_temp_multiplepep.txt > ${name}_multiplepep.txt
rm ${name}_temp_multiplepep.txt
chmod -R 777 /scratch/
