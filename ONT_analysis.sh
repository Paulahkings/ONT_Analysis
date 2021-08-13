#!/bin/bash

################## Variables List #######################

GuppyBinary="https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy_5.0.11_linux64.tar.gz"
FAST5s=/home/ekariuki/eanbitRT21/recov_data.zip
ONTdata=/home/ekariuki/eanbitRT21/ONTdata
FASTQs=/home/ekariuki/eanbitRT21/fastqs/pass
SEQ_SUMMARY=/home/ekariuki/eanbitRT21/fastqs/sequencing_summary.txt
porechop=/home/ekariuki/eanbitRT21/Porechop/results
RES=/home/ekariuki/eanbitRT21/results
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
#echo 'Running pycoQC ...'

#pycoQC -f $SEQ_SUMMARY -o $RES/pycoqc.html
########################################################
echo 'Convert basecalled fastqs.gz into one .qz file ...'

gunzip -c $FASTQs/*.gz | gzip > $RES/reads.fastq.gz
########################################################
echo 'Running nanofilt ...'

gunzip -c $RES/reads.fastq.gz | NanoFilt -q 8 | gzip > $RES/filtered-reads.fastq.gz
########################################################
echo 'Adapter trimming with porechop... '

porechop -i $RES/filtered-reads.fastq.gz -o $RES/adfree_reads.fastq.gz
#######################################################
echo 'Running Nanoplot post QC/filtering ...'

NanoPlot -t 20 --fastq $RES/adfree_reads.fastq.gz --N50 -o $RES \
--maxlength 40000 --plots dot --legacy hex

######################################################
#echo 'mapping ...'
#       echo ' Generating .bam files ... '

#       samtools view -b $mapped.sam > $mapped.bam

#       echo 'Sorting the .bam file...'

#       samtools sort $mapped.bam -o $mapped_sorted.bam

#       echo 'Indexing the sorted bam file...'

#       samtools index $mapped_sorted.bam

#       echo 'Obtaining a count of the total no. of alignments... '

#       samtools view $mapped_sorted.bam | wc -l

#       echo 'Getting only the mapped reads in .bam format... '

#       samtools view -b -F 4 $mapped_sorted.bam > $ref_mapped.bam

#       echo 'Indexing the mapped reads... '

#       samtools index $ref_mapped.bam

#       echo 'Sorting the bam files... '

#       samtools sort $ref_mapped.bam -o $ref_map_sorted.bam

        ########## CONVERTING THE READS TO FASTQ ############
#       echo 'Using samtools to convert bams to fastq format... '

#       samtools bam2fq $ref_map_sorted.bam > $ref_Mapped.fastq
