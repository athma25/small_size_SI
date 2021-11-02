function out=spaceComp_rep(l,r,b,d,disp,sd,T,maxI,N,seedf,outf,n0)

% Simulates a single repetition
% Outputs [i t n(1) n(2)]

out=[0 0 NaN NaN NaN NaN];

%% Seeding
rng('shuffle','twister');
seed=rng;
save(seedf,'-struct','seed');

%% Temp
xi=NaN;				% Index for next born individual; NaN if space is filled
pi=NaN;				% 0/1 Parent type
y=NaN(1,2);		% Location of offspring (after dispersal)
% State variables	(Can optimize for space complexity here)
% First index is 0/1 for small/large; Second and third is position; 
% Birth clock; Death clock
x=NaN(N,5);
n=n0;					% Initial populations
last_it=0;		% Counter for averaging population towards the end of the time series

%% Output
t=0;
%fn=fopen(outf,'w');

%% Initial condition
x(1:n(1),1)=0;
x(n(1)+1:sum(n),1)=1;
i=1;
failLoc=0;
while i<=sum(n)
	[y(1) y(2)]=randLoc(l,0,[0 0],0);
	pi=uint8(i>n(1));
	if ~isnan(checkLoc(N,l,r,x(:,[1 2 3]),pi,y))
		x(i,[2 3])=y;
		x(i,[4 5])=exprnd([b(pi+1) d(pi+1)]);
		i=i+1;
		failLoc=0;
	end
	failLoc=failLoc+1;
	if failLoc>1e2
		error('Body sizes too large for initiation');
	end
end
out(1,[3 4])=[0 0];
xi=sum(n)+1;
%fprintf(fn,'%.12f\t %d\t %d\n',t,n(1),n(2));

%% Simulation
for i=1:maxI
	[mx mi]=min(x(:,[4 5]));
	[tnxt j2]=min(mx);
	j1=mi(j2);
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
				xi=find(isnan(x(:,1)),1);
				if isempty(xi)
					xi=NaN;
				end
			end
		end
	else	% Death
		n(pi+1)=n(pi+1)-1;
		if n(pi+1)==0
			out(1,[5 6])=[pi tnxt];
		end
		x(j1,:)=NaN(1,5);
		xi=j1;
	end
	t=tnxt;
%	if mod(i,1e5)==0 || i>(maxI-1e3) || t>(T-10)
%		fprintf(fn,'%.12f\t %d\t %d\n',t,n(1),n(2));
%	end
	if n(1)+n(2)==0
		fprintf('Population is extinct\n');
		break;
	end
	if i>(maxI-1e2) || t>(T-1)
		out(1,3)=out(1,3)+n(1);
		out(1,4)=out(1,4)+n(2);
		last_it=last_it+1;
	end
	if t>T
		break;
	end
end

out(1,[1 2])=[i t];
out(1,[3 4])=out(1,[3 4])/last_it;
%fclose(fn);

end
