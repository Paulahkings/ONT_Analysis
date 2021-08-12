#!/bin/bash

################## Variables List #######################

GuppyBinary="https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy_5.0.11_linux64.tar.gz"
FAST5s=/home/ekariuki/eanbitRT21/recov_data.zip
ONTdata=/home/ekariuki/eanbitRT21/ONTdata
FASTQs=/home/ekariuki/eanbitRT21/fastqs
SEQ_SUMMARY=/home/ekariuki/eanbitRT21/fastqs/sequencing_summary.txt

#########################################################
#echo 'Downloading Guppy'

#wget $GuppyBinary
#########################################################
#echo 'Unpack the guppy binary files'

#tar -xvzf ont-guppy_5.0.11_linux64.tar.gz
#########################################################
#echo 'unzipping fast5 files ...'

#unzip -q $FAST5s -d $ONTdata
#########################################################
# To perform the basecalling step you need to know the flowcell and ONT kit used to generate your 
# fast5 files and select the appropriate config file
#########################################################
#echo 'performing basecalling ...'
#guppy_basecaller --compress_fastq -i $ONTdata/ \
#-s $FASTQs --cpu_threads_per_caller 16 --num_callers 1 \
#-c dna_r9.4.1_450bps_hac.cfg
########################################################
echo 'Running pycoQC ...'

pycoQC -f $SEQ_SUMMARY -o $FASTQs/pycoqc.html
########################################################
echo 'Running nanofilt ...'

gunzip -c $FASTQs/pass | NanoFilt -q 10 | gzip > $FASTQs/filtered-reads.fastq.gz
########################################################
echo 'Adapter trimming with porechop... '

porechop -i $FASTQs/filtered-reads.fastq.gz -o $porechop/output_reads.fastq.gz
#######################################################
