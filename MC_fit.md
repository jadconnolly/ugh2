




ciao stefano, if you do the melt model the program makes more sense. 

1) the program is named MC_fit and is defined as a target in any of the makefiles in src.

2) the program works by making NTRY starting guesses for the parameter values, each guess serves as a starting point from which it seeks to minimize an objective function by the melder-neade algorithm. the objective function accounts for observed vs predicted composition, if the prediction includes extraneous phases, and if the observation includes phases that are not predicted.

3) you need to create an input file with build (stinv_mf.dat in the files i sent) that specifies the chemical system, thermodyamic data source, solution models, etc.

4) an auxiliary file (stinv_mf.imc) that specifies a) various algorithmic parameters that you probably don't need to bother with, but if you experiment with them i'd be curious to know what you discover; b) the parameters to be optimized (that you will need to modify, actually pretty much just replace fnin with siderite and nin with magnesite); and c) the experimental data with uncertainties.

details of 4:

a) currently for endmembers the thing inverts for a linearly p-T dependent DQF "correction" to endmember properties. a is the increment of G0, b is the increment on -S0, and c would be the increment on V0 in a cst volume model, in a real phase with P-T dependent V this is an approximation. i'll correct that later so that one increments V0 directly. Anyhow what that means in practice is the thermodynamic data file header must define any pure endmember for which you want to invert properties by a make definition of the original endmember (e.g., in stefan_III.dat, fnin is defined as tro + the DQF, if fnin had really existed i would have renamed it fnin0 and made fnin as fnin = 1 fnin0 + DQF).  

the entry for an endmember consists of the name and a list of the free parameters and there ranges (these are absolute, so if you've specified a non-zero DQF the range must be adjusted to be the min/max around the non-zero values. 

the entry for solution models consist of the solution name (e.g. Nin) followed by an interaction term, the format is slightly different than for stoichiometric phases in that the parameter is identified by an integer index and is followed on the same line by the parameter range. for margules and vanlaar parameter 1 is the constant, parameter 2 is the coefficient on T, and parameter 3 is the coefficient on P; thus

Nin                         
W(nin fnin)                      
parameter 1 -5e4 5e4 
end_list         

specifies a regular binary excess function, if you want to invert for T dependence that'd be modified to   

Nin                         
W(nin fnin)                      
parameter 1 -5e4 5e4   
parameter 2 -5e1 5e1
end_list

Wk(nin fnin) specifies redlich kistler. the i/o's not as smart as it could be, therefore  the endmembers must be listed in the same order as in the solution_model file (i.e., W(fnin nin) will probably cause an error); similarly at present the imc file cannot specify an excess term that is not specified in the solution_model file.

5) stinv_mf.out lists the best model found by each nelder-meade observation and then prints out the computed value of the objective function for each experiment (good for identifying outliers and/or bad thermodyamic input). values of the objective function >1 indicate extraneous or missing phases. the objective function weights extraneous phases by their mass proportion, my idea being that a small amount of an extraneous phase should not be heavily penalized as it's possible the small amounts might not be observed. thus if extraneous phases are present it's possible that the objective function can still have values <1.

6) if the things behaving well NTRY = 100 is more than adequate for 3 parameters. if you want uncertainties, then set NUNC to a positive number and the program will perturb all observed properties within their uncertainties and repeat the inversion NUNC times. the initial best model and each of the subsequent NUNC best models with the standard deviation on each parameter are then printed to stinv_mf.bst. 

7) i've only run two cases, so the diagnostics are not to useful. if you try it and run into problems formatting the *.imc file, send me what you've got and i'll figure out the error with a debugger.

jamie



