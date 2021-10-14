function sweep_summary_disp(id,rep)

close all

%sprintf('../output/%s/summary_%s_%d.csv',id,rep)
dat=csvread(sprintf('./output/%s/summary_%s_%d.csv',id,id,rep));

r2n=length(squeeze(unique(dat(:,10))));
d1n=length(squeeze(unique(dat(:,6))));
d2n=length(squeeze(unique(dat(:,7))));

b1=squeeze(unique(dat(:,2)));
b2=squeeze(unique(dat(:,3)));
r1=squeeze(unique(dat(:,4)));
r2=squeeze(unique(dat(:,5)));

z=NaN(r2n,d1n,d2n);

for i1=1:r2n
	for i2=1:d1n
		for i3=1:d2n
			j=i2+d1n*(i3-1)+d1n*d2n*(i1-1);
			z(i1,i2,i3)=dat(j,17)/(dat(j,17)+dat(j,18));
		end
	end
end

x=unique(dat(:,6))*ones(1,d2n);
y=ones(d1n,1)*unique(dat(:,7))';

u1=squeeze(z(1,:,:));
u2=squeeze(z(2,:,:));
u3=squeeze(z(3,:,:));
u4=squeeze(z(4,:,:));

f=figure('Position',[460 620 1600 350]);
subplot(1,4,1);
hold 'on';
p1=pcolor(x,y,u1);
p1.EdgeColor='none';
m=(r2/r1)*b2^2/b1^2;
plot(x(:,1),m*x(:,1),'-k')
xlim([7 14]);
ylim([3 8]);
xlabel('1/d_1');
ylabel('1/d_2');
title('\sigma_2=1');
hold 'off'

subplot(1,4,2);
hold 'on';
p2=pcolor(x,y,u2);
p2.EdgeColor='none';
plot(x(:,1),m*x(:,1),'-k')
xlim([7 14]);
ylim([3 8]);
xlabel('1/d_1');
title('\sigma_2=2');
hold 'off'

subplot(1,4,3);
hold 'on';
p3=pcolor(x,y,u3);
p3.EdgeColor='none';
plot(x(:,1),m*x(:,1),'-k')
xlim([7 14]);
ylim([3 8]);
xlabel('1/d_1');
title('\sigma=5');
hold 'off'

subplot(1,4,4);
hold 'on';
p4=pcolor(x,y,u4);
p4.EdgeColor='none';
plot(x(:,1),m*x(:,1),'-k')
xlim([7 14]);
ylim([3 8]);
xlabel('1/d_1');
title('\sigma=8');
hold 'off'

c=colorbar('Position',[0.93 0.1 0.015 0.82],'FontSize',12);
c.Label.String='Proportion of type 1 individuals ($\sigma_1=5$)';
c.Label.Interpreter='Latex';

printPdf(f,sprintf('./results/%s',id));
