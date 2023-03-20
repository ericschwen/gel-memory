function [fileName] = getFileName(file_path)
% Gets the file name and extension given the full file path

parts = strsplit(file_path, '\');
fileName = parts{end};
end
