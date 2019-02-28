** HT 5 - Andrea Salvi
**
* We already discuss a bit the role of uncertainty in Social Research.
* It can manifest itself in may ways, confounding variables we need to control
* for or sampling error. Today we are going to focus on the latter.
* We seldom have access to the full population; that's why we work with samples.
* Yet taking a random sample means we are introducing a "random sampling error".
* Thus, when we make our estimations, we deal with "confidence" and "probability". 
* 

*Tests for statistical singificance:

*T-TEST for single sample mean
* What measureme levels are we dealing with? You should be able to guess!

*Firstly we want to define the directory
cd "C:\Users\Andrea\Dropbox\GitProjects\quants-msc\data"

*Open the data with the usual command
use nes2012

*Describe mean of a variable (remember to apply weights!)
mean egal_scale [pw=nesw]
*Here you can find the mean of the variable, the st. error (standard error of 
*the mean or SEM) and
*the 95% confidence interval associated to that statistic. 
* Remember the interpretation of the confidence interval:
* "There is a 95 percent probability that the true mean of the population falls
* in the interval between the sample mean minut 1.96 standard errors and the sample mean plus 
* 1.96 standard erros.
* CI95 = xbar +- t * SEM
* Remember however that we still have that 5% of randomness!
* That is: there is a 0.5 probability that the population mean falls outside the 
* interval we estimated. What is the probability of it falling below that lower boundary?
* What about the upper boundary?
* Question: What is the difference between the standard deviation and the standard
* error of the mean? 
* We can even calculate it "manually" using the formula discussed above.

dis 14.0839 - 1.96*.0898937
dis 14.0839 + 1.96*.0898937

* Display command: https://www.stata.com/manuals13/pdisplay.pdf
* The confidence interval approach is fair, but rather simple
* Using a t-test we can determine the exact probability associated to a claim.
* Let's perform a one sample t-test
* Let's say that our hyptohesis is that mu is equal to 13.5.

lincom [egal_scale] - 13.5

* What STATA does in the background is calculating the difference between the 
* observed sample mean xbar (14.08) and the hypothetical population mean.
* That difference is recorded under "coefficient". The t-statistic is what we use 
* to check significance against a critical value. It is calculated as:
* t = (obs mean - hyp mean)/standard error of the mean
* If the p is smaller than 0.05 we can say that the two values are significantly different
* thus we can reject the null that our hyp value equals mu. 
*  The closer the two means are, the more the numerator in the equation will 
*  bee close to 0 resulting in a low magnitude t. A low magnitude t produce high
*  probability values (thus not statistically different fro each other).
* Conversely the more high t-ratios, the lower p-values we will get. Accordingly
* the two means will be statistically different from each other. 
* In our case we interpret the results as follows: 
* "If the ture pop mean is equal to 13.5, a random sample from the population
* would yield the observed sample mean (14.09) 0.000 percent of the time by chance.
* THUS, it is highly unlikely that the true population mean is equal to 13.5.
* Let's run another example. Look the code below and formulate the hypothesis
* in words:

mean egal_scale [pw=nesw]

lincom [egal_scale] - 14.2

*** Two sample t-test
** What if we want to compare the sample mean of a DV for two groups 
** that differ for an independent variable (Guinness Case)?
** The null hypothesis here is that the two sub-groups are not significantly 
** different from each other. In other words, if the means are different.. well
** that must be because of random sampling error. 
** Let's test the following: 
** "H0: there is no real difference between men and women in the population with 
* regards to egal_scale". 
* "HA/H1: Women are more egalitarian than men". 
* Let's have a look at the "mean" command with the "over" option

mean egal_scale [pw=nesw], over(female)

*Here we are measuring the mean
*of egalitarian scale for male and female and we are obtaining the two conf. inter.
*we can see that they do not overlap: that suggests that we should reject H0.
* Is that enough? Kind of, but let's still go for a t-test:

lincom [egal_scale]Male - [egal_scale]Female

** What this is doing is subtracting the female mean from the male mean and 
** then evaluate the difference. The mean difference reported here is roughly 
** -.75 with a very low p-value. 
** Thus, we reject the null! What is the substantive interpretation of that?

** What is our IV has more than two values? Remember the var pid_3?
** That's how we deal with that:
mean egal_scale [pw=nesw], over(pid_3)
*Here we are calculating the mean for egalitarian scale for Repub,Democr and Ind
*and the 95% conf.interv. 
* The mean egal decline as we move from dem, ind and rep as you can observe.
* Also, the confidence intervals do not overlap. We expect very low p-values.

lincom [egal_scale]Dem - [egal_scale]Ind
** Same interpretation as above! Notice the magnitude of the t-value.

* Other things we can do:
* Say that we want to compare means of sub-population defined by the difference
* on two or more variables. We explore ealitarian beliefs among 4 groups:
* white males, white females, black males and black female. We use the following:

mean egal_scale [pw=nesw], over(black female)

*Analyzing gender gap within white people
lincom[egal_scale]_subpop_1 - [egal_scale]_subpop_2

*Analyzing gender gap within black people
lincom[egal_scale]_subpop_3 - [egal_scale]_subpop_4

** What can we conclude? 















