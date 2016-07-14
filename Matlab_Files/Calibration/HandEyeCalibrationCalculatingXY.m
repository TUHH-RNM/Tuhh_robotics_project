function [X, Y] = HandEyeCalibrationCalculatingXY(M, N, varargin)
% HandEyeCalibrationCalculatingXY - calculates the X and Y matrices
% from the equation MX = YN by constructing a system of equations 
% Aw = b and solving for w, where w contains the nx*(nx-1) and 
% ny*(ny-1)values of the respectives matrices X and Y. 
% w = [x11 -> x34, y11 -> y34]; M and N are arrays of the matrices
% that contain the measurements. This calibration method is described in
% the paper of Ernst et al. This method is called 'QR24'
%   
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   25.06.2016
%   Last modified:  26.06.2016
%   Change Log:

%% consistency check
sizeM = size(M);
sizeN = size(N);

linesM = sizeM(1);
columnsM = sizeM(2);
numberM = sizeM(3);

linesN = sizeN(1);
columnsN = sizeN(2);
numberN = sizeN(3);

if numberM ~= numberN
    msg = 'There are not as much matrices Mi as Ni';
    error(msg); 
end

if linesM ~= linesN || columnsM ~= columnsN
    msg = 'The dimensions of M differ from dimensions of N';
    error(msg); 
end

%% Remove all matrices which are marked as incorrect
correctIndices = ~squeeze(isnan(M(1,1,:)));
M = M(:,:,correctIndices);
N = N(:,:,correctIndices);
numberM = nnz(correctIndices);
numberN = nnz(correctIndices); %#ok<NASGU>

%% Calculating the matrices from the measurements
% Building the matrix A and the vector b from the input matrices 
% according to (MiX = YNi) => (Aw = b)

A = zeros(12,24);
b = zeros(12,1);

N(1:3,4,:) = N(1:3,4,:)/1000;
M(1:3,4,:) = M(1:3,4,:)/1000;
for i=1:numberM
    
    
    
    % Exctracting the ith-matrix from the array
    Ni = N(:,:,i);
    Mi = M(:,:,i);
    
    Ni(1:3,4) = Ni(1:3,4);
    Mi(1:3,4) = Mi(1:3,4);
    
    Ni = inv(Ni);
    
    % Rotation matrix of Mi(needed later)
    RMi = Mi(1:3,1:3);

    % Calculating the matrix Ai to solve the equation
    Ai = ...
    [RMi*Ni(1,1) RMi*Ni(2,1) RMi*Ni(3,1) zeros(3,3);
    RMi*Ni(1,2) RMi*Ni(2,2) RMi*Ni(3,2) zeros(3,3);
    RMi*Ni(1,3) RMi*Ni(2,3) RMi*Ni(3,3) zeros(3,3);
    RMi*Ni(1,4) RMi*Ni(2,4) RMi*Ni(3,4) RMi;];
    Ai(1:12,13:24) = -eye(12);

    % Calculating the vector bi to solve the equation
    bi = [zeros(1,9) -Mi(1:3,4)']';

    % Constructing a big system of equations from all the Ai and bi
    rowIndex = ((i-1)*12+1:i*12);
    A(rowIndex,1:24) = Ai;
    b(rowIndex,1) = bi;   
end

%% Calculating the solution
w = A\b;

%% Forming the X and Y matrices from the solution vector (only rotation)
% XRot = [w(1:3) w(4:6) w(7:9)]; % not orthogonal version is not used
YRot = [w(13:15) w(16:18) w(19:21)];
Y = [w(13:15) w(16:18) w(19:21) w(22:24); [0 0 0 1]];
XOrthArray = zeros(4,4,numberN);
YOrthArray = zeros(4,4,numberN);

%% Orthogonalizing the X and Y rotation matrices
for i=1:numberM
    Mi = M(:,:,i);
    Ni = N(:,:,i);
%    MiRot = Mi(1:3,1:3);
%     NiRot = Ni(1:3,1:3);
    YNi = Y*Ni;
    [U,~,V] = svd(YNi(1:3,1:3));
    YNiRotOrth = U*V'; 
    
%     YRotOrth = YNiRotOrth*NiRot';
%     XRotOrth = MiRot'*YRotOrth*NiRot;   
%     
%     XRotOrthArray(:,:,i) = XRotOrth;
%     YRotOrthArray(:,:,i) = YRotOrth;   

    YNiOrth = [YNiRotOrth, YNi(1:3,4); [0 0 0 1]];
    YOrth = YNiOrth*invertHTM(Ni);
    XOrth = invertHTM(Mi)*YNiOrth;
    
    XOrthArray(:,:,i) = XOrth;
    YOrthArray(:,:,i) = YOrth;   

end

%% Averaging the orthonormalized rotation matrices
% another averaging approach could be used
sumX = zeros(4,4);
sumY = zeros(4,4);
for i=1:numberM    
    sumX = sumX + XOrthArray(:,:,i);
    sumY = sumY + YOrthArray(:,:,i);
end
averageX = sumX/numberM;
averageY = sumY/numberM;

%% Forming the X and Y matrices from the averaged rotation matrices
% and the solution vector w where the translations are saved as well 
X = averageX;
Y = averageY;
