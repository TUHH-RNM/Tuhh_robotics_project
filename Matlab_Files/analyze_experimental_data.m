%% Analyze the experimental data from the final evaluation
% Load the experimental data
load('posesForEvalGrp3')

nSamples = size(B3_T_E3,3);
deviationVector = zeros(nSamples,1);
B5_T_B3 = invertHTM(B3_T_B5);
for i = 1:nSamples
    T = invertHTM(B5_T_E5(:,:,i))*B5_T_B3*B3_T_E3(:,:,i);
    deviationMatrix = E5_T_E3 - T;
    deviationVector(i) = norm(deviationMatrix,'fro');
end 

tMeasRange = linspace(0,264,nSamples);
plot(tMeasRange,deviationVector)
xlabel('time [s]')
ylabel('d')
xlim([0,265])
grid on