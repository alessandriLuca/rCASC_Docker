library(rCASC)
path=getwd()

cellrangerIndexing(group="docker", scratch.folder=path, 
            gtf.url="http://ftp.ensembl.org/pub/release-87/gtf/homo_sapiens/Homo_sapiens.GRCh38.87.gtf.gz",
            fasta.url="http://ftp.ensembl.org/pub/release-87/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.toplevel.fa.gz",
            genomeFolder = getwd(), bio.type="protein_coding", nThreads = 8)