%% EEE3032 2016 Coursework solution
%% Joshua Tyler Spring 2016
%%
%% visual_search.m
%% This program:
%%  1 Calls the script to compute decriptors
%%  2 Calls the script to compare one image to another
%%  3 Calls the script to visualise the results

%Globals
global verbosity_level;
verbosity_level = 2;
%0 is no debug messages
%1 is short debug messages
%2 is extended debug messages

% Constants
IMAGE_DIRECTORY = 'c:/cvpr/msrc_v2/images';
%IMAGE_DIRECTORY = 'c:/cvpr/test_imgs';
DESCRIPTOR_DIRECTORY = 'c:/cvpr/computed_descriptors';
OUTPUT_DIRECTORY = 'c:/cvpr/computed_results';

COLOR = @(x)vs_compute_rgb_histogram(x,2);
FREQ = @(x)vs_edge_detect(x,@(x)vs_compute_histogram(x,1.0,8),0.2);

COLOR_AND_FREQ = @(x)horzcat( COLOR(x), FREQ(x));

DESCRIPTOR_FUNCTION = @(x)vs_grid(x,4,2, COLOR_AND_FREQ );
COMPARATOR_FUNCTION = @vs_L2_norm;

% Stage 1. Compute descriptors
% Parameters:
%  1 Function handle to decriptor generator.
%  2 Directory containing images to compute descriptors for.
%  3 Directory to save descriptors in.
%      N.B. Images will be saved inside a subfolder with the same name as the generator function
%  4 An argument to decide whether the user should be prompted to overwrite descriptors, or if the program should just do it.
vs_compute(DESCRIPTOR_FUNCTION, IMAGE_DIRECTORY, DESCRIPTOR_DIRECTORY, false);

% Stage 2. Compare descriptors
% Parameters:
%  1 Function handle to comparator function
%  2 Directory containing descriptors
%  3 Descriptor function (for locating subfolder)
%  4 File name of the desired query file (no extension)
%       N.B. Argument 4 is optional, if omitted, a random image will be selected.
% Return values:
%  1 Matrix where:
%       Col 1: Ordered distance measures
%       Col 2: File names
%       Col 3: Boolean - true if relevant.
%   N.B. Top result will be query image.
[ compare_result ] = vs_compare(COMPARATOR_FUNCTION, DESCRIPTOR_DIRECTORY, DESCRIPTOR_FUNCTION);%, '10_29_s');

% Stage 3. Display results
% Parameters:
%  1 Matrix output by vs_compare
%  2 Directory containing images
%  3 Number of images to display
vs_display(compare_result, IMAGE_DIRECTORY, 10);

% Stage 4. Plot precision-recall curve
% Parameters:
%  1 Matrix output by vs_compare
%  2 Filename to save result as text (optional)
vs_compute_pr(compare_result, OUTPUT_DIRECTORY,'pr.txt');