function chk=checkLoc(N,l,r,x,pi,y)
	chk=NaN;
	% Check boundary
	if sqrt(y(1)^2+y(2)^2)>l-r(pi+1)
		return;
	end

	% Check individuals
	for i=1:N
		if ~isnan(x(i,1)) && sqrt((y(1)-x(i,2))^2+(y(2)-x(i,3))^2)<r(pi+1)+r(x(i,1)+1)
			return;
		end
	end

	chk=1;

end
