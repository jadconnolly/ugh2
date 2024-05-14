Example run of MC_fit in grid search mode.  G. Helffrich, ELSI/Titech, May 2024.

This is a sample dataset showing how to run MC_fit in grid search mode to find
best-fitting solution model parameters for the Mg(2)SiO(4) - Fe(2)SiO(4) system
from the experiments of Frost (2003).  Though Frost uses his own Murnaghan-based
EOS, thermophysical properties and thermodynamic properties, here I use
Stixrude's (2008) database (documented in Xu et al. (2008) EPSL v.275, 70-79)
because it is conveniently available and gives a good approximation to the
end-member olivine transition pressures at 1400 C.  Consequently, the
calculated phase diagram differs from Frost (2003), though the EOS is arguably
more appropriate for transition zone pressures.

The goal is to determine the solution model parameters for olivine, wadsleyite
and ringwoodite from the experimental results.  Since the experiments are all at
1400 C, there is no point in seeking any T dependence, and for simplicity any
pressure dependence is ignored (Frost reports it is zero except for olivine).
Hence there are 3 parameters to be determined, symmetric Margules coefficients
for each solid solution.

The file olivine-F.imc is the MC_fit input.  It references the file
olivine-F.dat, which, in turn, references stx08ver.dat, solution_model.dat, and
olivine-F_popts.dat.  The target parameters involve the solution models O(fei),
Wad(fei) and Ring(fei), and, so, in solution_model.dat, the W values are zero.
Frost's (2003) experimental results were turned into MC_fit input by digitizing
the data given in Fig. 4 and normalizing all compositions to 1 SiO2 molecule;
hence the uncertainty for SiO2 is zero.  This feature (zero uncertainty) causes
MC_fit to recast any calculated compositions to moles of SiO2 = 1, and hence all
uncertainty is in MgO and FeO analyses.  The bulk composition is faked to lie
midway between the analyzed MgO and FeO values and so has no associated
uncertainty.  MC_fit, in its present form, does nothing with the bulk
composition uncertainties.

Since the T for each experiment is fixed, its uncertainty is 0.  Frost (2003)
suggests P uncertainty is 0.5 GPa.  The scatter of the data, given the Stixrude
EOS, shows that 0.5 GPa is probably an underestimate; some data points are
mutually inconsistent.  The pssect plot annotation file, olivine-pxpts1400.dat,
contains the data points in the format they can be included in a plot. The
file olivine-F_popts.dat contains computational options used by MC_fit and
vertex that affect the EOS used and the P and X resolution.

The first run is a relatively coarse search over the likely set of values.
To make it fast, nunc = 5 0, which causes no extra objective function
evaluations to account for P/T uncertainty.  When the best fit is found,
however, ntry = 5 causes a set of 5 minimizations to be done to find the local
minimum in the grid.

The second minimization is finer around the minimum, this time with nunc = 0 2,
which this time accounts for P/T uncertainty, effectively allowing the data
points to shift up & down in pressure and so lowering the objective function
score.  It is not strictly necessary but shows the difference possible when
P/T uncertainty is accounted for.

The third minimization further subdivides the P/T uncertainty range in search of
a more precise minimum, but also sets nunc = 5 5 to determine the uncertainty
around the minimum values.

To display the minimum values, there are three shell scripts that may be used
to run the PerpleX programs vertex and pssect.  The first one is parsebst-F
which parses the olivine-F.bst file written by MC_fit.  (Another shell
script is parseout-F that parses the olivine-F.out file if more candidate fits
are to be viewed instead of only the best-fitting ones.)  The output is piped
into the final shell script, runmodel-F, which runs vertex and pssect and
annotates the resulting plot with the experimental data.  It writes a series of
plot files to the /tmp directory called, MC_1400_XXXX.ps, where XXXX is the
objective function value of the MC_fit solution; hence smaller values of XXXX
represent better fits.

Sample commands to achieve this would be:

sh parsebst-F < olivine-F.bst | sh runmodel-F 1400  # to plot the best fits

sh parseout-F < olivine-F.out | sh runmodel-F 1400  # to plot all of the fits

runmodel-F is an example of the type of script that you will want to craft for
each MC_fit application.  It contains within it a copy of the olivine-F.dat
vertex input, but modified slightly by the parseout-F output to adapt the P/T
conditions to the dataset being fit.  It also contains in it a copy of
solution_model.dat so that the best-fitting parameter values may be supplied to
vertex.  These changes get made by processing the output from parsebst-F or 
parseout-F and altering the copies of olivine-F.dat and solution_model.dat
based on that input; see use of and reference to shell variables "obj", "ALPHA",
"BETA", and "GAMMA".  They get copied in the files, MC_trial.dat and
MC_solution_model.dat, so will not interfere with a concurrent run of MC_fit.
