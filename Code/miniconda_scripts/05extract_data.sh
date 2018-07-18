#!/bin/bash

# Use QIIME export functions to generate a tab separated file and a fasta file

source activate qiime2-2018.6

name=$(basename $2 .qza)
# For the clustered data:
# Fasta first
qiime tools export $1 --output-dir .
mv dna-sequences.fasta $name.fasta

# Export BIOM table
qiime tools export $2 --output-dir .

# Convert biom to tsv
biom convert -i feature-table.biom -o $name.tsv --to-tsv

source deactivate
