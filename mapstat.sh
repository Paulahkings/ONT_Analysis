#!/bin/bash

################ Variable List ###################

list=/home/ekariuki/ONTSeq/analysis/basec_demux/merged_fqs/list.txt
BWA=/home/ekariuki/ONTSeq/analysis/BWA

###################################################

#echo 'Breadth of Coverage ... '
#for v in `cat $list`
#do
#	samtools depth -a $BWA/"${v}"_sorted.bam | awk '{c++;s+=$3}END{print s/c}'
#done
###################################################

echo 'Proportion of reads that mapped to reference ... '
for v in `cat $list`
do 
	samtools flagstat $BWA/"${v}"_sorted.bam | awk -F "[(|%]" 'NR == 3 {print $2}'
done
