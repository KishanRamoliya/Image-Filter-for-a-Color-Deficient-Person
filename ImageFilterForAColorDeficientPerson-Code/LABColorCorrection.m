% LAB Color Correction

% Read input image.
InputImage = imread('Test.png');

% Display input image.
figure; imshow(InputImage);
 
title(' Input Image : ')

% Get dimensions of the image.
[Height Width Depth] = size(InputImage);

% Initialize output image.
FilteredImage = zeros(size(InputImage));

% Converting image to LAB color space.
CForm1 = makecform('srgb2lab');

LABImage = applycform(im2double(InputImage),CForm1);

% Ref : Modifying Images for Color Blind Viewers, By William Woods. Stanford University.
% Red color enhansing scale.
RedScale = 30;

% Green color enhansing scale.
GreenScale = 40;

% Blue color enhansing scale.
BlueScale = 8;

% L scale.
LScale = 2;

% Threshold for comparision.
Threshold = 75;

% Seperationg A value from LAB color space.
AValue = LABImage(:,:,2);

% Get minimum value of A from LAB color space.
AMinValue = min(AValue(:));

% Get maximum value of A from LAB color space.
AMaxValue = max(AValue(:));

% Adjust LAB values based on their relative red/green values
for x = 1:Height
    
    for y = 1:Width
       
        % Get L value of the pixel.
        L = LABImage(x,y,1);
        
        % Get A value of the pixel.
        A = LABImage(x,y,2);
        
        % Get B value of the pixel.
        B = LABImage(x,y,3);       
        
        % Alter the values of LAB.
        if(A > 0 && L < Threshold)
            
            A = A + RedScale;
            
            B = B + BlueScale + (abs(AMaxValue - A));
        
            L = L + LScale * sqrt( abs(AMaxValue - A));
            
        end
        
        % Alter the values of LAB.
        if(A < 0 && L < Threshold)
        
            A = A - GreenScale;
            
            B = B - BlueScale - (abs(AMinValue - A));
            
            L = L - LScale * sqrt( abs(AMinValue - A) );
            
        end
        
        LABImage(x,y,:) = [L A B];
        
    end
    
end

% Convert LAB image to RGB image.
CForm2 = makecform('lab2srgb');

FilteredImage = applycform(LABImage,CForm2);


% Display input image.
figure; imshow(FilteredImage);
 
title(' Output Image : ');

% Matrix for Deuteranopia disorder.
% Ref : Analysis of Color Blindness, By Onur Fidaner and Nevran Ozguven. Stanford University: SCIENCE Lab, 2006. Web. 4 June 2012.
Deuteranopia = [1 0 0; 0.494207 0 1.24827; 0 0 1];

SimulatedImage2 = FilteredImage;

for x = 1:Height
    
    for y = 1:Width
        
        % Get RGB value of the pixel.
        RGB(1:3) = double(FilteredImage(x,y,:));
        
        RGBValue = [RGB(1), RGB(2), RGB(3)];
        
        % Convert RGB to LMS.
        LMS = RGBLMS * RGBValue';
                
        % Implement Deuteranopia by multiplying the matrix.
        LMSValue = Deuteranopia * LMS;
        
        % Convert LMS to RGB.
        OPRGB = LMSRGB * LMSValue;
                
        % Put the final value in the output image.
        SimulatedImage2(x,y,:) = OPRGB;
        
    end
     
end

% Display simulated image.
figure; imshow(SimulatedImage2);
 
title(' Simulation after filtering : ');