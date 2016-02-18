% SAT2csv.m
% Kyler Brown (kjbrown@uchicago.edu)
% Uses the SAT library, the matlab version of Sound Analysis Pro,
% to write the featues of a set of .wav files to a CSV for
% analysis in a more civilized language.
% SAT2CSV ASSUMES THAT ALL WAV FILES ARE CONTIGUOUS BY ALPHANUMERIC ORDER.
% If you have multiple .wav files from different experiments or sessions
% use different directories and run SAT2CSV separately on each directory.

%=== Requirements
% SAT and Yin must be installed and added to the path.
% See http://soundanalysispro.com/matlab-sat.
%
global SAT_params; % make SAT parameters available to manipulate from workspace

spacing = SAT_params.FFT_step;


fileID = fopen('SAP_features.csv','w');
fprintf(fileID, 'sample,goodness,mean_frequency,FM,amplitude,entropy,pitch,aperiodicity,AM\n');
original_sample = 0; % counter to relate data to original data
                       % sap data goes in SPACING increments

a=dir('*.wav'); % Get file names from folder into array files
files={a.name};

for j=1:length(files)
    disp(files(j))
    disp(j/length(files)*100)
    sound=SAT_sound(char(files(j)),0); % do not plot results
    for i = 1:sound.num_slices
        fprintf(fileID,'%li,%18g,%18g,%18g,%18g,%18g,%18g,%18g,%18g\n', ...
            original_sample * spacing, ...
            sound.features.goodness(i), ...
            sound.features.mean_frequency(i), ...
            sound.features.FM(i), ...
            sound.features.amplitude(i), ...
            sound.features.entropy(i), ...
            sound.features.pitch(i), ...
            sound.features.aperiodicity(i), ...
            sound.features.AM(i));
        original_sample = original_sample + spacing;
    end
end

                     



% % Example 2: Batch 
% % Compute a histogram of feature distribution across subjects:
%
% a=dir('*.wav'); % Get file names from folder into array files
% files={a.name};
% recnum=1;
% filenum=1;
% results=zeros(5,50000); % 50,000 initial memory alocation to improve performance
% for i=1:length(files)
%    sound=SAT_sound(char(files(i)),0); % do not plot results
%    results(1,recnum:recnum+sound.num_slices-1)=1:sound.num_slices;
%    results(2,recnum:recnum+sound.num_slices-1)=filenum;
%    results(3,recnum:recnum+sound.num_slices-1)=sound.features.amplitude;
%    results(4,recnum:recnum+sound.num_slices-1)=sound.features.pitch;
%    results(5,recnum:recnum+sound.num_slices-1)=sound.features.entropy;
%    filenum=filenum+1;
% end;

% 
% SAT_params.segmentation_feature=SAT_params.pitch; % use pitch for segmentation
% SAT_params.segmentation_threshold = 3000; % we want to extract high pitch >3000Hz syllables
% SAT_params.segmentation_threshold_direction=1; % 1=more than, -1=less than
% SAT_params.segmentation_smooth=20; % smooth the pitch a little bit
% mySound.segment; % segment the sound according to pitch