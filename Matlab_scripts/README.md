
# Matlab scripts 


## Update 13/03/2024

I have uploaded a new script (sync station) which should hopefully work better than the last one. 

New instructions coming soon! 

## old instructions below 


This folder contains the matlab code to allign accelerometer data with videos plus an example file. 

Data was collected by Jasmine Annett, University of the Sunshine Coast. 


Open up the matlab script and run the GUI. If prompted click 'add to path' 
Follow the steps outlined in the GUI

(1) Open the accel file e.g. 47056_0000000000.csv

(2) Open the file video taken in the accelerometer. e.g. GOPR6962.mp4

(3) Get the time stamp for the calibration video using properties, or [Mediainfo](https://mediaarea.net/en/MediaInfo/Download) 
    In our case its D:0 H:10 M:35 S:56
    NOTE: the calibration video should be as close to the start of the accelerometer file as possible
    
(4) Trim section, Set the Min to 0, set the max to a big enough value to show the spikes.  

(5) Set the delay. In our example it is 650. 

(6) Click "save delay"

(7) Set the time stamp for the video of interest. In our case the calibration video contains both the claps and the runs, so we will set the time here to be the same as above.         Further videos may not have spikes, so we need the cali video to allign them. 

(8) Click 'calc time diff' button. This should calculate the time between the calibration video and the 'behaviour video' In this example the time difference will be zero. 

(9) Make sure the 'Apply" radio button is unchecked. Press "Trim accel" 

(10) Select a behaviour by checking the radio button (e.g. Galloping). These can be edited in the GUI for different behaviours. Each is assigned a number (e.g. Galloping is 12).

(11) Export accel. This will export the X,Y,Z accel trace for the video, plus a vector of behaviours associated with each frame.


![Dogs_screenshot](https://user-images.githubusercontent.com/13363767/110420958-40088400-80e8-11eb-9df6-289c4d66320a.jpg)

