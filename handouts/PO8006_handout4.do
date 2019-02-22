* Handout 4
* Chapter 7 of the STATA COMPANION
* We use inferential statistics to try to infer from the sample data we have some information about the population. 
* Therefore we want to be “reasonably sure” about our inference.  
* In a nutshell, this is the basic reasoning behind chi-square tests and t-tests, and more generally why we care about the so called "statistical significance"
* Let's start some practical excercises with the nes2012 dataset.


clear all
cd "C:\Users\Andrea\Dropbox\GitProjects\quants-msc\data
use nes2012

* We will now try to deal with survey data and apply some probability weights to them.
* As indicated in the book, the basic syntax to do so is: svyset [pw=probability_weightvar].
* We are essentially telling STATA that we are using survey data.
* In our case: 
svyset [pw=nesw]

* The first thing you will want to do is to produce a crosstab. We know how to do that
* but the "survey" version is slightly different.
* svy: tabulate dep_var indep_var, col percent count pearson 
* col stands for column percentages
* percentages instead of proportions
* count is cell counts
* pearson is Pearsons chi-square statistic
* In our case we will be using 2 variables from nes:
* envjob_3 and dem_educ3. Ordinal level variables that represent the following:
* envjob_3: extent to which the respondent think that "we should regulate business to
* protect the enviroment and create jobs" or "have no regulation, because it will not work
* and will cost jobs". Respondents are classified as pro-enviroment, middle position and pro-jobs.
* dem_educ3: is an ordinal variable that represents the education level. 
* Consider the following hypothesis: " In a comparison of individuals, higher educated people will have
* a stronger pro-enviromental attitudes than those having lower levels of education"
* Let's try to test this!

svy: tab envjob_3 dem_educ3, col percent count pearson

* Let's see what we can get from this table (discussed in class, see page 115 of the
* stata companion). 

* Important concept: Chi Squared approach, Null-Hypothesis.
* Look at the totals and compare them with the other columns. If the null-hyp were true
* they would be very similar - with some differences due to random errors in the sampling process.
* In this case, this scenario seems likely if we look at the percentages.
* Let's have a further look at the output.
* chi2 would be 0 if the null were true.
* P-value: interpret the chi-square stat results. is it larger or smaller than 0.05?
* In this case is quite larger! That means that, if the null is correct, the pattern observed here
* would occurr by chance more 5 times out of 100: which is simply not enough for some good inference!
* By installing another package, we can further our analysis resorting to "Somers' d" which gives
* us some info about the strenght and the direction of the relationship.

* Let's install the required package:
ssc install somersd 

* the general syntax for this is: somersd IV DV [pw=probability_weigthvar]
* In our case: 
somersd dem_educ3 envjob_3 [pw=nesw]

* The absolute value of Somer's d tells us about the improved probabilty of  
* correctly predicting the values of the DV, if we know values of the IV 
*(PRE interpretation – Proportional Reduction in Error).
* It ranges from -1 to 1.
* The sign tells us about direction of relationship btwn IV and DV.
* In short: we have a coefficient of roughly -0.03 with an absolute value of 0.03.
* The absolute value - or "magnitude" - tells us something about our ability to predict values
* of the DV based on the knowledge of the IV.
* From the book: "Compared with how well we can predict individual's enviromental opinions without
* knowing their levels of education, knowledge of education level improves our prediction by 3 percent.
* I strongly suggest to have a look at the summary provided on page 117 on what's the intepretation of p-values


*** Controlled analysis: 
* Let's test another hyp. 
* In a comparison of individuals, liberals will be more supportive of gay rights than conservatives.
* DV: gay_rights3
* IV: lib_con3.
* We will use also a control variable: dem_educ3. Why? Because education might also affect attitudes towards
* gay rights. 
* We will want to have 3 ordinal-by-ordinal cross tabulations: a cross-tab that for each value of educ level
* shows us the relationship between our DV and IV. 

svy: tab gay_rights3 libcon3 if dem_educ3==1, col per
svy: tab gay_rights3 libcon3 if dem_educ3==2, col per
svy: tab gay_rights3 libcon3 if dem_educ3==3, col per

