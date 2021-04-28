transcriptome_ch = channel.fromPath("data/yeast/transcriptome/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz")

read_ch = channel.fromFilePairs("data/yeast/reads/*_{1,2}.fq.gz",checkIfExists:true)

process index {

    publishDir "data/yeast", mode:"copy"

    input:
    path transcriptome from transcriptome_ch

    output:
    path 'index' into index_ch

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}



process quantification {
    publishDir "data/yeast/bams", mode:'copy'
    tag "$pair_id"

    input:
    each index from index_ch
    tuple val(pair_id), path(reads) from read_ch

    output:
    path "${pair_id}.bam" into bam_ch

    script:
    """
    salmon quant --threads $task.cpus -l A -i $index \
    -1 ${reads[0]} -2 ${reads[1]} -o $pair_id \
    --writeMappings |samtools sort |samtools view -bS -o ${pair_id}.bam
    """
}
