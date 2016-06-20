function [vec] = backwardCalc(self,matrix,configuration)
sendMsg = ['BackwardCalc ' ...
    sprintf('%0.6f ', reshape(matrix',1,12)) ...
    char(configuration)];

recvMsg = self.sendReceive(sendMsg, 0.3);
C = textscan(recvMsg,'%f');
vec = C{:};
end
