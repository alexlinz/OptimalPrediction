#!/bin/bash

# Set up QIIME1
tar xvzf qiime1.tar.gz
export PATH=$(pwd)/python/bin:$(pwd)/home/bin/:$PATH
export HOME=$(pwd)/home

# Copy files from gluster for UW tags
cp /mnt/gluster/amlinz/NTL-MO/UW-processed/* .
gzip -d *fastq.gz

# Convert to fasta and qual
# Make list of samples to convert
for file in *.fastq; do
	sample=$(basename $file .fastq);
	echo $sample;
done > samples.txt

while read line; do
	python ./python/bin/convert_fastaqual_fastq.py -f $line.fastq -o . -c fastq_to_fastaqual;
done < samples.txt

