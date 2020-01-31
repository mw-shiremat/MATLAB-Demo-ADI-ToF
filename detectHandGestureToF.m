%% Copyright 2020 The MathWorks, Inc.
function valid = detectHandGestureToF(image, videoPlayer, position1, position2)
numfingers = -1;
gesture = 'Unclassified';
valid = 0;
%% Use the cropped hand and extract the palm
Ihsv = rgb2hsv(image);
BW = Ihsv(:,:,1) <= 0.25;
BW = imopen(BW,strel('disk',3));
BW = imfill(BW,'holes');
BWmarked = double(cat(3,BW,BW,BW));

%% Classify the gesture as Rock, Paper or Scissor
% Code for classification of hand gesture - rock, paper or scissors
% Part i): Extract Convex Hull

blobs = regionprops(BW,'Area','Centroid','ConvexHull');

if ~isempty(blobs)
    % Find points for the largest blob
    valid = 1;
    [~,ind] = max([blobs.Area]);
    blobs = blobs(ind);
    % Obtain the convex hull
    x = blobs.ConvexHull(1:end-1,1); %Ignore last point which is same as first
    y = blobs.ConvexHull(1:end-1,2);
    c = blobs.Centroid;
    x(y>c(2))= 0;
    y(y>c(2))= 0;
    x = nonzeros(x);
    y = nonzeros(y);
    d = sqrt((x-c(1)).^2 + (y-c(2)).^2);
    % Use distance transform to find the distance to background
    bwd = bwdist(~BW);
    % Find radius of the circle to nearest background from centroid
    radius = bwd(round(c(2)), round(c(1)));
    % If the distance is greater than 2 times the radius of the circle,
    % it is an open hand.
    x((d - 2.25*radius)<0) = 0;
    y((d - 2.25*radius)<0) = 0;
    x = nonzeros(x);
    y = nonzeros(y);
    if length(x) < 1
        numfingers = 0;
    else
        dist_vec = zeros(1,length(x));
        p1 = [x(end) y(end)];
        p2 = [x(1) y(1)];
        dist_vec(1) = sqrt((p1(1)-p2(1)).^2+(p1(2)-p2(2)).^2);
        for i=2:length(x)
            p1 = [x(i-1) y(i-1)];
            p2 = [x(i) y(i)];
            dist_vec(i) = sqrt((p1(1)-p2(1)).^2+(p1(2)-p2(2)).^2);
        end
        
        fingersX = x(dist_vec(:) > 10); % select only points > 10 pixels from neighbors
        fingersY = y(dist_vec(:) > 10);
        
        numfingers = length(fingersX);
    end
end

if numfingers < 0
    gesture = 'no hand present';
else
    BWmarked = insertShape(BWmarked,'circle',[c(1),c(2) 2],'Color','green');
    if numfingers == 0
        gesture = 'rock';
    else
        BWmarked = insertMarker(BWmarked, [fingersX fingersY], 'o', 'color', 'red', 'size', 6);
        if numfingers == 1
            gesture = 'that''s not acceptable';
        elseif numfingers == 2
            gesture = 'scissors';
        elseif numfingers <= 5
            gesture = 'paper';
        end
end
numfingers = num2str(numfingers);

% Video player

BWmarked = insertText(BWmarked, position1, gesture);
BWmarked = insertText(BWmarked, position2, [numfingers ' fingers']);
step(videoPlayer,BWmarked);

end

