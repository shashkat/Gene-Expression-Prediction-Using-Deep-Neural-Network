import pandas as pd
import os
import glob

# make an array of strings, which are the names of the tissues (all folders within data/tissues)
# call the array samples, as it can be tissue or cell line samples
directory = 'data/cell_lines/'
# samples = MakeSamplesArray(directory)
samples = []
for sample in os.listdir(directory):
    if not sample.startswith('.'):
        samples.append(sample)

# make an array (of dataframes) called exp and another called peaks and store in them, respectively, 
# the tsv files and bed files in each folder within data/tissues
exp = []
peaks = []
# the column headers of peaks
peaks_headers = ['chr', 'start', 'end', 'name', 'score', 'strand', 'signalValue', 'pValue', 'qValue', 'peak']

for sample in samples:

    # get all the tsv files in the directory (there will be just the one)
    tsv_files = glob.glob(directory + sample + '/*.tsv')
    for file in tsv_files:
        tsv_name = file
    
    # get all the bed files in the directory (there will be just the one)
    bed_files = glob.glob(directory + sample + '/*.bed')
    for file in bed_files:
        bed_name = file
    
    # read the tsv file into a dataframe and append it to exp
    exp_df = pd.read_csv(tsv_name, sep='\t')
    exp.append(exp_df)

    # read the bed file into a dataframe and append it to peaks
    peaks_df = pd.read_csv(bed_name, sep='\t', names=peaks_headers)
    peaks.append(peaks_df)

# some parameters for the program
# area of interest
chr_num = 1
aoi_start = 0
aoi_end = 10000000
bin_size = 1000

# dependent variables
aoi_chr = 'chr' + str(chr_num)

# filtering on peaks
# for each tissue, filter the peaks dataframe to only include peaks within the area of interest
# and then filter the peaks dataframe to only include peaks with a score of at least 800

# make an array called filtered_peaks
filtered_peaks = []
for i in range(len(peaks)):
    # filter the peaks dataframe to only include peaks within the area of interest
    filtered_peaks_df = peaks[i][(peaks[i]['chr'] == aoi_chr) & (peaks[i]['start'] >= aoi_start) & (peaks[i]['end'] <= aoi_end)]
    # filter the peaks dataframe to only include peaks with a score of at least 800
    filtered_peaks_df = filtered_peaks_df[filtered_peaks_df['score'] >= 800]
    # append the filtered peaks dataframe to filtered_peaks
    filtered_peaks.append(filtered_peaks_df)

# using the area of interest to find the genes of interest
# read the ensembl_genes.txt file into a dataframe
genes_df = pd.read_csv('ensembl_genes.txt', sep='\t')

# filter the genes dataframe to only include genes within the area of interest
genes_df = genes_df[(genes_df['Chromosome/scaffold name'] == str(chr_num)) & (genes_df['Gene start (bp)'] >= aoi_start) & (genes_df['Gene end (bp)'] <= aoi_end)]

# using the filtered genes_df, make a list of all the valid Gene stable ID versions
gene_stable_ids = []
for index, row in genes_df.iterrows():
    gene_stable_ids.append(row['Gene stable ID version'])

# for all the exp dataframes, filter them to only include rows with a gene_id in gene_stable_ids
for i in range(len(exp)):
    exp[i] = exp[i][exp[i]['gene_id'].isin(gene_stable_ids)]

# make a 2d array, of size len(exp) x len(gene_stable_ids), called exp_output, intialized to all 0s
exp_output = []
for i in range(len(exp)):
    exp_output.append([])
    for j in range(len(gene_stable_ids)):
        exp_output[i].append(0)

# for each exp[i], for its genes, find the corresponding gene in gene_stable_ids and store the TPM value 
# for that gene in exp_output[i][j], where j is the index of the gene in gene_stable_ids
for i in range(len(exp)):
    for index, row in exp[i].iterrows():
        gene_id = row['gene_id']
        gene_index = gene_stable_ids.index(gene_id)
        exp_output[i][gene_index] = row['TPM']

# save the exp_output array as a csv file in prepared_data folder
exp_output_df = pd.DataFrame(exp_output)
exp_output_df.to_csv('prepared_data/exp_output.csv', index=False, header=False)

# now for every df in the peaks array, make a column called 'mid' which is the midpoint of the peak
for i in range(len(filtered_peaks)):
    filtered_peaks[i]['mid'] = (filtered_peaks[i]['start'] + filtered_peaks[i]['end']) / 2

# make a 2d array, of size len(filtered_peaks) x number of bins, called peaks_output, intialized to all 0s
peaks_input = []
num_bins = int((aoi_end - aoi_start) / bin_size)
for i in range(len(filtered_peaks)):
    peaks_input.append([])
    for j in range(num_bins):
        peaks_input[i].append(0)

# for each filtered_peaks[i], for its peaks, find the corresponding bin in peaks_output[i] and make it 1
for i in range(len(filtered_peaks)):
    for index, row in filtered_peaks[i].iterrows():
        mid = row['mid']
        bin_index = int((mid - aoi_start) / bin_size)
        peaks_input[i][bin_index] = 1

# save the peaks_output array as a csv file in prepared_data folder
peaks_input_df = pd.DataFrame(peaks_input)
peaks_input_df.to_csv('prepared_data/peaks_input.csv', index=False, header=False)