#!/bin/bash
activate qiime2-2018.6

# Open data
tar xvzf trimmed_100.tar.gz

# Import data as a QIIME artifact
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path manifest.txt \
  --source-format SingleEndFastqManifestPhred33 \
  --output-path $1.qza

rm -r trimmed_100/

qiime --help
qiime info

#qiime quality-filter q-score \
# --i-demux $1.qza \
# --o-filtered-sequences $1-qc.qza \
# --o-filter-stats $1-qc-stats.qza

#qiime deblur denoise-16S \
#  --i-demultiplexed-seqs $1-qc.qza \
#  --p-trim-length 100 \
#  --o-representative-sequences rep-seqs-$1-deblur.qza \
#  --o-table table-$1-deblur.qza \
#  --p-sample-stats \
#  --o-stats $1-deblur-stats.qza

#qiime deblur visualize-stats \
#  --i-deblur-stats $1-deblur-stats.qza \
#  --o-visualization $1-deblur-stats.qzv
	
#cp table-$1-deblur.qza /mnt/gluster/amlinz/NTL-MO/error_corrected_tables/
#cp $1-deblur-stats.qzv /mnt/gluster/amlinz/NTL-MO/error_correct_stats/


