function ide_sweep(id)

addpath('.');
close all;

% Reading parameter file
wd=sprintf('./output/%s',id);
if exist(wd)~=7
	error('Batch folder does not exist');
end
cd(wd);

fName=importdata(sprintf('sweep.txt',wd));

runs=length(fName);

wSweep=waitbar(0,sprintf('Sweep progress %s',id));
wRun=waitbar(0,'Run progress');

% Sweep
for iRun=1:runs
	par=readmatrix(fName{iRun});

	c=par(1,2);		
	d=par(2,2);
	K=par(3,2);
	s=par(4,2);
	m=par(5,2);
	T=par(6,2);

	xMin=par(8,2);
	xMax=par(9,2);
	dx=par(10,2);
	maxIter=par(11,2);
	dt=par(12,2);
	dtMin=par(13,2);
	dtMax=par(14,2);
	popm=par(15,2);
	popM=par(16,2);
	tMax=par(17,2);	
	saveI=par(18,2);	

	x=xMin:dx:xMax;					% discretised trait space
	x=transpose(x);
	k=length(x);						% number of bins

	% Variables
	pop=zeros(k,2);
	t=0;

	% Outputs
	str=split(fName{iRun},'.');
	fPop=fopen(sprintf('%s_pop.txt',str{1}),'w');
	fout=fopen(sprintf('%s_out.txt',str{1}),'w');
	writematrix(x,sprintf('%s_x.txt',str{1}));
	ft=fopen(sprintf('%s_t.txt',str{1}),'w');

	% Initial conditions
	pop(:,1)=exp(-x)./x;
	
	for i=1:k-1
		fprintf(fPop,'%f\t',pop(i,1));
	end
	fprintf(fPop,'%f\n',pop(k,1));
	
	% Summary stats
	P=dx*(ksum(pop(:,1))-pop(1,1)/2-pop(end,1)/2);											% Total population
	fprintf(fout,'%f\t%.10f\n',t,P);
	fprintf(ft,'%f\n',t);																								% Time for pop saves

	% Numerical solution
	i=1;

	waitbar(0,wRun,str{1});
	fprintf('%s in progress...\n',str{1});
	tic
	while i<maxIter && t<tMax
		check=0;	% Checks if time step is halved
		pop(:,2)=pop(:,1)+dt*pop(:,1).*((c*(T-zn_int(x,dx,pop(:,1),k))./x)-d-(d*pop(:,1)./(K*exp(-((x-m).^2)/(2*s^2)))));

		if sum(pop(:,2)<0)>0
			dt=dt/2;
			if dt<dtMin
				fprintf('Time step too small\n');
				break;
			end
			fprintf('Time step halved at iteration %d, time %f to dt=%f\n',i,t,dt);
			check=1;
		end
		
		if mod(i-1,10)==0 && 2*dt<=dtMax 
			popTemp=pop(:,1)+2*dt*pop(:,1).*((c*(T-zn_int(x,dx,pop(:,1),k))./x)-d-(d*pop(:,1)./(K*exp(-((x-m).^2)/(2*s^2)))));
			if sum(popTemp<0)==0
				dt=2*dt;
				pop(:,2)=popTemp;
				fprintf('Time step doubled at iteration %d, time %f to dt=%f\n',i,t,dt);
			end
		end
	
		if check==0
			pop(:,1)=pop(:,2);
			t=t+dt;
			i=i+1;	

			% Summary stats
			P=dx*(sum(pop(:,1))-pop(1,1)/2-pop(end,1)/2);												% Total population
			fprintf(fout,'%f\t%.10f\n',t,P);
			if P>popM || P<popm
				fprintf('Population size out of bounds, P(%f)=%f\n',t,P);
				break;
			end

			if mod(i-2,saveI)==0 || i>(maxIter-1e3) || t>(tMax-10) || i<1e3
				j=floor((i-2)/saveI)+1;
				for j=1:k-1
					fprintf(fPop,'%f\t',pop(j,1));
				end
				fprintf(fPop,'%f\n',pop(k,1));
				fprintf(ft,'%f\n',t);
			end
		end
		waitbar(max(i/maxIter,t/tMax),wRun,str{1});
	end
	toc
	fclose(fPop);
	fclose(fout);

	waitbar(iRun/runs,wSweep);
end

close(wRun);
close(wSweep);
cd('../../');
