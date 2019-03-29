** Tutorial 8: Logistic Regression, Ch 10 

clear all
cd "C:\Users\Andrea\Dropbox\GitProjects\quants-msc\data"

* Logistic regression is used to analyze the relationship between a binary DV
* and a bunch of interval ratio IVs.
* Think about the following example. DV: "people voted in an election". It will 
* take values of 1 (voted) and 0 (not voted). IV: years of education (measured from
* 0 to 20). Hyp: Positive relation. More formally: "As years of education
* increase, the probability of voting should increase as well". Notice that here
* we are dealing with probabilities! Each additional year of education will - 
* most likely - increase the probability of voting. 
* OLS does not fit this kind of setup. One of the problems is that OLS assumes 
* linearity. In this context we will assume a linear relationship between Education
* and the logged odds of voting. 
* The relationship will look like this: logged odds(voting) = a + b(years of ed)

* a: estimates the dep variable (log odds) when the indep = 0
* b: b will estimate the change in the logged odds of voting for each 1-year increase
* in education. 
* It's slightly more tricky to intepret as coefficients are expressed in terms of 
* logged odds of the DV. We often translate them in something else!

* In terms of code we have different options: logit and logistic. The former
* will express the coefficients as logged odds of the DV. Logistic instead
* allow us to extract the Odds Ratio (but if we specify that, we can have
* the log odds as well). 

* basic command for logit: logit DV IV [pw= probability_weightvar]
* basic command for logit: logistic DV IV [pw= probability_weightvar]

use gss2012

tab educ_yrs
tab educ_yrs voted081

logit voted081 educ_yrs [pw=gssw]


* The model we estimated is: logged odds(voted081) = - 2.07 + .226(educ_yrs)
* Constant: for people with no education (x=0) the logged odds of voting is equal to
* -2.07. As for the coefficient of education, it tells us that the logged odds of voting
* increases by .226 for each 1 unit increase (in this case 1 year) in education.
* In short, as expected the likelihood of voting increases as education increases.
* For significance we have a z statistic (instead of a t) from which p-values are derived.
* For those who feel a bit adventorous, have a look Maximum Likelihood (the way we 
* estimate logit) and Wald tests.

logistic voted081 educ_yrs [pw=gssw]

* We now have odds ratio. In this case for education it's roughly 1.25. 
* How that came to be? e^.226 
* This translates the log(odds) to an odds ratio.
* When OR are less then 1, it means that the odds decrease as the IV increase (negative rel)
* When OR = 1 no relationship
* When OR > 1 the odds of the DV increase as the IV increases (positive rel)


* An odds ratio of 1.25 means that respondents at a given level of education
* are 1.25 times more likely to have voted than those with a lower level of ed.
* Ex. people with 10 years of education are 1.25 times more likley to have voted 
* as compared with pople with 9 years of education. 

*We can use the odds ratio to obtain the "percentage change in the odds" for 
* each unit change in the IV. subtract 1 from the OR and divide by 100. In this case
* (1.25 - 1)*100=25. It means that each 1-year increment in education increases
* the odds of voting by 25%.  (If you have a negative relationship (so OR < 1) you 
* are still going to get a "positive percentage" but the interpretation changes 
* (n percent decrease). 

* Trick: "The divide by four rule"
* If for some reason we use "logit" (thus having coeffiencts expressed in ln(odds)
* we can use the so called "divide by four rule" to quickly estimate the substantive effect
* in terms of probability. 

* It consists in dividing the coeffient by four. In our case: .226 /4 = 0.05
* In terms of PROBABILITIES: when education increases by 1, there is a 5% increase 
* in the probability of voting. 

* Well, we can say that THE UPPER BOUND OF THE PREDICTIVE DIFFERENCE is roughly 0.05,
* which means that - for each unitary increase (increase of 1 unit) in x (education) there 
* is roughly a 5% increase in the probability that the person went to vote.
*(y = 1, so event happening). The substantive interpretation should be quite clear accordingly. 
* Remember that this is a quick approximation of the substantive effect. 
* It really tells us the size of the effect around the midpoint of the logistic curve (0.5) 
*where the logistic curve is steeper (alfa + beta x = 0). One more time,
* this express the effect in terms of probabilities, while the other one expresses it 
* in terms of odds. 

* What does Iteration 0 ... 4 mean? 
* Iteration 0 is a model that does not use the IV. Log-likelihood estimation. 
* Then, MLE bring in the IV and reiterate the analysis several time until it
* converge. In our case Iteration 4 is where the predictive ability of MLE is maximized.
* We can use this measure to evaluate how well a model performs by comparing it
* to the log-likelihood of "baseline model". 

* Also, we have the Pseudo R Square. It's slightly different from our OLS R Square
* and cannot be interpreted as proportion of explained variation. 
* There are several measures but STATa uses the McFadden one:

* (initial log-likelihood - final loglikelihood)/(initial log likelihood)
* in our case .0716. 
* It communicates the strenght of association. 

**** Multiple IV. 

* logged odds (voting) = a + b1 (educ_yrs) + b2 (age)

* age is coded from 18 to 89.
* Hyp: older people are more likely to vote than younger people. 

logistic voted081 educ_yrs age [pw=gssw] ,coef // this gives ln(odds)
logistic voted081 educ_yrs age [pw=gssw]

* The pseudo R square is better than the model with just education.
* How does our age + education model perform when compared to a model with no predictors?
* In this case we look at the Wald chi2 and at its significance (p value = 0.000).
* It is significant, thus we can reject the null hypothesis (h0: adding age and educ does nothing)
* For such reason, including age and education significantly enhance the predictive performance of the model. 
