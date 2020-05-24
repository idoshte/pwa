cd D:\Users\idoko\‏‏מסמכים\kalmanFilterCovid-19
table = readtable('makor/allDataConfirmed.csv');
table = table(:,4:size(table,2));
activeCases =table2array(table);
predictCases =zeros(1,size(activeCases,2));
combineCases = predictCases;
t = 1;
F=[1,t;0,1];
Q=0.01*eye(2);
R=0.01;
P = eye(2);
H=[1,0];
ratePredicte= predictCases;
rateCombine = predictCases;
for val =2:size(activeCases,2)
    P=F*P*F'+Q;
    K=P*H'*(H*P*H'+R)^-1;
    temp = F*[combineCases(val-1);rateCombine(val-1)];
     predictCases(1,val)=temp(1,1);
     ratePredict(1,val) = temp(2,1);
     E = activeCases(1,val)-H*[predictCases(1,val);ratePredict(1,val)];
     temp = [predictCases(1,val);ratePredict(1,val)]+K*E;
     combineCases (1,val) = temp(1,1);
     rateCombine (1,val ) = temp(2,1);
     P = (eye(2)-K*H)*P;
end
temp = F*[combineCases(val);rateCombine(val)];
predictCases(1,val+1)=temp(1,1);
activeCases(1,val+1) = predictCases(1,val+1);
ratePredict(1,val+1) = temp(2,1);
start = datetime(2020,01,22);
dates = start + [1:size(activeCases,2)];
activeCases =activeCases';
dates = dates';
predictCases = predictCases';
ratePredict = ratePredict';
plot(dates,[predictCases,activeCases,ratePredict]);
matrixExport =[(1:length(activeCases))',activeCases,predictCases,ratePredict];
csvwrite('export/exportConfirmed.csv',matrixExport)  
    

