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
# the base name of the output files

# Here is how you would run this script:
# ./template.sh Forward_Reads.fastq Reverse_Reads.fastq reference.fa output1
# or
# sh template.sh Forward_Reads.fastq Reverse_Reads.fastq reference.fa output1

# If you get a "permission denied" error, then first run:
# chmod 770 template.sh
# The above command changes the permissions to allow the command line to
# recognize the file template.sh as a program.


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
   ${RREADS}.trimmed_unpaired.fastq"


# Print progress message:
echo "Indexing reference genome $REF using Bowtie2..."


# Index the reference genome
bowtie2-build $REF ${REF}.index


# Print another message:
echo "Finished building the index..."
echo "Mapping only the trimmed reads ${FREADS}.trimmed.fq \
and ${RREADS}.trimmed.fq to reference genome $REF ..."


# Perform mapping using Bowtie2
bowtie2 \
   -x ${REF}.index \
   --local \
   -q \
   -1 ${FREADS}.trimmed.fq \
   -2 ${RREADS}.trimmed.fq \
   --no-unal \
   --threads 4 \
   -S ${OUT}.sam \
   --un-conc ${OUT}.unmapped.fastq


# Print progress message
echo "Finished mapping.  The output sam file \
was written to ${OUT}.sam and the unmapped reads \
are in ${OUT}.unmapped.fasta"


# Begin Assembly of unmapped reads using Spades
echo "Beginning de novo assembly of unmapped reads..."


# Run Spades
spades.py \
   -o ${OUT}_Spades_Assembly \
   --pe1-1 ${OUT}.unmapped.1.fastq \
   --pe1-2 ${OUT}.unmapped.2.fastq \
   -m 12 \
   -t 4


# Print progress message
echo "Finished Spades assembly..."


# Print message
echo "Beginning blast search of top 5 contigs..."


# Select the first 5 contigs from the assembly
# This is a scary command, but I will explain after:
/Users/instructor/Desktop/GDW_Apps/seqtk/seqtk seq \
   -l0 \
   ${OUT}_Spades_Assembly/contigs.fasta | \
   head -10 > ${OUT}.top5.fa


# MINDBLOWING!!!!!
# First, this command used seqtk to change the format
# of the contigs.fasta file to a fasta format with
# each sequence occupying two lines.  Next, the 'head'
# command selects the top 10 lines, or 5 sequences.
# Remember the pipe????


# Finally, Blast these 5 sequences!!!!! (keeping the top 3 matches for each)
blastn \
   -query ${OUT}.top5.fa \
   -db nt \
   -remote \
   -num_alignments 3 \
   -outfmt 7 \
   -out ${OUT}.blastout.tsv


# Print final message
echo "Blast has finished, results are in ${OUT}.blastout.tsv..."
echo "Analysis complete."
