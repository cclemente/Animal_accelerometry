
#Building training datasets

This step should be relatively simple if you have organised your files well. The matlab script should have output a series of txt files with the filename of the video. 

These should be arranged in a logical way, for example by individual, or treatment. 

In the example code provided the files are separated by both individual (e.g. Maple) and by treatment (e.g. Bib off). 

You can use the attached code as a guide. 

(1) Change the path on line 3. Then run the sys.glob() function line 5, to get a list of files in that folder. 

