params.str = ['/Users/shashankkatiyar/Documents/github_repos/Gene-Expression-Prediction-Using-Deep-Neural-Network/raw_data_temp/file1.txt.gz', '/Users/shashankkatiyar/Documents/github_repos/Gene-Expression-Prediction-Using-Deep-Neural-Network/raw_data_temp/file2.txt.gz', '/Users/shashankkatiyar/Documents/github_repos/Gene-Expression-Prediction-Using-Deep-Neural-Network/raw_data_temp/file3.txt.gz']
// process gatherfiles {

//     output:
//     stdout

//     """
//     find /Users/shashankkatiyar/Documents/github_repos/Gene-Expression-Prediction-Using-Deep-Neural-Network/raw_data_temp -type f -name '*.gz'
//     """
// }

process unzip {

    input:
    val input_file from params.str

    """
    gunzip -k '${input_file}'
    """
}

workflow {
    unzip | echo
}
