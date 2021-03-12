
# chunking data and creating the predictor data set. 

There should be two files above. The first should be short and simply allows us to divide the often very large accelerometer files into smaller more manageable chunks. 

# Chunk data

(1) Open the chunk_files.R script 

(2) set the working directory to where the large accelerometer file is. As this code is going to produce a lot of smaller files its sometimes a good idea to create a new folder and move the accel trace into this folder. 

(3) Read in the filenames (line 8), there should be only one file. Check to see its the right one. 

(4) Run through the code line by line, then the for loop at the end. This should create a series of files, each with a different name in the folder you specified above. 

(5) Important. Now is a good time to move / delete the large accel file as it will mess up the next step below if left in this folder. 

##Edited 12/03/2021

modified so the chunked files are now numbered with an interger padded with zeros e.g. 001, 002
this way the files are in the correct order when read back into R in the next step. 


# Create predictors. 

(1) Open the file 'Process_Accel_Output_FULLACC_V2_forloop.R'

(2) Yell at Josh for giving the file such a long stupid name. 

(3) Set up parallel processing. The first section should load the libraries and register the cores required for parallel processing. Install any required packages if you have not done so. 

(4) Set the working directory to the folder where the chunked files are. Make sure the large accel file is no longer in the folder with the chunked files. 

(5) Run the function at the bottom of the script called 'doAccloop' - this will be the function called up during parallel processing. 

(6) Jump back up to the top of the for loop. this for loop will print out the file name, clean the data and then run each chunked file through the function below. It will then save the output with the same filename but adds 'processed' to the end. 
On my computer each chunked file took ~6 minutes to run. (i5 processor, 4 cores, chunk length = 100,000)
This means that for the ~327 chunk files to run will take ~32 hours. Be prepared not to use the computer in that time for anything that is processor heavy. 






