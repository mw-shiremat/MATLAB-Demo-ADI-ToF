%% Copyright 2020 The MathWorks, Inc.
% Updated Rock-Paper-Scissors demo to work with Analog Devices ToF Depth Camera
% This requires the ToF camera to be connected to an R-Pi.  The R-Pi must
% be connected to the computer running MATLAB by Ethernet. On the R-Pi, you
% must run "aditof-server.sh" before accessing the camera from MATLAB.

%% Set Region of Interest Rectangle
% This might need to change depending on what's going on in the background
% of your setup.  This rectangle is setup to crop out thermal noise due to
% a halogen light that showed up at the top of the image.
rect = [1 121 640 480];
% These are needed later to position text overlays
position1 = [(rect(3)-rect(1)-160) (rect(4)-rect(2)-49)];
position2 = [(rect(3)-rect(1)-160)  (rect(4)-rect(2)-19)];

%% Open a connection to the ADI ToF camera. Be careful to not delete this 
% You cannot open a second connection to the camera. You must close this
% connection before you can open another one.  Be careful not to delete this 
% variable.  Also make sure to update the IP address as appropriate for
% your setup.

prompt = 'Please input the IP address of your device:';
ip_addr = inputdlg(prompt,'',1,{'IP Address goes here'}); 

%% For Testing
% msgbox(pwd);

%% Register the ADI ToF adapter 
hwinfo= imaqhwinfo;
if ~any(strcmp(hwinfo.InstalledAdaptors, 'aditofadapter'))
    imaqregister([pwd, '\aditofadapter.dll']);
    imaqreset;
end

%% For Testing
% info = imaqhwinfo('aditofadapter');
% msgbox(info.AdaptorDllName);

%% Start camera input and detect hand gestures
depthVid = videoinput('aditofadapter', 1, ip_addr{1});
viewer = vision.DeployableVideoPlayer();
noHandImage = zeros(rect(4)-rect(2)+1,rect(3)-rect(1)+1,3);
noHandImage = insertText(noHandImage, position1, 'No hand present');
viewer(noHandImage);
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
triggerconfig(depthVid,'manual');

start(depthVid);
while isOpen(viewer)
    trigger(depthVid);
    depthMap = getdata(depthVid); % hand must be upright
    I = imcrop(depthMap, rect);  
    %Use the function detectHandGestureToF to identify the correct hand
    %gesture (rock -paper-scissors) in the frame.
    valid = detectHandGestureToF(I,viewer,position1,position2);
    if ~valid
        viewer(noHandImage);
    end
end

%% End camera input
stop(depthVid);
release(viewer);
delete(depthVid);
