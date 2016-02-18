% install_yin.m
% Compiles files in the source directory
% and places compiled files in current working directory.
source_dir = 'src/';
c_files = dir(strcat(source_dir, '*.c'));

for i = 1:length(c_files)
    f = c_files(i).name
    mex(strcat(source_dir, f))
end
cd('..')
addpath(pwd)