function [T,visFlag,timestamp] = getTransformMatrix(self)
% getTransformMatrix  Gets the transform matrix of the loaded locator
% TCP/IP object associated with the CambarServer needs to be provided.
%   T = camera.getTransformMatrix()

pause(0.1);

msg = self.sendReceive(sprintf('CM_NEXTVALUE\n'), 0.1);

C = strsplit(msg,' ');
if strcmp(C{1}(1:end-1),'ANS_FALSE')
    visFlag = false;
    timestamp = -1;
    T = eye(4);
else
% Format:
% 1. timestamp
% 2. visible-flag
% 3. 4x4 position ,matrix of the locator:
%   R00, R01, R02, X, R10, R11, R12, Y, R20, R21, R22, Z, 0, 0, 0, 1
T = [str2double(C{3}),str2double(C{4}),str2double(C{5}),str2double(C{6});
    str2double(C{7}),str2double(C{8}),str2double(C{9}),str2double(C{10});
    str2double(C{11}),str2double(C{12}),str2double(C{13}),str2double(C{14});
    0, 0, 0, 1];

visFlag = false;
if strcmp(C{2},'y')
    visFlag = true;
end
timestamp = str2double(C{1});
end
end