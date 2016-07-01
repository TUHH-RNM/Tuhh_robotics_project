function ALGplotVec( Vector, varargin )
%ALGplotVec - Plots a Vector, beginning at [0;0;0]
%   
%   This functions plots a vector into a 3D plot. The Vector must be given
%   as a column vector. The endpoint is spezified by the Vector
%
%   You can spezifie the color by the standart matlab
%   color code. 
%   
%   The beginning point of the vector is usually [0;0;0]. If you want to
%   change these, it is posible with 'base' and the followed coordinates of
%   the base.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   05.06.2016
%   Last modified:  05.06.2016
%   Change Log:

%% Predefined parameters
color   =   'b';
base    =   zeros(1,3);

%% Varargin
for i=1:numel(varargin)
    if     strcmp(varargin{i}, 'base')
        base = varargin{i+1};
    elseif strcmp(varargin{i}, 'y')
        color = 'y';
    elseif strcmp(varargin{i}, 'm')
        color = 'm';
    elseif strcmp(varargin{i}, 'c')
        color = 'c';
    elseif strcmp(varargin{i}, 'r')
        color = 'r';
    elseif strcmp(varargin{i}, 'g')
        color = 'g';
    elseif strcmp(varargin{i}, 'b')
        color = 'b';
    elseif strcmp(varargin{i}, 'w')
        color = 'w';
    elseif strcmp(varargin{i}, 'k')
        color = 'k';        
    end
end

%% Calculation
plotVec = [base;Vector];
x = plotVec(:,1);
y = plotVec(:,2);
z = plotVec(:,3);

%% Plot
hold on
plot3(x,y,z,color);
hold off

end