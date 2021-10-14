function [y1 y2]=randLoc(l,disp,x,sd)
	if disp==0
		z1=l^2*rand(1,1);
		z2=2*pi*rand(1,1);
		y1=sqrt(z1)*cos(z2);
		y2=sqrt(z1)*sin(z2);
	elseif disp==1
		y1=x(1)+sd(1)*randn(1,1);
		y2=x(2)+sd(2)*randn(1,1);
	else
		y1=NaN;
		y2=NaN;
		error('disp should be 0 or 1\n');
	end

end
