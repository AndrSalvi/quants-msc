* Tutorial 9
*Panel Data Analysis

clear all

use Panel101.dta
xtset country year // tel stata what is our time variable and panel variable
xtline y // time series by country
xtline y, overlay


** Let's now generate a descriptive statistics table. 

*ssc install outreg2
outreg2 using x.doc, replace sum(log) keep(y x1 x2 x3 opinion) eqkeep(N mean sd min max)

*Linear Regression
regress y x1
* As you might have noticed, this is expressed in scientific notation. 
* A bit ugly in a table! In order to fix it we need to divide it by - say - 1000
* replace x1 = x1/1000 // in this case is does not make much of a difference
** scientific notation simply means number * 10^ number after e

* Let's generate a table for this:

outreg2 using myreg.doc, replace ctitle(Model 1)

** If you want to compare multiple models:
reg y x1 x2, robust
outreg2 using myreg.doc, append ctitle(Model 2)

*** Problem is: variables names are often scarcely informative. Let's solve this issue 
* by using labels

reg y x1, robust
outreg2 using myreg.doc, replace ctitle(Model 1) label
reg y x1 x2, robust
outreg2 using myreg.doc, append ctitle(Model 2) label

** You can do the same for a logistic regression!

*logistic y_bin x1 ,coef // this gives ln(odds)
logistic y_bin x1
outreg2 using myreg.doc, replace ctitle(Model 1) label
logistic y_bin x1 x2
outreg2 using myreg.doc, append ctitle(Model 2) label
logistic y_bin x1 x2 x3
outreg2 using myreg.doc, append ctitle(Model 3) label

** By default it does not report the Pseudo R Square and the -2LL, consider including it!


*Fixed Effects using least squares & dummy variables
xi: regress y x1 i.country

*Fixed Effects PanelData model (same as dummy variables)
xtreg y x1, fe
outreg2 using myreg.doc, append ctitle(Fixed Effects) label addtext(Country FE, YES)


** Let's say we want to add this to our old table.

*Random Effects
*The rationale behind random effects model is that, unlike the fixed effects model,
*the variation across entities is assumed to be random and uncorrelated with the
*predictor or independent variables included in the model:
xtreg y x1, re

*Random effects assume that the entity’s error term is not correlated with the
*predictors which allows for time-invariant variables to play a role as explanatory variables

*Fixed or Random Effects? Hausman Test

*To decide between fixed or random effects you can run a Hausman test where the
*null hypothesis is that the preferred model is random effects vs. the alternative the
*fixed effects (see Green, 2008, chapter 9). It basically tests whether the unique
*errors (ui) are correlated with the regressors, the null hypothesis is they are not.


xtreg y x1, fe
estimates store fixed
xtreg y x1, re
estimates store random
hausman fixed random

// If prob>chi2 is < 0.05 (i.e. significant) use fixed effects

*Do we need to insert time fixed effect, i.e. are we assuming that some shock might affect the DV?
xtreg y x1 i.year, fe
testparm i.year
** The Prob>F is > 0.05, so we
**failed to reject the null that the
**coefficients for all years are jointly
**equal to zero, therefore no time fixedeffects are needed in this case. 


*Heteroskedasticity? Simply use robust standard errors, i.e. add  -robust- at the end of regression command
*N.B.: SAME FOR OLS REGRESSION, ALWAYS USE ROBUST AT THE END (for further details have a look at the TroubleShooting file).
* Reminder:
*The assumption of independent and identically distributed error terms with 
* an expected value of zero and a constant variance sigma square



