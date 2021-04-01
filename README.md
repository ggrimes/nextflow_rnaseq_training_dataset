# nextflow_rnaseq_training_dataset

Step to generate of a small RNA-Seq training dataset.


# Dataset

Dataset download from ArrayExpress [E-MTAB-4044](https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-4044/) - 

## Descriptipn

Title: Response to different types of stress converge in mitochondrial metabolism 
The budding yeast Saccharomyces cerevisiae was used to study 9 different stress conditions in chemostat conditions at constant specific growth rate.

|Name|Descripton|
|-|-|
|Organism|Saccharomyces cerevisiae|
Experiment types|RNA-seq of coding RNA, case control design, dose response design, growth condition design, stimulus or stress design|
|citation|Lahtvee P-J, Sánchez BJ, Smialowska A, et al. Absolute quantification of protein and mrna abundances demonstrate variability in gene-specific translation efficiency in yeast. Cell Syst. 2017;4(5):495-504.e5.|
|DOI|[10.1016/j.cels.2017.03.003](https://doi.org/10.1016/j.cels.2017.03.003)]

## Sample Information

https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-4044/samples/


## Sampling Strategy

To produce small enough dataset to work on, bam files were sub sampled to 1% of their reads
~~~
#example sampling strategy
samtools view -s 0.01 https://www.ebi.ac.uk/arrayexpress/files/E-MTAB-4044/E-MTAB-4044.P569_101.bam -b -o E-MTAB-4044.P569_101_1.bam

#bedtools bamToFastq to convert reads
bamToFastq -i  E-MTAB-4044.P569_101_1.bam -fq e1_R1.fq -fq2 e1_R2.fq

~~~

## Yeast transcriptome

The yeast transcriptome Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz was downloaded from ensembl (release 100)

~~~
wget http://ftp.ensembl.org/pub/release-100/fasta/saccharomyces_cerevisiae/cdna/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz
~~~
