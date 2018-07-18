#!/bin/bash

# If you haven't already, untar the archive of fastq files and start qiime
tar xvzf $1.tar.gz
source activate qiime2-2018.6

# Need to replace all underscores with dashes, in both file names and manifests
cd $1
for file in *; do
  mv "$file" "${file//_/-}";
done
cd ..

# Make the manifest file with no underscores
for file in $1/*; do
  name=$(basename $file .fastq.gz);
  echo $name;
  done > trimmed_sample_names.txt

while read line; do
  abspath="/$1/$line.fastq.gz,forward";
  echo '$PWD'$abspath;
  done < trimmed_sample_names.txt > sample_paths.txt

paste -d"," trimmed_sample_names.txt sample_paths.txt > partial.manifest.txt
echo "sample-id,absolute-filepath,direction" > header.txt
cat header.txt partial.manifest.txt > fixed.$1.manifest.txt

# Read in data using manifest file

qiime tools import --type 'SampleData[SequencesWithQuality]' \
--input-path fixed.$1.manifest.txt \
--output-path $1.qza \
--source-format SingleEndFastqManifestPhred33

# Calculate qc stats on data
#qiime demux summarize --i-data $1.qza \
#--o-visualization $1.qzv

# Visualize

#qiime tools view $1.qzv

# Repeat with just subsets of EMP and UW data
#qiime tools import --type 'SampleData[SequencesWithQuality]' \
#--input-path $1.emp.manifest.txt \
#--output-path $1.emp.qza \
#--source-format SingleEndFastqManifestPhred33

#qiime demux summarize --i-data $1.emp.qza \
#--o-visualization $1.emp.qzv    

#qiime tools view $1.emp.qzv

#qiime tools import --type 'SampleData[SequencesWithQuality]' \
#--input-path $1.uw.manifest.txt \
#--output-path $1.uw.qza \
#--source-format SingleEndFastqManifestPhred33

#qiime demux summarize --i-data $1.uw.qza \
#--o-visualization $1.uw.qzv    

#qiime tools view $1.uw.qzv

# Remove subset qiime artifacts - won't be using these datasets downstream
# Save the visualization files, though

#rm $1.emp.qza
#rm $1.uw.qza
rm -r $1
source deactivate
