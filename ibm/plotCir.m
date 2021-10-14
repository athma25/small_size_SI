function plotCir(ax,z,r)
    
	th=0:pi/100:2*pi;
	x=r*cos(th)+z(1);
	y=r*sin(th)+z(2);
	plot(x,y,'-k');

end
