function ALGplotPTP( P1,P2, varargin )
%ALGplotPTP - Plots a Line between Point 1 and Point 2 in 3D
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
%   Last modified:  30.06.2016
%   Change Log:     Deleted the hold on & hold of function

%% Predefined parameters
arg   =   'b';

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'test')
        display('Not supported');
    else
        arg = varargin{i};
    end
end

%% Calculation
plotVec = [P1;P2];
x = plotVec(:,1);
y = plotVec(:,2);
z = plotVec(:,3);

%% Plot
plot3(x,y,z,arg);

end