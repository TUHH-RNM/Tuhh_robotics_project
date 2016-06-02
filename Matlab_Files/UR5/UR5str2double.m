function [ var ] = UR5str2double( text, varargin )
%UR5STR2DOUBLE -  Converts the sring input into a double vector. 
%   If you want to speed the function up or get a specific form, you can 
%   define the size of the expected matrix by varCol and varRow.
%
%   E.g.: var = UR5str2double('-91.713354 -98.955541 -126.222602 -46.294990
%   91.392498 -1.776169','varRow',2,'varCol',3) 
%   Leads to:
%   var =
%          -91.7134 -126.2226   91.3925
%          -98.9555  -46.2950   -1.7762
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:

%% Predefined parameters
numCol  =   1;
numRow  =   1;

%% varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'varCol')
        numCol = varargin{i+1};
    end
    if strcmp(varargin{i}, 'varRow')
        numRow = varargin{i+1};
    end
end

%% Variables
charCntr    = 1;
varCntr     = 1;
buff = ' ';
var = zeros(numRow,numCol);

%% Decode
for i=1:numel(text)
    if(text(i) ~= ' ')
        buff(charCntr) = text(i);
        charCntr = charCntr + 1;
    else
        var(varCntr) = str2double(buff);
        buff = ' ';
        varCntr = varCntr + 1;
        charCntr = 1;
    end
end
var(varCntr) = str2double(buff);

end

