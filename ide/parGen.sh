#!/bin/bash

# Input batch ID
if [ $# -ne 1 ]
then
	echo Give all inputs
	exit 1
fi

dir="./output/$1"

if [ ! -d ${dir} ]
then
	mkdir ${dir}
else
	echo Directory exists. Backup and clear
	exit 2
fi

# Create full factorial list of parameter files based on the following ranges
c=1
d=0.2
K=1
s=0.75
m=(1.5 1.6 1.7 1.8 1.9 2)
T=(1 2 3)

n1=${#c[@]}
n2=${#d[@]}
n3=${#K[@]}
n4=${#s[@]}
n5=${#m[@]}
n6=${#T[@]}

for i1 in $(seq 0 $((n1-1)))
do
	for i2 in $(seq 0 $((n2-1)))
	do
		for i3 in $(seq 0 $((n3-1)))
		do
			for i4 in $(seq 0 $((n4-1)))
			do
				for i5 in $(seq 0 $((n5-1)))
				do
					for i6 in $(seq 0 $((n6-1)))
					do
						f=$(printf "run%03d.txt" $((i1+i2*n1+i3*n1*n2+i4*n1*n2*n3+i5*n1*n2*n3*n4+i6*n1*n2*n3*n4*n5)))
						echo -e "\"Model parameters\" \t \"\" \t \"\"" > $f
						echo -e "c \t\t\t ${c[i1]} \t \"Space clearance rate\"" >> $f
						echo -e "d \t\t\t ${d[i2]} \t \"Death rate\"" >> $f
						echo -e "K \t\t\t ${K[i3]} \t \"Carrying capacity analog\"" >> $f
						echo -e "s \t\t\t ${s[i4]} \t \"Range of stabilizing selection\"" >> $f
						echo -e "m \t\t\t ${m[i5]} \t \"Optimal body size\"" >> $f
						echo -e "T \t\t\t ${T[i6]} \t \"Total space\"" >> $f
						echo -e "\n\"Methods parameters\" \t \"\" \t \"\"" >> $f
						echo -e "xMin \t\t\t 0.1 \t \"Minimum size\"" >> $f
						echo -e "xMax \t\t\t 4 \t \"Maximum size\"" >> $f
						echo -e "dx \t\t\t 1e-2 \t \"Bin size\"" >> $f
						echo -e "maxIter  \t\t 1e6 \t \"Total iterations\"" >> $f
						echo -e "dt \t\t\t 0.05 \t \"Initial step size\"" >> $f
						echo -e "dtMin \t\t\t 1e-4 \t \"Minimum time step\"" >> $f
						echo -e "dtMax \t\t\t 1e-1 \t \"Maximum time step\"" >> $f
						echo -e "popMin \t\t\t 1e-6 \t \"Minimum population size\"" >> $f
						echo -e "popMax \t\t\t 1e6 \t \"Maximum population size\"" >> $f
						echo -e "T \t\t\t 2e2 \t \"Total time\"" >> $f
						echo -e "saveI \t\t\t 1e4 \t \"Number of iterations between consecutive saves\"" >> $f
					done
				done
			done
		done
	done
done

mv run*.txt ${dir}

ls ${dir} > sweep.txt
mv sweep.txt ${dir}

echo Generated parameter files at ${dir}
echo Last file is $f
exit 0
