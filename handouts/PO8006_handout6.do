*** HT6 - Correlation and Linear regression
*** Handbook Chapter 8

** Correlation and regression are extremely useful
** to analyze 2+ interval-level variables. 

*Correlation between two variables
*Remeber that correlation does not
*tell you anything about causation.

*We can have positive (max 1) or negative (-1) or 
*no correlation (0). That is represented by Pearson's r. 
* Not a Proportional reduction in error (PRE) measure. 

*We usually look at correlation
*in the beginning of our analysis.
*i.e., is there any relationship
*between the variables that we want
*to study.
* general code:

* cor Var1 Var2 Var3 Varn
*Note that the order of the variables is not important for the sake of the "index"


*Pearson's correlation coefficient

*We define the directory
cd "C:\Users\Andrea\Dropbox\GitProjects\quants-msc\data"

*We open the states dataset:
use states 

*We want to explain variation in the
*percentage of women in legislatures (womleg_2011

codebook womleg_2011

*Have a look at the variable
summarize womleg_2011

* Let's try to calculate its correlation with Relig_high 
* that represents the percentage of highly religious.

cor womleg_2011 Relig_high

*It's quite convenient to add other variables using the same command. 
* Despite the fact that we have more than two variables the index express
* the correlation for each pair. 
* let's add BA_or_more (percentage of college graduate). 
cor womleg_2011 Relig_high BA_or_more
*we observe negative corr between
*womleg and relig and positive corr
*between womleg and education

*FIRST: BIVARIATE REGRESSION
* Regression analysis produces "regression coefficiens" that estimates
* the effect of an independent variable on the DV. 
* It also produces a PRE measure of association: the so called R Squared. 
* NB the DV must be an interval ration while the IVs can be of any variety. 
* Use regression to reveal the true nature of the relationship between 2 or more variables. Remember that you are 
* always testing a null hypothesis: no relationship between 
* the two or more variables.

*Now we want to understand which is
*the cause and which is the effect
*therefore we use linear regression estimating the following regression line:
* y  = b0 + b1 * x + error
* womleg_2011 = b0 + b1 * Religh_high + error
* the general command is regress DV IV. Let's test it!

regress womleg_2011 Relig_high



* How do you interpret the coefficients?
* What about the t-value (rule of thumb: in order to safely reject the null
* we look for a t of |2| or greater. For P- values, as usual, we look for values 
* smaller than 0.05 (same interpretation as usual "highly unlikely to get this values
* by chance).   
* question: what is the predicted value of womleg_2011 if BA_or_more equals
* 55? 
* Now we know b1 and b0. What's the equation we estimate? What do b

* Also for BA_or_more

regress womleg_2011 BA_or_more

*Let's try to use a graph to visualize the linear relationships

#delimit;
twoway(scatter womleg_2011 BA_or_more) // scatterplot per se
(lfit womleg_2011 BA_or_more), //overlay a line
legend(off); // turns off the legend


*MULTIVARIATE LINEAR REGRESSION
* So far we tested our model as a bivariate one. Let's move to multivariate models
* The equation would be: y = beta0 + beta1 * x1 + beta2 * x2 + error


regress womleg_2011 BA_or_more Relig_high

*Using graphs to explain multivariate
*linear relationships. So-called "bubble-plot". 
* the size of each circle represent the second IV (religiosity). 
* the bigger the dot, the more religiosity. 

#delimit;
twoway(scatter womleg_2011 BA_or_more [aw=Relig_high])
(lfit womleg_2011 BA_or_more),
legend (off);


* What does the estimated model looks like? 
* How does the intepretation changes? 

* Presenting a regression table: 
* We use the Outreg package for regression table
ssc install outreg2
outreg2 using myreg.doc, replace ctitle(Model 1)
*Remember that this will overwrite the existing file.
*Just produce a file for the regression and than copy and paste it
* in you paper file.

*If you are using Latex:
ssc install estout, replace

esttab using myreg.tex, se r2 star(+ 0.10 * 0.05 ** 0.01) label

*run it just after the regression. 
*Also here, remember that this will overwrite the file.


*Regression with wieghted data
*we open the gss2012 dataset from 
*command prompt
cor abortion educ femrole [aw=gssw]
reg abortion educ femrole [pw=gssw]

*Here if we want to look at the
*adjusted R-squared (normally used for small samples. 
dis "Adjusted R2 = " e(r2_a)

*** Excercises 

*Chapter 8 Ex 1

* A.
use states
corr demHR11 demstate13 union10

		
*B.  
*increases.  

*C.
*decreases.

*D.
*The relationship is positive /  
*The relationship is stronger than the relationship 
*between the percentage of unionized workers and the percentage 
*of Democratic U.S. representatives and U.S. senators.


*Chapter 8 Ex 3

*A.
*47.585  +     -.1620 * TO_0812.

*B.
use states
reg Obama2012 TO_0812



*The P-value for the regression coefficient on TO_0812 is .808
* and adjusted R-squared is -.0196.

*C.  The conventional wisdom is incorrect because the regression 
*coefficient is not significantly different from 0. 
*It has a P-value of .808, which exceeds the .05 rule. 
*If the null hypothesis is correct, we would obtain these results
* over 80 percent of the time. Do not reject the null hypothesis. 
*Also, R-square is extremely low.


