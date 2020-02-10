function depthMap = grabToFImages(depthVid)

start(depthVid);
pause(1);               % need a bit of delay before getting a good image
depthMap = getsnapshot(depthVid);
figure;imshow(depthMap);
for i=1:50              % Put your hand in front of the camera for a bit
    depthMap = getsnapshot(depthVid);
    imshow(depthMap)
end
stop(depthVid);

end
