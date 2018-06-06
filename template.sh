#!/bin/bash

##########################################################
# DISCLAIMER: this script can be used and distributed    #
# freely without need for any reference.  It is intended # 
# to be used as a starting point for developing your own #
# pipelines but in no way should be used to generate a   #
# final, publishable product. Use at your own risk.      #
# Bob Fitak, June 6, 2018.                               #
##########################################################

# The first (top) line tells the command line to use BASH
# to interpret and run this script
# This script will require four inputs: the
# forward and reverse fastq files of raw sequencing
# reads, the reference genome in FASTA format, and
# the name of the final SAM file

# Here is how you would run this script:
# ./template.sh Forward_Reads.fastq Reverse_Reads.fastq reference.fa out.sam
# or
# sh template.sh Forward_Reads.fastq Reverse_Reads.fastq reference.fa out.sam

# Assign a "name" to reference each of your input files
FREADS=$1
RREADS=$2
REF=$3
OUT=$4


# Print a message to the screen:
echo "Running the read trimming of $FREADS and $RREADS using trimmomatic..."


# Run the read trimming
java -jar ~/Desktop/GDW_Apps/Trimmomatic-0.36/trimmomatic-0.36.jar \
   PE \
   $FREADS \
   $RREADS \
   ${FREADS}.trimmed.fq \
   ${FREADS}.trimmed_unpaired.fastq \
   ${RREADS}.trimmed.fq \
   ${RREADS}.trimmed_unpaired.fastq \
   ILLUMINACLIP:/Users/instructor/Desktop/GDW_Apps/Trimmomatic-0.36/adapters/NexteraPE-PE.fa:2:30:10 \
   LEADING:20 \
   TRAILING:20 \
   SLIDINGWINDOW:4:20 \
   MINLEN:60


# Print a progress message:
echo "Trimming Complete..."
echo "The trimmed, paired output files are: \
   ${FREADS}.trimmed.fq \
   ${RREADS}.trimmed.fq \
   And the trimmed, unpaired files are: \
   ${FREADS}.trimmed_unpaired.fastq \
   ${RREADS}.trimmed_unpaired.fastq \"


# Print progress message:
echo "Indexing reference genome $REF using Bowtie2..."


# Index the reference genome
bowtie2-build $REF ${REF}.index


# Print another message:
echo "Mapping only the trimmed reads ${FREADS}.trimmed.fq \
and ${RREADS}.trimmed.fq to reference genome $REF ..."


# Perform mapping using Bowtie2
bowtie2 \
   -x ${REF}.index \
   -q \
   -1 ${FREADS}.trimmed.fq \
   -2 ${RREADS}.trimmed.fq \
   --no-unal \
   --threads 4 \
   -S $OUT

# Print final message
echo "Analysis complete.  Your final results are written to $OUT"
