#!/bin/bash

#mkdir /mnt/gluster/amlinz/NTL-MO/UW-processed/
for file in /mnt/gluster/amlinz/NTL-MO/UW/*R1_001.fastq.gz; do
	sample=$(basename $file R1_001.fastq.gz);
	echo $sample;
	done > uwbc_samples.txt
