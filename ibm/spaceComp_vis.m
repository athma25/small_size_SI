function spaceComp_vis(id,run,rep,new)

close all

% Initial check
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

%% Initialization
% Model parameters
l=str2num(par{6});	% Radius of the space with finite non-periodic boundary
r=[str2num(par{11}) str2num(par{18})];	% Radius of individuals ~ b in ODE

b=[str2num(par{23}) str2num(par{32})];	% 1/Birth rate (Exponential clock) ~ 1/c in ODE
d=[str2num(par{37}) str2num(par{45})];	% 1/Death rate (Exponential clock) ~ 1/d in ODE

disp=str2num(par{50});		% 0: uniform dispersal; 1: 2D (not yet truncated) uncorrelated Gaussian centred at the parent
sd=[str2num(par{56}) str2num(par{66})];% Std. deviation of the Gaussian dispersal kernel

% Simulation parameters
T=str2num(par{87});		% Total time
maxI=str2num(par{91});		% Total iterations

%parAnn=sprintf('Total radius=%.2f \n\n Radius(1)=%.2f \n Radius(2)=%.2f \n\n <Birth time>(1)=%.2f \n <Birth time>(2)=%.2f \n\n <Death time>(1)=%.2f \n <Death time>(2)=%.2f \n disp=%d \n \\sigma(1)=%.2f \n \\sigma(2)=%.2f',l,r(1),r(2),b(1),b(2),d(1),d(2),disp,sd(1),sd(2));

% File names
seedf=sprintf('./output/%s/seeds/seed%04d_%04d.mat',id,run,rep);
outf=sprintf('./output/%s/output%04d_%04d.txt',id,run,rep);
vidf=sprintf('./output/%s/space_sim%04d_%04d',id,run,rep);

% State variables	(Can optimize for space complexity here)
% First index is 0/1 for small/large; Second and third is position; 
% Birth clock; Death clock
N=ceil(l^2/r(1)^2);					% Maximum number of individuals possible
x=NaN(N,5);

% Temp
xi=NaN;				% Index for next born individual; NaN if space is filled
pi=NaN;				% 0/1 Parent type
y=NaN(1,2);		% Location of offspring (after dispersal)

% Seeding
if new==1
	rng('shuffle','twister');
	seed=rng;
	save(seedf,'-struct','seed');
else
	seed=load(seedf);
	rng(seed);
end

% Visualization initiation
fig=figure('Position',[500 450 1120 420]);
subplot(1,2,1);
ax1=gca;
hold(ax1,'on');
plotCir(ax1,[0 0],l);
title(ax1,'Space competition simulation','Fontsize',15);
%annotation('textbox',[0.01 0.1 0.095 0.8],'String',parAnn,'Fontsize',10);

subplot(1,2,2);
ax2=gca;
xlabel(ax2,'Time','FontSize',15);
ylabel(ax2,'Population','Fontsize',15);

% Output
t=0;
fn=fopen(outf,'w');

% Initial condition
n=[str2num(par{71}) str2num(par{78})];
x(1:n(1),1)=0;
x(n(1)+1:sum(n),1)=1;
i=1;
failLoc=0;
while i<=sum(n)		% No hard termination
	[y(1) y(2)]=randLoc(l,0,[0 0],0);
	pi=uint8(i>n(1));
	if ~isnan(checkLoc(N,l,r,x(:,[1 2 3]),pi,y))
		x(i,[2 3])=y;
		x(i,[4 5])=exprnd([b(pi+1) d(pi+1)]);
		pl(i)=plotInd(ax1,x(i,[2 3]),r(pi+1),pi);
		i=i+1;
		failLoc=0;
	end
	failLoc=failLoc+1;
	if failLoc>1e2
		error('Body sizes too large for initiation');
	end
end
xi=sum(n)+1;
fprintf(fn,'%.12f\t %d\t %d\n',t,n(1),n(2));

%Visualization
pl1=animatedline(ax2,0,n(1),'Color',[0 0.4470 0.7410]);
pl2=animatedline(ax2,0,n(2),'Color',[0.8500 0.3250 0.0980]);
legend(ax2,{'Large','Small'},'Orientation','Horizontal','Location','northoutside','Fontsize',15);
vf=VideoWriter(vidf);
open(vf);

%% Simulation
wbar=waitbar(0,'Simulation progress','Position',[590 100 270 60]);

tic
for i=1:maxI
	[tnxt j]=min(x(:,[4 5]),[],'all','linear');
	[j1 j2]=ind2sub([N 2],j);
	pi=x(j1,1);
	if j2==1	% Birth
		x(j1,4)=tnxt+exprnd(b(pi+1));
		[y(1) y(2)]=randLoc(l,disp,x(j1,[2 3]),sd);
		if ~isnan(xi)
			x(xi,1)=pi*checkLoc(N,l,r,x(:,[1 2 3]),pi,y);
			if ~isnan(x(xi,1))	% Checking if offspring survived
				n(pi+1)=n(pi+1)+1;
				x(xi,[2 3])=y;
				x(xi,[4 5])=tnxt+exprnd([b(pi+1) d(pi+1)]);
				pl(xi)=plotInd(ax1,x(xi,[2 3]),r(pi+1),pi);
				xi=find(isnan(x(:,1)),1);
				if isempty(xi)
					xi=NaN;
				end
			end
		end
	else	% Death
		x(j1,:)=NaN(1,5);
		n(pi+1)=n(pi+1)-1;
		delete(pl(j1));
		xi=j1;
	end
	t=tnxt;
	fprintf(fn,'%.12f\t %d\t %d\n',t,n(1),n(2));
%	fprintf('%d\t %f\t %d\t %d\t %d\t %d\t %d\t %1.4f\t %1.4f\t %.12f\n',i,t,n(1),n(2),pi,j1,j2,y(1),y(2),x(j1,3+j2));
	addpoints(pl1,t,n(1));
	addpoints(pl2,t,n(2));
	drawnow;
%	pause
	frame=getframe(fig);
	writeVideo(vf,frame);
	if n(1)+n(2)==0
		fprintf('Population is extinct\n');
		break;
	end
	if t>T
		fprintf('Maximum time reached\n');
		break;
	end
	waitbar(max(i/maxI,t/T),wbar);
end
toc

hold(ax1,'off');
close(vf);
close(wbar);
fclose(fn);
