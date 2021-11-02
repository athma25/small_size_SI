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
	mkdir ${dir}/parFiles
	mkdir ${dir}/seeds
	mkdir ${dir}/data
else
	echo Directory exists. Backup and clear
	exit 2
fi

cd ${dir}/parFiles

# Create full factorial list of parameter files based on the following ranges
l=20
r1=(0.5 2)
r2=1
b1=0.5
b2=0.5
d1=6
d2=3
sd1=5
sd2=5

n1=${#l[@]}
n2=${#r1[@]}
n3=${#r2[@]}
n4=${#b1[@]}
n5=${#b2[@]}
n6=${#d1[@]}
n7=${#d2[@]}
n8=${#sd1[@]}
n9=${#sd2[@]}

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
						for i7 in $(seq 0 $((n7-1)))
						do
							for i8 in $(seq 0 $((n8-1)))
							do
								for i9 in $(seq 0 $((n9-1)))
								do
									f=$(printf "run%04d.txt" $((i1+i2*n1+i3*n1*n2+i4*n1*n2*n3+i5*n1*n2*n3*n4+i6*n1*n2*n3*n4*n5+i7*n1*n2*n3*n4*n5*n6+i8*n1*n2*n3*n4*n5*n6*n7+i9*n1*n2*n3*n4*n5*n6*n7*n8)))
									echo -e "\"Model parameters\" \t \"\" \t \"\"" > $f
									echo -e "l \t\t\t ${l[i1]} \t \"Radius of space\"" >> $f
									echo -e "r1 \t\t\t ${r1[i2]} \t \"Radius of the first species\"" >> $f
									echo -e "r2 \t\t\t ${r2[i3]} \t \" \t second \t \"" >> $f
									echo -e "b1 \t\t\t ${b1[i4]} \t \"Mean time to reproduce for first species\"" >> $f
									echo -e "b2 \t\t\t ${b2[i5]} \t \" \t second \t \"" >> $f
									echo -e "d1 \t\t\t ${d1[i6]} \t \"Mean life span for first species\"" >> $f
									echo -e "d2 \t\t\t ${d2[i7]} \t \" \t second \t \"" >> $f
									echo -e "disp \t\t\t 0 \t \" Type of dispersal\"" >> $f
									echo -e "sd1 \t\t\t ${sd1[i8]} \t \"Standard deviation for dispersal of the first species\"" >> $f
									echo -e "sd2 \t\t\t ${sd2[i9]} \t \" \t second \t \"" >> $f
									echo -e "n1 \t\t\t 10 \t \"Initial population of first species\"" >> $f
									echo -e "n2 \t\t\t 10 \t \" \t second \t \"" >> $f
									echo -e "\n\"Methods parameters\" \t \"\" \t \"\"" >> $f
									echo -e "T  \t\t\t 1e1 \t \"Total time\"" >> $f
									echo -e "maxIter \t\t 1e6 \t \"Total iterations\"" >> $f
								done
							done
						done
					done
				done
			done
		done
	done
done

ls ./ > sweep.txt
cd ../../../

echo Generated parameter files at ${dir}
echo Last file is $f
exit 0
