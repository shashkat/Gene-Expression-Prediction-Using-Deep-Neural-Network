input_dir = "$baseDir"

genome_index = "$baseDir/genome_index"

process runStar {
    input:
    path fastq from input_dir + '/*.fastq.gz'

    output:
    path 'aligned/'

    script:
    """
    STAR --runThreadN 8 \\
        --genomeDir ${genome_index} \\
        --readFilesIn ${fastq} \\
        --readFilesCommand gunzip -c \\
        --outFileNamePrefix aligned/
    """
}

process runRSEM {
    input:
    path aligned_sam from 'aligned/*.sam'

    output:
    path 'rsem_output/'

    script:
    """
    rsem-calculate-expression --alignments ${aligned_sam} human_gencode rsem_output
    """
}

workflow RNAQuantificationWorkflow {
    runStar.out.into { aligned_sam } | runRSEM(aligned_sam)
}
