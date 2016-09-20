% Protanopia Simulation

% Read input image.
InputImage = imread('Test.png');

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

% Matrix for Protanopia disorder.
% Ref : Review of Color Blindness Removal Methods using Image Processing,
% By Ruchi Kulshrestha & R.K. Bairwa. Department of Computer Science &
% Engineering, KITE, Jaipur, India.
% International Journal of Recent Research and Review, Vol.VI, June 2013.
Protanopia = [0 2.02344 -2.52581; 0 1 0; 0 0 1];

for x = 1:Height
    
    for y = 1:Width
        
        % Get RGB value of the pixel.
        RGB(1:3) = double(InputImage(x,y,:));
        
        RGBValue = [RGB(1), RGB(2), RGB(3)];
        
        % Convert RGB to LMS.
        LMS = RGBLMS * RGBValue';
                
        % Implement Protanopia by multiplying the matrix.
        LMSValue = Protanopia * LMS;
        
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
 
title(' Information lost in Protanopia Simulation : ');

% Display simulated image.
figure; imshow(SimulatedImage);
 
title(' Simulated Protanopia Image : ');