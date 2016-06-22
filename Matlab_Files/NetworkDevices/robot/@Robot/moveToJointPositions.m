function moved = moveToJointPositions(self, newJointPositions)
if(iscell(newJointPositions))
    newJointPositions = newJointPositions{1};
end
if(all(size(newJointPositions) == [6,1]))
    newJointPositions = newJointPositions';
end
% Expects a 1x6 array for the newJointPositions
if (~all(size(newJointPositions) == [1,6]))
    error('moveToJointPositions: A 1x6 array for the newJointPositions! newJointPositions: %f', newJointPositions)
else
    msg = self.sendReceive(['MovePTPJoints ' ...
        sprintf('%0.6f ',newJointPositions');], 1);
    
    if (strcmp(strtrim(msg),'true'))
        moved = 1;
        if self.waitForRobotMov
            self.waitUntilRobotMoves();
        end
    else
        moved = 0;
        warning ('moveToJointPositions unsuccessful. msg: %s', msg);
    end
end
end
