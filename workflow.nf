// params.str = ['/Users/shashankkatiyar/Documents/github_repos/Gene-Expression-Prediction-Using-Deep-Neural-Network/raw_data_temp/file1.txt.gz', '/Users/shashankkatiyar/Documents/github_repos/Gene-Expression-Prediction-Using-Deep-Neural-Network/raw_data_temp/file2.txt.gz', '/Users/shashankkatiyar/Documents/github_repos/Gene-Expression-Prediction-Using-Deep-Neural-Network/raw_data_temp/file3.txt.gz']
// process gatherfiles {

//     output:
//     stdout

//     """
//     find /Users/shashankkatiyar/Documents/github_repos/Gene-Expression-Prediction-Using-Deep-Neural-Network/raw_data_temp -type f -name '*.gz'
//     """
// }

process extractFastq{

    input:
    path input_file
    path "$baseDir/raw_data/input_file"

    output: 
    path ""

    script:
    """
    gunzip -c input_file 
    """
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

// // Define the process to run kallisto quant on each extracted file
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
