function msgOut = sendReceive(self, msgIn, delay)
%% Default delay set to 1.
if nargin == 2
    delay = 1;
end

%% Writing to server.
jtcp('write', self.client, int8(msgIn));

% % Wait a bit.
pause(delay);

%% Recieve the reply.
rawData = jtcp('read', self.client);
msgOut = char(rawData);
while(~isempty(msgIn) && isempty(msgOut))
    pause(0.2);
    if self.verbose
        disp('Waiting for answer (msgOut)...');
    end
    rawData = jtcp('read', self.client);
    msgOut = char(rawData);
end
if self.verbose
    self.displayCmdMsg(msgIn,msgOut);
end
end