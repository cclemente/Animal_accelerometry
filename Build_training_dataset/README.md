
#Building training datasets

This step should be relatively simple if you have organised your files well. The matlab script should have output a series of txt files with the filename of the video. 

These should be arranged in a logical way, for example by individual, or treatment. 

In the example code provided the files are separated by both individual (e.g. Maple) and by treatment (e.g. Bib off). 

You can use the attached code (Build_training_data.R) as a guide. 

(1) Change the path on line 4. Then run the sys.glob() function line 5, to get a list of files in that folder. 

(2) run the for loop to process each file, should produce a new set of files renames <filename>_processed.csv
  
(3) Move the processed files into a subfolder - can combine all files from all possums 

(4) Run the code to combine all the files together (Combined_processed_files.R). 

make sure to change the output filename at the end of the file to be something meaningful for your species / subjects. 

(5) You will also have to create a activity key. (example shown above = Quoll_Behaviour_ActNo.csv) : this is just the key that translates the number for the activity to the behaviour. 





