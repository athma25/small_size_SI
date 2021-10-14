function sweep_summary(id,rep)

close all

%sprintf('../output/%s/summary_%s_%d.csv',id,rep)
dat=csvread(sprintf('./output/%s/summary_%s_%d.csv',id,id,rep));

r2n=length(squeeze(unique(dat(:,3))));
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
			j=i1+r2n*(i2-1)+r2n*d1n*(i3-1);
			z(i1,i2,i3)=dat(j,17)/(dat(j,17)+dat(j,18));
		end
	end
end

x=unique(dat(:,6))*ones(1,d2n);
y=ones(d1n,1)*unique(dat(:,7))';

u1=squeeze(z(1,:,:));
u2=squeeze(z(2,:,:));
u3=squeeze(z(3,:,:));

f=figure('Position',[460 620 1200 300]);
subplot(1,3,1);
hold 'on';
p1=pcolor(x,y,u1);
p1.EdgeColor='none';
m=(r2/r1)*(b2(1))^2/b1^2;
plot(x(:,1),m*x(:,1),'-k')
xlim([0 7]);
ylim([0 7]);
xlabel('1/d_1');
ylabel('1/d_2');
title('b_2=1.25');
hold 'off'

subplot(1,3,2);
hold 'on';
p2=pcolor(x,y,u2);
p2.EdgeColor='none';
m=(r2/r1)*(b2(2))^2/b1^2;
plot(x(:,1),m*x(:,1),'-k')
xlim([0 7]);
ylim([0 7]);
xlabel('1/d_1');
title('b_2=1.5');
hold 'off'

subplot(1,3,3);
hold 'on';
p3=pcolor(x,y,u3);
p3.EdgeColor='none';
m=(r2/r1)*(b2(3))^2/b1^2;
plot(x(:,1),m*x(:,1),'-k')
xlim([0 7]);
ylim([0 7]);
xlabel('1/d_1');
title('b_2=1.75');
hold 'off'

c=colorbar('Position',[0.93 0.1 0.015 0.82],'FontSize',12);
c.Label.String='Proportion of type 1 individuals ($b_1=1.5$)';
c.Label.Interpreter='Latex';

printPdf(f,sprintf('./results/%s',id));
