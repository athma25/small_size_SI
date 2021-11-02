function spaceComp_sweep(id,rep)

close all

%% Reading list of runs file
wd=sprintf('./output/%s',id);
if exist(wd)~=7
	error('Batch folder does not exist');
end

fName=importdata(sprintf('./output/%s/parFiles/sweep.txt',id));
runs=length(fName);

%% Output
out=NaN(runs-1,26);

wSweep=waitbar(0,'Sweep progress');

%% Run sweep
tic
for iRun=1:runs-1
	par=readmatrix(sprintf('./output/%s/parFiles/%s',id,fName{iRun}));
	out(iRun,1:12)=par(1:12,2);
	out(iRun,13:14)=par(14:15,2);
	run=str2double(regexp(fName{iRun},'[0-9][0-9][0-9][0-9]','match'));
	fprintf('Starting run%04d...\n',run);
	run_out=spaceComp_run(id,run,rep);
	out(iRun,15:26)=[run_out(1,:) run_out(2,:)];
	waitbar(iRun/runs,wSweep);
end
toc

fName=sprintf('./output/%s/summary_%s_%d.csv',id,id,rep);
writematrix(out,fName);
close(wSweep);
