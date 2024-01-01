1) MF binary, file stinv_mf, Try  40

fnin = 1 tro
       DQF(J/mol) = 3982.98 -.345727 * T_K

W(nin fnin)          14332.4

2) CF binary, file stinv_cf_w_T, Try 885

W(fnin old)          76847.7     -26.0627*T
W(troL oldL oldL)   817439.     -311.194*T
W(oldL troL troL)   203286.     -205.912*T

it's not obvious that the T dependence is necessary for W(fnin old)

3) Ternary several cases considered, files listed below, ultimately I used 
the simplest case described in file stinv_tern_simpler and did not choose 
the maximum likelihood model. Rather I chose a result with a moderately 
low objective function (Try  54, OBJ = 12.97 compares to the global min at
OBJ = 10.54 obtained on Try 847), that a) did not have large excess terms and
b) had negative T dependence on the subregular liquid terms.

The "simpler" model eliminates ternary interaction terms and has no T-dependence 
on W(nin-old). The terms obtained are:

W(nin old)           27268.1
W(ninL oldL oldL)    48810.1     -35.1137*T
W(oldL ninL ninL)    35508.8     -72.3391*T

The stinv_tern_simple model was rejected because the inclusion of the ternary 
interaction term for the liquid does not substantially affect the objective function.

The stinv_tern_w_T and stinv_tern models include ternary interaction terms, yet this
results in only a slight reduction of the obective function (to ca 10). in both cases
the max likelihood models seem implausible because they predict extensive high T liquid
immiscibility. However, stinv_tern does result in a liquid azeotrope as is the case
in the stinv_tern_simple model. Whereas, stinv_tern_w_T inverts the CM solid stability so
that it persists to a high T peritectic.


File stinv_tern_simpler:

Best OBJ so far =  11.7646     obtained on try  65
Final coordinates:  26616.8     0.210473E+07  955.815     0.831483E+07 -5648.80    
12.92
Final coordinates:  27241.7      113537.     -29.8641     -86594.7     -43.8479   
12.967
Final coordinates:  27268.1      48810.1     -35.1137      35508.8     -72.3391

File stinv_tern_simple:

Best OBJ so far =  11.5759     obtained on try  56
Final coordinates:  26576.4      293986.     -124.530     -104539.     -33.5343      578296.      106.985    

File stinv_tern_w_T

Best OBJ so far =  9.98918     obtained on try  30
Final coordinates:  26996.7     -4592.58     -46151.0      86.8418     -479650.      277.063      697436.     -139.964    

File stinv_tern

Best OBJ so far =  9.96142     obtained on try  79
Final coordinates:  26998.8     -4633.99      359203.     -246837.      390518.  