% Deuteranopia Simulation

% Read input image.
InputImage = imread('Test.jpg');

% Display input image.
figure; imshow(InputImage);
 
title(' Input Image : ')

% Get dimensions of the image.
[Height Width Depth] = size(InputImage);

SimulatedImage = InputImage;

% Convertion matrix for RGB to LMS.
% Ref : https://ssodelta.wordpress.com/tag/rgb-to-lms/
RGBLMS = [17.8824 43.5161 4.1193; 3.4557 27.1554 3.8671; 0.02996 0.18431 1.4670];

% Also inverse of the above matrix will give RGB back from LMS.
LMSRGB = inv(RGBLMS);

% Matrix for Deuteranopia disorder.
% Ref : Analysis of Color Blindness, By Onur Fidaner and Nevran Ozguven. Stanford University: SCIENCE Lab, 2006. Web. 4 June 2012.
Deuteranopia = [1 0 0; 0.494207 0 1.24827; 0 0 1];

for x = 1:Height
    
    for y = 1:Width
        
        % Get RGB value of the pixel.
        RGB(1:3) = double(InputImage(x,y,:));
        
        RGBValue = [RGB(1), RGB(2), RGB(3)];
        
        % Convert RGB to LMS.
        LMS = RGBLMS * RGBValue';
                
        % Implement Deuteranopia by multiplying the matrix.
        LMSValue = Deuteranopia * LMS;
        
        % Convert LMS to RGB.
        OPRGB = LMSRGB * LMSValue;
                
        % Put the final value in the output image.
        SimulatedImage(x,y,:) = OPRGB;
        
    end
     
end

% Information lost after simulation.
InformationLost = InputImage - SimulatedImage;

% Display output image.
figure; imshow(InformationLost);
 
title(' Information lost in Deuteranopia Simulation : ');

% Display simulated image.
figure; imshow(SimulatedImage);
 
title(' Simulated Deuteranopia Image : ');