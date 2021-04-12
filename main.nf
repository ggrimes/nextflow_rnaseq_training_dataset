/*
input params
*/

params.samplesheet='data/samplesheet.csv'
params.samplefrac=0.005
params.transcriptome="http://ftp.ensembl.org/pub/release-100/fasta/saccharomyces_cerevisiae/cdna/Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa.gz"



log.info """\
         Generate dataset - N F   P I P E L I N E
         ===================================
         samplesheet:         : ${params.samplesheet}
         samplefrac:          : ${params.samplefrac}
         """
         .stripIndent()

bam_ch =   Channel.fromPath(params.samplesheet)
             .splitCsv(header:true)
             .map{row -> tuple(row.name, row.bam_url) }

//bam_ch.view()

process get_transcriptome {

  publishDir "data/yeast/transcriptome",  mode:"copy"

  input:
  val transcriptome_url from params.transcriptome

  output:
  path  "*.fa.gz" into transcriptome_out

  script:
  """
  wget ${transcriptome_url}
  """
}



process sample_bams_generate_fastq {


  errorStrategy 'ignore'

  cpus 4

  input:
  tuple val(sample_id), val(url) from bam_ch

  output:
  tuple val("${sample_id}"), path("*.bam") into bam_sample_ch

  script:
  """
  #downsample bam
  samtools view -s ${params.samplefrac} ${url} -b -o ${sample_id}.bam -@ ${task.cpus} || true
  """
}

process bam2fq {

  publishDir "data/yeast/reads", mode:"copy"

  input:
  tuple val(sample_id), path(bam) from bam_sample_ch

  output:
  path "*.fq.gz" into fq_out


  script:
  """
  #bedtools bamToFastq to convert reads
  bamToFastq -i  ${bam} -fq ${sample_id}_1.fq -fq2 ${sample_id}_2.fq
  gzip *.fq
  """

}
