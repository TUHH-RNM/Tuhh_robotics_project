function [ output ] = Xtemplate(x,y, varargin)
%XTEMPLATE - Short description
%   Long descriotion with examples if nessesary.
%
%   Info:
%   Designed by:    Max Mustermann
%   Date created:   01.01.2016
%   Last modified:  07.01.2016
%   Change Log:


%% Predefined parameters
gain1   =   1;
gain2   =   1;

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'gain1')
        gain1 = varargin{i+1};
    end
    if strcmp(varargin{i}, 'gain2')
        gain2 = varargin{i+1};
    end
end

%% Calculation
output = x*gain1 + y*gain2;

end

