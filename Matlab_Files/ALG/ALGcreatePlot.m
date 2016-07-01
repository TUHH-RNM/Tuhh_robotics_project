function ALGcreatePlot( varargin )
%ALGcreatePlot - Cleares a current plot figure, or if 'new' is selected,
%   creates a new empty plot figure, shows the grid lines and add axes 
%   labels.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   05.06.2016
%   Last modified:  05.06.2016
%   Change Log:

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'new')
        figure;   
    end
    
end

%% Calculation
clf;
grid on;
xlabel('x');
ylabel('y');
zlabel('z');

end