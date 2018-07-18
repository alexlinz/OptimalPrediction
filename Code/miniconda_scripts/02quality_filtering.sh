#!/bin/bash

source activate qiime2-2018.6

qiime quality-filter q-score --i-demux $1.qza  --o-filtered-sequences $1-filtered.qza  --o-filter-stats $1-filter-stats.qza

qiime metadata tabulate --m-input-file $1-filter-stats.qza --o-visualization $1-filter-stats.qzv

qiime tools view $1-filter-stats.qzv

source deactivate
