#!/bin/bash

source activate qiime2-2018.6

# Dereplicate sequences
#qiime vsearch dereplicate-sequences --i-sequences $1-filtered.qza --o-dereplicated-table $1-derep-table.qza --o-dereplicated-sequences $1-derep-seqs.qza

# Cluster
qiime vsearch cluster-features-de-novo --i-table $1-derep-table.qza --i-sequences $1-derep-seqs.qza --p-perc-identity 0.99 --o-clustered-table $1.99.qza --o-clustered-sequences $1-repseqs.99.qza
 
# Remove chimeras
qiime vsearch uchime-denovo --i-table $1.99.qza --i-sequences $1-repseqs.99.qza --output-dir uchime-dn-out
qiime feature-table filter-features --i-table $1.99.qza --m-metadata-file uchime-dn-out/nonchimeras.qza --o-filtered-table $1.99.nochimeras.qza
qiime feature-table filter-seqs --i-data $1-repseqs.99.qza --m-metadata-file uchime-dn-out/nonchimeras.qza --o-filtered-data $1-repseqs.99.nochimeras.qza

# Visualize results
qiime feature-table summarize --i-table $1.99.nochimeras.qza --o-visualization $1.cluster.qzv
qiime tools view $1.cluster.qzv

source deactivate
