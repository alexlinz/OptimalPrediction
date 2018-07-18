#!/bin/bash
# Set up programs and copy data from gluster
tar xvzf ea-utils.tar.gz
tar xvzf qiime1.tar.gz
cp /mnt/gluster/amlinz/NTL-MO/UW/$1* .
gzip -d *.gz

export PATH=$(pwd)/python/bin:$(pwd)/home/bin/:$PATH
export HOME=$(pwd)/home

# convert fastq to fasta and qual for trimming
python ./python/bin/convert_fastaqual_fastq.py -f "$1"R1_001.fastq -o . -c fastq_to_fastaqual
python ./python/bin/convert_fastaqual_fastq.py -f "$1"R2_001.fastq -o . -c fastq_to_fastaqual

# Trim sequences to 200bp (currently 300)
# This is the recommended length for the reverse reads, forward reads could be trimmed a little less (220)
# But the target region is 150 bp, so 200bp per read leaves plenty of overlap
python ./python/bin/truncate_fasta_qual_files.py -f "$1"R1_001.fna -q "$1"R1_001.qual -b 200
python ./python/bin/truncate_fasta_qual_files.py -f "$1"R2_001.fna -q "$1"R2_001.qual -b 200

# Convert truncated fasta and qual files back to fastq
python ./python/bin/convert_fastaqual_fastq.py -f "$1"R1_001_filtered.fasta -q "$1"R1_001_filtered.qual -o .
python ./python/bin/convert_fastaqual_fastq.py -f "$1"R2_001_filtered.fasta -q "$1"R2_001_filtered.qual -o .

# Join the pairs of truncated reads
python ./python/bin/join_paired_ends.py -f "$1"R1_001_filtered.fastq -r "$1"R2_001_filtered.fastq -o results/

# Quality filter joined reads using the same parameters as the historic EMP dataset
echo $1 > ID.txt
ID=$(awk -F "_" '{print $1}' ID.txt)
python ./python/bin/split_libraries_fastq.py -i results/fastqjoin.join.fastq -o qc_results/ --min_per_read_length_fraction 0.75 --max_bad_run_length 3 --phred_quality_threshold 3 --sequence_max_n 0 --barcode_type 'not-barcoded' --sample_ids $ID --phred_offset 33 --store_qual_scores

# The previous command outputs an .fna file and a .qual file.
# Convert them to fastq
# First remove brackets from the qual file output from split_libraries_fastq.py
# Because for some COMPLETELY MYSTERIOUS REASON, that format is not compatible with convert_fastaqual_fastq.py
sed 's/[][]//g' qc_results/seqs.qual > temp.qual
python ./python/bin/convert_fastaqual_fastq.py -f qc_results/seqs.fna -q temp.qual -o .


# gzip output, change name of output file to NOT seqs.fna and move back to gluster
gzip seqs.fastq
cp seqs.fastq.gz /mnt/gluster/amlinz/NTL-MO/UW-processed/"$1"joined.fastq.gz

# Clean up
rm *fna
rm *fasta
rm *fastq
rm *fastq.gz
rm *tar
rm *qual
rm *txt
rm -r qc_results
rm -r home
rm -rf python
rm -r results
