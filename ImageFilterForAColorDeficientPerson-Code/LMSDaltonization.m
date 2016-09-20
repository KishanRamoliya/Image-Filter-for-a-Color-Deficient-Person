% LMS Daltonization

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

%--------------------------------------------------------------------------
% LMS Daltonization

% Initialize the individual pixel matrix.
InformationLostPixel = zeros(3,1);

% Initialize the correction image.
Correction = SimulatedImage;

% Correction matrix which will correct the input image.
% Reference : Intelligent modification for the daltonization process of
% digitized paintings, By Christos-Nikolaos Anagnostopoulos, George
% Tsekouras, Ioannis Anagnostopoulos, Christos Kalloniatis.  Cultural Technology & Communication Dpt.,
% University of the Aegean, Mytilene, Lesvos, Greece, 81 100.
CorrectionMatrix = [0 0 0; 0.7 1 0; 0.7 0 1];

% Perform correction on the lost information data.
for x = 1:Height
    
    for y = 1:Width
        
        InformationLostPixel(1:3) = double(InformationLost(x,y,:));
        
        % Getting lost information.
        InformationLostPixelValue = [InformationLostPixel(1), InformationLostPixel(2), InformationLostPixel(3)];
        
        % Implement Deuteranopia correction by multiplying the correction matrix.
        Final = CorrectionMatrix * InformationLostPixelValue';
        
        Correction(x,y,:) = Final;
        
    end
    
end

% Add the correction to the original image.
FilteredImage = InputImage + Correction;

% Display filtered image.
figure; imshow(FilteredImage);
 
title(' Filtered Image : ');

%--------------------------------------------------------------------------
% Output Simulation

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