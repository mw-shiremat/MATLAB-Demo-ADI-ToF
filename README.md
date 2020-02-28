# ADIToF_MATLABDemo
Using MATLAB with Analog Devices Inc. ToF camera system. 

Demo example - Detecting hand signs to play Rock, Paper, and Scissors.
Description - Use MATLAB with the ADI ToF camera to detect and identify the hand signal for Rock, Paper, and Scissors. The depth percention from the ToF camera system makes it easy to find the hand. 

Demo in MATLAB - 
0. Open RockPaperScissorsToFScript.mlx in MATLAB
1. Detect the hand 
2. Measure hand, and determine fingers extensions
3. Count fingers
Other topics - Camera calibration using MATLAB

Standalone application (no need for MATLAB)-
1. Install MATLAB Compiler Runtime (MCR) on your machine from here:
https://www.mathworks.com/products/compiler/matlab-runtime.html
NOTE: The version of the MATLAB Runtime is tied to the version of MATLAB used to build the application.
2. Open the DetectHandGestureADIToF.exe 

Camera Calibrator App 
Example - Measuring penny size from an image
https://www.mathworks.com/help/releases/R2019b/vision/examples/measuring-planar-objects-with-a-calibrated-camera.html

MathWorks products required - 
•	MATLAB
•	Image Acquisition Toolbox
•	Image Processing Toolbox
•	Computer Vision Toolbox
•	MATLAB Compiler (optional - for compiling the app)

Other files/products required -
•	The two DLLs from ADI 
o	  Aditofadapter.dll
o	  Aditof.dll


Refer to PPT file in the Slides folder for more details on the demo. 
