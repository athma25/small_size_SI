function out=spaceComp_run(id,run,rep)

% Simulates the specified run for rep reptitions parallely using spaceComp_rep
% Outputs Mean and variance of i, t, n(1), n(2) for all the repetitions

close all

out=NaN(2,6);

%fprintf('Run%04d in progress',run);
wd=sprintf('./output/%s',id);
if exist(wd)~=7
	error('Batch folder does not exist');
end

wd=sprintf('./output/%s/seeds',id);
if exist(wd)~=7
	error('Seeds folder does not exist');
end

%% Reading parameters
fName=sprintf('./output/%s/parFiles/run%04d.txt',id,run);
if exist(fName)~=2
	error('Parameter file does not exist');
end

fPar=fopen(fName,'r');
par=textscan(fPar,'%s');
fclose(fPar);
par=par{1};

% Model parameters
l=str2num(par{6});
r=[str2num(par{11}) str2num(par{18})];

b=[str2num(par{23}) str2num(par{32})];
d=[str2num(par{37}) str2num(par{45})];

disp=str2num(par{50});		% 0: uniform dispersal; 1: 2D truncated uncorrelated Gaussian centred at the parent
sd=[str2num(par{56}) str2num(par{66})];% Std. deviation of the Gaussian dispersal kernel

% Simulation parameters
T=str2num(par{87});				% Total time
maxI=str2num(par{91});		% Total iterations

nReps=NaN(rep,6);
parfor iRep=1:rep
%	fprintf('Starting run%04d rep%04d\n',run,iRep);
	% File names
	seedf=sprintf('./output/%s/seeds/seed%04d_%04d.mat',id,run,iRep);
	outf=sprintf('./output/%s/data/series%04d_%04d.txt',id,run,iRep);

	N=ceil(l^2/r(1)^2);					% Maximum number of individuals possible
  n0=[str2num(par{71}) str2num(par{78})];
	
	nReps(iRep,:)=spaceComp_rep(l,r,b,d,disp,sd,T,maxI,N,seedf,outf,n0);
end

csvwrite(sprintf('./output/%s/data/summary%04d_%04d',id,run,rep),nReps);
out=[mean(nReps,1); std(nReps,1)];
end
