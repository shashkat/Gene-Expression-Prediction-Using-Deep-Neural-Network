#!/usr/bin/env nextflow
// params.in = "$baseDir/raw_data_1"
params.in = "$baseDir"
// params.in = ""

process testingEnv{

    output:
    stdout

    """
    which python
    """
}

process listDir{

    input:
    path input

    output:
    stdout

    """
    ls $input
    """
}

process extractFastq{

    input:
    path dir

    output:
    path '*.fastq'

    script:
    """
    gunzip -k $dir/*.gz
    """
}

process head{
    input:
    path input

    output:
    stdout

    """
    head -n 5 $input
    """
}

process runKallisto{
    input:
    path fastq
    path index
    path dir

    """
    kallisto quant -i $index -o $dir $fastq
    """
}

workflow{
    // listDir(params.in) | head -n 5
    extractFastq(params.in) | runKallisto
    // testingEnv | view
}

// // Define the process to extract .gz files
// process extractFastq {

//     // Input: list of input fastq.gz files
//     input:
//     set file(fastq) from input_fastq

//     // Output: extracted fastq file
//     output:
//     file("${output_dir}/extracted/${fastq.baseName}")

//     script:
//     """
//     gunzip -c ${fastq} > ${output_dir}/extracted/${fastq.baseName}
//     """
// }

// Define the process to run kallisto quant on each extracted file
// process runKallisto {

//     // Input: list of extracted fastq files
//     input:
//     set file(fastq) from extracted_fastq
//     file index
//     file reference_genome

//     // Output: kallisto quant result directory
//     output:
//     directory("${output_dir}/result/${fastq.baseName}_quant")

//     script:
//     """
//     kallisto quant -i ${index} -o ${output_dir}/result/${fastq.baseName}_quant ${fastq} 
//     """
// }

// // Define the workflow
// workflow kallistoWorkflow {

//     // Input: list of fastq.gz files, index file, and reference genome
//     input:
//     set file(input_fastq), file index, file reference_genome
//     path output_dir

//     // Output: final result directory
//     output:
//     path "${output_dir}/result"

//     // Create the 'extracted' directory
//     script:
//     """
//     mkdir -p ${output_dir}/extracted
//     mkdir -p ${output_dir}/result
//     """

//     // Run the extraction process
//     extractFastq(input_fastq).into(extracted_fastq)

//     // Run kallisto quant process on each extracted file
//     runKallisto(extracted_fastq, index, reference_genome).into(kallisto_result)

// }



// process unzip {

//     input:
//     val input_file from params.str

//     """
//     gunzip -k '${input_file}'
//     """
// }

// workflow {
//     unzip | echo
// }
