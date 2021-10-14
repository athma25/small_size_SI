function s=ksum(v)

s=0;
c=0;
for i=1:length(v)
	y=v(i)-c;
	t=s+y;
	c=(t-s)-y;
	s=t;
end
