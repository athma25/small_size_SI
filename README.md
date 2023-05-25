# small_size_SI
MATLAB codes to simulate and numerically solve the models in the manuscript "Smaller is better".

## ibm
### Subroutines required to simulate the spatially explicit stochastic model
* *checkLoc.m* returns 1 if an offspring of type *pi* at location *y* does not overlap with any of the *N* individuals with type and spatial locations given by the matrix *x*, and stays within the disk of size *l* centered at the origin.
* *plotCir.m* plots a circle of radius *r* on the axis *ax* centered at *z*.
* *plotInd.m* plots an individual which is a shaded disk of radius and colour determined its type *i* centered at *z* on the axis *ax*.
* *randLoc.m* returns a random point in the disk of radius *l* uniformly or using a normal distribution with mean *x* and standard deviation *sd* when *disp* is 0 or 1 respectively.

### Instruction to run simulations
* Create an *output* directory in the folder with the codes.
* Run *parGen.sh* to generate parameter files in a subdirectory of *output*. It also creates subdirectories for to organize parameter files, output files and seeds to initiate pseudo random number generation.
* Run *spaceComp_sweep.m* to run simulations of each parameter combination in a sweep by invoking *spaceComp_run.m*, which in turn invokes *spaceComp_rep.m* turn simulate individual repeatitions.
* Run *spaceComp_vis.m* to visualize a single repeatition.

## ide
### Subroutines required to numerically solve the integro differential model for body size distribution evolution
* *ksum.m* calculates the sum of all the elements in vector *v* using Kahan summation method.
* *zn_int.m* calculates the total space occupied by the population.

### Instruction to run code
* Create an *output* directory in the folder with the codes.
* Run *parGen.sh* to generate parameter files in a subdirectoy of *output*.
* Run *ide_sweep.m* to numerically solve the model for all the parameter combinations generated earlier.
* Run *ide_plot.m* to visualize the numerical solutions.

## Other notes
* .gitignore file lets you ignore everything under the output subdirectories to save space on the repo
* *printPdf.m* and *myTxtFmt.m* are custom MATLAB scripts to print plot as PDF and change font size and interpreter
