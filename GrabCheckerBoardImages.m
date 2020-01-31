%% This script is for Grabbing Checkboard Calibration Images using the
%% ADI ToF Camera
imaqreset;
%% Run this only if the 'aditofadapter' adapter is not present
% You need to update the location of the DLL as appropriate for your
% setup.
%imaqregister('c:\work\demos\ADI\aditofadapter.dll');


%% Open a connection to the ADI ToF camera. Be careful to not delete this 
% You cannot open a second connection to the camera. You must close this
% connection before you can open another one.  Be careful not to delete this 
% variable.  Also make sure to update the IP address as appropriate for
% your setup.

CamVid = videoinput('aditofadapter', 'ToF Ethernet Device', '169.254.77.142');
%%
src = getselectedsource (CamVid); 
src.FrameType = 'Ir';
src.CameraMode = 'Far';

% Now wait until depthVid shows up in the workspace before moving on to the
% next code section.

%% Grab image

start(CamVid);
pause(2);               % need a bit of delay before getting a good image
image = getsnapshot(CamVid);
figure;imshow(image);
stop(CamVid);

%% Grab images
start(CamVid);
pause(1);               % need a bit of delay before getting a good image
image = getsnapshot(CamVid);
figure;imshow(image);
pause(2)
for i=26:50              % Put your hand in front of the camera for a bit
    pause(2)
    image = getsnapshot(CamVid);
    imshow(image);
    drawnow
    filename = ['calibration\checkboard' num2str(i,'%03d') '.png']
    imwrite(image,filename);
end
stop(CamVid);
%%
delete(CamVid);