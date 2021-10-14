function h=plotInd(ax,z,r,i)
    
    if i==0
        c=[0 0.4470 0.7410];
    elseif i==1
        c=[0.8500 0.3250 0.0980];
    else
        error('Value of i should be 0 or 1\n');
    end
	th=0:pi/100:2*pi;
	x=r*cos(th)+z(1);
	y=r*sin(th)+z(2);
	h=fill(ax,x,y,c);

end
