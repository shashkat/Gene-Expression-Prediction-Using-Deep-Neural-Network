In this project, I will train a deep neural network capable of predicting gene expression using information from the ATACseq analysis on similar sample (tissue type or cell type).

(12-22-23)

First I need to collect lots of data (download many RNAseq and ATACseq files for different tissues and celltypes from ENCODE).

I have downloaded data (RNAseq tsv file and ATACseq bed file) from 10 cell lines and  19 tissue types. I can also download data of primary cells but that I will do later. For now, I will try to make the model work.

First, I will write code to get all the data in a nice file/s, which will be the training and testing data. First, I need to think how I will organise the many possible peak regions in all the different samples. I am thinking of splitting the region of interest (first million bases of chr1) into bins of 1000 size and for each bin, I will calculate: size of the peak*its score and add this for all the peaks associated with a bin (through midpoint lying within bin). This way, I will get overall openness of each bin. For the genes (output), first I need to find all the genes present in our area of interest from the gene-info file obtained from ensembl in the integration project. Then, we will just limit our analysis to these genes. I would need to make sure that all these genes are present in each tsv file (but I am pretty sure they will be).

So I realized that the score column in the bed file is the actual marker for goodness of a peak. So I am gonna change the bin-scoring-method stated above slightly. I will first filter only the peaks with a score of 1000, as they are the strongest ones. Then, for each bin, for each sample, there will be either some (1000 scored) peak in it or not (doesn't matter if there are more than one peaks in the bin). We will treat each bin to have binary value in the input, i.e. it has a peak or not. 

(12-23-23)

I realized later yesterday that for a region of interest of the first million bases of chromosome 1, with each bin of size 1000, there would be 1000 nodes in the input layer in the neural network and 360 nodes in the output layer (as that is the number of genes in that area of interest). And the number of data points we have are in two digits, so very less. A good thing is that each input will be 0 or 1, so some possibilities are reduced that way.

Also, I can show the prediction results in the form of a plot, showing the actual expression values of each gene and our predictions for them.

Wrote the code for making the input and output files for the model and stored them in the prepared_data folder. 

Then moved on to finally writing code for the model using PyTorch. But first installed pytorch. Also tried to understand from ChatGPT about a PyTorch model implementation and meaning of every line in that.

(12-24-23)

Continuing on understanding the Pytorch model implementation. 

I have decided that I will submit the Genentech application today, and keep on understanding the model implementation till later days.. Update after 8 hours- not today but probably tomorrow

Current issue- somehow in the input tensor, the entries are double, but the output = model(input_tensor) command expects the inputs to be float. Need to figure that out.

Figured that out, and the model is working now. Now need to see how good is the training. Can do this by plotting the values of gene expressions and what the predicted expressions are after the data goes through the model.

(12-25-23)

Okay, so I have been able to successfully create the output for the model (its predictions vs expected values of gene expressions). The first output is, as expected not very good. It looks like:

![first model performance plot](image.png)

Now, I need to think of what would be the best ways to improve the predictions of the model and also how to quantify the quality of its output. Something like correlation comes to my mind, but i will inquire more about it.

So doing like 10000 epochs improved my training accuracy (it had to do that). Currently, the model is probably overfitted. I need to check how well it generalizes to other data that I have.
