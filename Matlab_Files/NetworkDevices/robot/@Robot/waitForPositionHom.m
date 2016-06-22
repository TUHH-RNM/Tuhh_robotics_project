function waitForPositionHom(self,H)
if(~all(size(H) == [3,4]))
    error('Hom matrix has to have 3x4 dimensions');
else
    currentH = self.getPositionHomRowWise();
    while(sum(abs(currentH(:)-H(:))) > 1e-1)
        i = 0;
        while(size(self.client.outputStream) == 0)
            i = i + 1;
            if(mod(i, 10))
                disp('Waiting for positioning...');
            end
        end
        
        pause(0.5);
        currentH = self.getPositionHomRowWise();
    end
end
end

