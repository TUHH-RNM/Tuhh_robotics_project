%% Add folders

% Check whether current folder is called 'Matlab_Files'
pwdString = pwd;
FileSeperatorIndices = strfind(pwdString,filesep);
index = FileSeperatorIndices(end);
currentFolderName = pwdString(index+1:end);
if ~strcmp(currentFolderName,'Matlab_Files')
    error('Change directory to ''Matlab_Files''')
end

% Check whether 'Matlab_Files' is inside a Git repository
cd('..');
folderListing = dir;
isInGitRepository = false;
for i = 1:numel(folderListing)
    folderName = folderListing(i).name;
    if strcmp(folderName,'.git')
        isInGitRepository = true;
        break
    end
end
cd(pwdString);

if ~isInGitRepository
    error('''Matlab_Files'' is not in Git Repository')
end

addpath(genpath('Calibration'));
addpath(genpath('ForwardKinematics'));
addpath(genpath('KINECT'));
addpath(genpath('NetworkDevices'));
addpath(genpath('TRS'));
addpath(genpath('UR5'));
