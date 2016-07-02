function ALGplotPoint( point, varargin )
%ALGplotPoint - Plots 1 or more points which are given as row vectors 
%
%   You can spezifie the color and form by the standart matlab
%   color code. 
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   01.07.2016
%   Last modified:  01.07.2016
%   Change Log:     Deleted the hold on & hold of function

%% Predefined parameters
arg         = 'b*';
LineWidth   = 1;
%% Varargin
cont = false;
for i=1:numel(varargin)
    if cont
        continue
        cont = false;
    end
    if strcmp(varargin{i},'LineWidth')
        LineWidth = varargin{i+1};
        cont = true;
    else
        arg = varargin{i};
    end
end

%% Plot
plot3(point(:,1),point(:,2),point(:,3),arg,'LineWidth',LineWidth);

end