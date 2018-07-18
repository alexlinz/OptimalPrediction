#!/bin/bash

source activate qiime2-2018.6

qiime deblur denoise-16S --i-demultiplexed-seqs $1-filtered.qza --p-trim-length $2 --o-representative-sequences repseqs-$1-deblur.qza --o-table table-$1-deblur.qza --p-sample-stats --o-stats $1-deblur-stats.qza

qiime deblur visualize-stats --i-deblur-stats $1-deblur-stats.qza --o-visualization $1-deblur-stats.qzv

qiime tools view $1-deblur-stats.qzv

source deactivate