** Does ideology play a role then? Yes! Why so? All of the p-values are smaller than 0.05.
** All the proposed relationships significantly differs form the null-hypothesis. 
* Let's have a look the Somer's d: 
* with bysort we can obtain the test statistic for each level of education with a single command.
bysort dem_educ3: somersd libcon3 gay_rights3 if dem_educ3 !=. [pw=nesw]

* Remember that we do not want missing values 
* of the CV (!= stands for different, in most statistical softwares).
* Again, the sign is negative. 
* From the book: At each education level, as the values of libcon3 increase from
* Lib to Cons, gay_rights3 declines from High to Low. 
* Negative signs are consistent with the hypothesis. 
* The magnitudes (again in absolute value) are around .28, .38 and .52
* As education increases, the relationship gets stronger. How strong though? 
* "The predictive leverage of the IV equals to (value). 

*** Nominal level variables
** the procedure is pretty much the same but we will use another measure instead of Somers'd.
** Let's say we want to test the following hyp: 
* "In a comparison of individuals, blacks are more likely than whites to be Democrats."
* We will control for whether the respondent resides in the South of the US or not. 
** Thus, DV: pid_3
** IV: dem_raceeth2 (1 white, 2 black).
** control: south (0 non south, 1 south)
** Let's run the following: 

svy: tab pid_3 dem_raceeth2 if south==0, col per
svy: tab pid_3 dem_raceeth2 if south==1, col per

** What does the chi-square looks like now? 
** We can reject the null in both cases (south/non south).
* Among non-southeners roughly 29 percent of whites are democrats compared with roughly 71% 
* of blacks. South: percentage of blacks who are democrats increases to almost 77%.
* while the percentage of whites who are Democrats drops to 18 percent. 
* How to we assess the strenght of the association though? 
* We resort to the so-called Cramer's V. Unfortunately we have to store the formula
* manually. 

dis "Cramer's V =" sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1))))

** Let's generate our tables: 

svy: tab pid_3 dem_raceeth2 if south==0, col percent
dis "Cramer's V =" sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1))))

svy: tab pid_3 dem_raceeth2 if south==1, col percent
dis "Cramer's V =" sqrt(e(cun_Pear)/(e(N)*min((e(r)-1),(e(c)-1))))

** Cramer's V varies between 0 (weak relationship) and 1 (strong relatioship). 

*** Non Weighted data and Tabulate
* Luckily, we are done with weights! 
* For data like States, Countries etc we don't really need them and we can use our 
* plain vanilla tabulate command:
* tabulate dep_var indep_var, col chi2 V
* Let's test analyse the relationship between a threefold variable about religiosity 
* and regions. Regions is nominal so we need the Cramer's V. 

clear all
use states
tab Religiosity3 region, col nokey chi2 V

** The chi square is significant, thus we can reject the null hypothesis. What about the Cramer's V?


*** Exercises: Chapter 7, Ex 1
* A: decrease / increase
* B: higher / lower
* C: positive / negative
* D

use states 
tab Abort_rank3 cook_index3, col chi2
tab Gun_rank3 cook_index3, col chi2
somersd cook_index3 Abort_rank3 Gun_rank3

*E.  we can improve our prediction by 69.8 percent by knowing cook_index3

*F. then random sampling error will produce the observed data 0 percent of the time/reject 
* the null hypothesis
 
*G.  Correct. The data fit pedantic pontificator’s hypotheses. More-Democratic states 
*are less likely to have restrictive abortion laws, and are more likely to have restrictive gun laws,
* than are more-Republican states.  


*** Exercises: Chapter 7, Ex 2

* A. In a comparison of individuals, women will be more likely than men to think that abortion should 
*be allowed.
* In a comparison of individuals, women and men will be equally likely to think that women 
* should play non-traditional roles.

* B. 
clear all
use gss2012
svyset [pw=gssw]

svy: tab femrole2 sex, col per
svy: tab abhlth sex, col per

** 85.50  /  87.73 / 1.33 / .3545 / .033
** 44.60 / 62.36 / 39.98 / 0.000 / .178 

* C.  pedantic pontificator’s hypothesis about the femrole2-sex relationship is not supported by the
* analysis. under the assumption that the null hypothesis is correct, 
* the abhlth-sex relationship could have occurred by chance more frequently than 5 times out of 100.
* a higher percentage of females than males think that women belong in nontraditional roles.

* D. random sampling error will produce the observed data 0 percent of the time.
