function output=zn_int(x,dx,N,k)

output=0;
int=zeros(k,1);

int=x.*N;
output=dx*(ksum(int)-int(1,1)/2-int(k,1)/2);
