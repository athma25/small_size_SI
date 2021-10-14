function ide_plot(id)

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

f=figure(1);
set(f,'Position',[150 450 1000 300],'Visible','off');
ann=annotation(f,'textbox',[0.07 0.92 0.40 0.07]);

wSweep=waitbar(0,'Sweep progress');

% Summary file
sumStat=NaN(runs,11);

% Sweep
for iRun=1:runs
	% Read parameters
	par=readmatrix(fName{iRun});

	c=par(1,2);		
	d=par(2,2);
	K=par(3,2);
	s=par(4,2);
	m=par(5,2);
	T=par(6,2);

	sumStat(iRun,1)=iRun;
	sumStat(iRun,2:7)=par(1:6,2);

	xMin=par(8,2);
	sumStat(iRun,10)=xMin;
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

	% Read outputs
	str=split(fName{iRun},'.');
	x=readmatrix(sprintf('%s_x.txt',str{1}));
	pop=readmatrix(sprintf('%s_pop.txt',str{1}));
	out=readmatrix(sprintf('%s_out.txt',str{1}));
	pop_t=readmatrix(sprintf('%s_t.txt',str{1}));

	if size(out,1)>1
		t=out(:,1);
		P=out(:,2);

		sumStat(iRun,8)=t(end);
		sumStat(iRun,9)=P(end);

		z=floor(linspace(1,length(pop_t),1000));

		% Plots
		subplot(1,3,1)
		Pexp=c*T*exp(-((x-m).^2)/(2*s^2))./((d+s*c*sqrt(2*pi))*x);
		plot(x,pop([1 end],:),'-','LineWidth',2);
		legend({'Initial','Final'},'Location','north','Orientation','Horizontal','Fontsize',12);
		xlabel('Trait value','Fontsize',15);
		ylabel('Trait density','Fontsize',15);

		subplot(1,3,2)
		plot(t,P,'-','LineWidth',2);
		xlabel('Time','Fontsize',15);
		ylabel('Population','Fontsize',15);
		strEqL=sprintf('Final value is %.4f',P(end,1));
		text(t(end,1)/8,(min(P)+max(P))/2,strEqL,'Fontsize',10);

		strBox=sprintf('c=%.2f \t d=%.2f \t K=%.2f \t s=%.2f \t m=%.2f \t T=%.2f',c,d,K,s,m,T);
		set(ann,'String',strBox,'Fontsize',10);
		
		% Mode and max
		subplot(1,3,3)
		pks=findpeaks(pop(end,:),x);
		if ~isempty(pks)
			[pks sumStat(iRun,10)]=findpeaks(pop(end,:),x,'NPeaks',1);
			findpeaks(pop(end,:),x);
		else
			plot(x,pop(end,:),'-');
		end
		tmp=find(pop(end,:)<1e-2,1);
		if ~isempty(tmp)
			sumStat(iRun,11)=x(tmp);
		end
		myTxtFmt(xlabel('Body size'),10,0);
		myTxtFmt(ylabel('Density'),10,0);
		myTxtFmt(title(sprintf('%f \t %f',sumStat(iRun,10),sumStat(iRun,11))),10,0);
		print(f,str{1},'-dpng');

	else
		fprintf('%s is too short\n',str{1});
	end

	waitbar(iRun/runs,wSweep);
end

fName=sprintf('summary_stats_%s.csv',id);
writematrix(sumStat,fName);

close(wSweep);
cd('../../');
