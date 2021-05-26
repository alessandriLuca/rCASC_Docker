#!/bin/bash
wget $1 -O /data/genome.gtf.gz
wget $2 -O /data/genome.fa.gz

gzip -d /data/genome.gtf.gz
gzip -d /data/genome.fa.gz

/bin/cellranger mkgtf /data/genome.gtf /data/output.gtf --attribute=gene_biotype:$3
#/bin/cellranger mkgtf /data/genome.gtf /data/output.gtf --attribute=gene_biotype:$3
#/bin/cellranger mkgtf /data/genome.gtf /data/output.gtf --attribute=gene_biotype:bio_type
cd /data
/bin/cellranger mkref --genome=10XGenome --fasta=/data/genome.fa --genes=/data/output.gtf --nthreads=4

rm /data/output.gtf