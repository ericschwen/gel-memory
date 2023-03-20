function [params, full_image, all_paths] = lena_CZIimport_v2(folder)
%
% [full_image, params, all_paths] = lena_CZIimport_v2(impath)
% 
% dimensions: X, Y, C, Z, S, T

%% Parse inputs
if ~strcmp(folder(end),'\'), folder = [folder '\']; end

%% Extract relevant metadata from xml 'metadata' file

% Read in XML file and convert to struct
meta_file = dir([folder '*_meta.xml']);
meta_filename = meta_file.name;
xml_metadata = xml2struct([folder meta_filename]);
scaling = xml_metadata.ImageMetadata.Experiment.ExperimentBlocks.AcquisitionBlock.AcquisitionModeSetup;
sizing = xml_metadata.ImageMetadata.Information.Image;

% Pixel size in microns
umppx.X = str2double(scaling.ScalingX.Text)*1e6;
umppx.Y = str2double(scaling.ScalingY.Text)*1e6;
umppx.Z = str2double(scaling.ScalingZ.Text)*1e6;

% Stack size in pixels
stack_size.X = str2double(sizing.SizeX.Text);
stack_size.Y = str2double(sizing.SizeY.Text);
stack_size.C = str2double(sizing.SizeC.Text);
stack_size.Z = str2double(sizing.SizeZ.Text);
stack_size.S = str2double(sizing.SizeS.Text);
stack_size.T = str2double(sizing.SizeT.Text);

% Metadata to output
params.umppx = umppx;
params.stack_size = stack_size;

%% Extract and parse TIF image filenames
if nargout>1
    
% Variables for use locally
nX = stack_size.X;
nY = stack_size.Y;
nC = stack_size.C;
nZ = stack_size.Z;
nS = stack_size.S;
nT = stack_size.T;
out_size = [nY nX nC nZ nS nT];
out_supersize = out_size(3:end);
nPlanes = prod(out_supersize);

% Extract filenames of TIF images
files = dir([folder '*.tif']);
filenames = {files.name}';

% Parse filenames for relevant info
name1 = filenames{1};
empty_array = ones(size(filenames));
% -- Color channel
[startix, endix] = regexp(name1, '[c]\d+'); 
if isempty(startix)
    Cix = empty_array;
else
    Cix = cellfun(@(name) str2double(name(startix+1:endix)), filenames);
end
% -- Z page
[startix, endix] = regexp(name1, '[z]\d+'); 
if isempty(startix)
    Zix = empty_array;
else
    Zix = cellfun(@(name) str2double(name(startix+1:endix)), filenames);
end
% -- Scene
[startix, endix] = regexp(name1, '[s]\d+'); 
if isempty(startix)
    Six = empty_array;
else
    Six = cellfun(@(name) str2double(name(startix+1:endix)), filenames);
end
% -- Time
[startix, endix] = regexp(name1, '[t]\d+'); 
if isempty(startix)
    Tix = empty_array;
else
    Tix = cellfun(@(name) str2double(name(startix+1:endix)), filenames);
end

% Check for consistency with metadata
if length(files)~=nPlanes, error('Wrong number of TIF files'); end
if numel(unique(Cix))~=nC, error('Wrong number of color channels'); end
if numel(unique(Zix))~=nZ, error('Wrong number of Z  pages'); end
if numel(unique(Six))~=nS, error('Wrong number of Scenes'); end
if numel(unique(Tix))~=nT, error('Wrong number of Time steps'); end

%% Read in the TIF files, using parallel processing for speed

% Read in first image as an example
firstim = imread([folder name1]);

% Initialize
all_images = repmat({zeros(out_size(1:2), 'like', firstim)}, nPlanes, 1);
ix = NaN(nPlanes, 1);

% Loop for reading TIF files
parfor ff = 1:nPlanes
    ix(ff) = sub2ind(out_supersize, Cix(ff), Zix(ff), Six(ff), Tix(ff));
    all_images{ff} = imread([folder filenames{ff}]);
    
end

% Reshape the output arrays
all_paths = cellfun(@(f){[folder f]}, filenames);
all_paths(ix) = all_paths;
all_images(ix) = all_images;
full_image = cell2mat(reshape(all_images, [1 1 out_supersize]));
all_paths = reshape(all_paths, out_supersize);
    
end












