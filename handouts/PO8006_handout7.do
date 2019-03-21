* Tutorial 7 
*Define directory
cd "C:\Users\Andrea\Dropbox\GitProjects\quants-msc\data"

*Dummy Variables
*coded 0 and 1
*Typical example Gender
* When you have nominal or ordinal IVs, you can transform them into dummies.
*The constant tells you the value of the omitted category, while the regression
* coefficient tells you the value of the difference between the omitted category 
*and the other category. If you want the value of the other category 
*just sum up constant and regression coefficient.
* the command looks like "xi: reg DV i.IV

*Open dataset 
use "nes2012"

tabulate gender

* Let's now estimate a model that looks like this:
* Let's say that gender Gender is coded as 1 for female and 0 for male. 
* Obama thermometer = a + b(female)
* The idea is to check if women will give Obama higher feeling thermometer 
* ratings than men. 

* In our case gender is coded as 1 for males and 2 for females: can't be used 
* in a regression analysis! You could use tab and then generate to amend it
* An easy way around is using "xi" prefix and then "i" prefix for the variable 
* you need to transforms (males are automatically assigned to 0 because they have
* a lower value in the orginal coding). 
*Run regression with dummy 
xi: reg Obama_therm i.gender [pw=nesw]

* The contant/intercept a will tell us the average rating among men. Why?
* Hint: try to plug a x = 0 in the equation of a line!
* Males are the "omitted" category. The mean value on the dependent variable is 
* portayed by the constant.
* b will tell us the average change in the dep variable 
* for a unit of change in the independent variable. Notice that a unit change
* in this context means the "difference between men (0) and women (coded 1). 
* In short, it reflects the mean difference. between male and females.
* The estimated value of the DV among females can be obtained by summing up a + b.
* Obama = 53.44 + 5.78 * _Igender_2
* Just to reiterate: as we saw for linear regresson the constant
* tells you the estimated value of the DV when the IV is 0. Thus: the mean therm
* rating of Obama for male is 53.44. 
* the coeff on _Igender_2 tells us the mean change in the DV for each unit change
* in the IV. When the dummy goes up from 0 to 1 (male to female) Obama rating goes
* up about 5.8 degrees. 
* Using this two values (a,b) we can estimate the "mean rating for females". Calculate that.
* We can observe a difference between the two mean values. Is that by chance?
* Not really, as the p-value is smaller than 0.05. 
* What does the R squared tells us? What problem does our model suffer from?
 

*Run regression with dummy for categorical variables
*with more than 2 categories
* You can transform into dummies also variables that have more than 2 categories. 
* Remember: K categories require K-1 dummies.

tabulate pid_3
*Sometimes you want to choose what is the omitted category.
* Run: char varname [omit]# where # stands for the code of 
* the category that you want to be omitted.
*Here, want Ind to be the omitted category.
char pid_3 [omit] 2

*Run the new regression: 
xi: reg Obama_therm i.gender i.pid_3 [pw=nesw]

* as you can see stata created a dummy for gender again.
* This time we also have two dummies on party_id. We know that the omitted
* one is "Ind". 1 is democrat in the original dataset. 3 is republican in the 
* original dataset. 
* Thus:
* Obama = 52.02 + 2.90 * _Igender_2 + 29.49 _Ipid_3_1 - 27.22 * _Ipid_3_3
* or: Obama = 52.02 + 2.90 * Female + 29.49 * Democrat - 27.22 * Republican

* First step: the constant. This time it represents the mean obama rating
* for males who are independent (all the dummies are set to 0). 
* Coefficients of the variables: "How much the DV changes when the IV switch to 1"
* Republicans and Democrats are significantly different from indepedents
* Probably they are significantly different from each other given the huge
* diff in coefficients (you can check this using the "test" command. See page 153.)



***Interaction effects
* Mulitple linear regressions assume that the effect of one IV is the same
* for every value of the other IVs. If this is not the case, 
* you need to insert interaction effects in your regression.
* E.g. in our example our regression assumed that the effect of being female
* is the same of all the value of partisanship (both rep, dem and ind females
* are 3 degrees warmer towards obama than their male counterparts).


* Interactions are usually theory driven. For example, let's test the following
* Hip: people who oppose the legalization of marijuana would rate conservatives
* more highly than those who support legalization. 
* If that is correct, the anti-pot group should have an higher average appreciation
* for conservatives. 
* However according to the "polarization theory" (check the book page 154):
* "Political disagreements are stronger among people who are well into public affairs
* than they are among people who lack of the latter.
* Summing all up: among people with lower political knowledge, the mean diff
* in conservative ratings might be more modest, with legalization opponents liking
* conservatives slightly more than legalization supporters. 
* When political knowledge increases we expect to see an increase in the mean difference
* as an effect of polarization (the more you are "into politics" the fiercer the "fight").
 
*Have a look with a breakdown table

tab preknow3 pot_legal3 [aw=nesw], sum(ftgr_cons) nost noobs nofreq

* What can you see from here?
* Let's now run a basic model:

reg ftgr_cons pot_legal3 preknow3
* What do we see here? Interpret the coefficients. 

* The interaction model will look like this:

* cons rating = a + b1 * pot_legal3 + b2 * preknow3 + b3(pot_legal3*preknow3)
* "b3" is key here as it tells us by how much to adjust the effect of "pot_legal3"
* as knowledge increases. The p-value on b3 will test the null hyp that the effect
* of pot_legal3 on the DV is the same for all levels of political knowledge.



*Generating the interaction term
gen interact = pot_legal3*preknow3

*Run regression
reg ftgr_cons pot_legal3 preknow3 interact [pw=nesw]

* ftgr_cons = 49.2 + 4.7 * pot_legal3 - 2.6 * preknow3 + 3.5 * (pot_legal3 * preknow3)

* For low-know respondent (0) we will have that: 
** ftgr_cons = 49.2 + 4.7 * pot_legal3 - 0 + 0 

** the constant estimates the mean of ftgr_cons for those with pot_legal = 0 (as we saw for dummy vars)
** Why? Well:  49.2 + 4.7 * 0 = 49.2
**for low knowledge individuals who take a middle position on the legalization issue: 
* 49.2 + 4.7 * 1 = 53.9
**For those who oppose pot legalization:
* 49.2 + 4.7 * 2 = 58.9

** As you can see while the pot-adverse with low political knowledge average appreciation for cons was 49.2
** it goes up for each degree of "pot_legal3". 

* What about high knowledge?  (preknow =2)
* ftgr_cons = 49.2 + 4.7 * pot_legal3 - 2.6 * preknow3 + 3.5 * (pot_legal3 * preknow3)
** High knowledge legalization supporters (pot_legal = 0): 49.2 + 4.7 * 0 - 2.6 * 2 + (0 * 2) = 44.0
* A bit harsher towards conservatives! 

** now let's see those high knowledge (2) marijuana opponents (2)
*ftgr_cons = 49.2 + 4.7 * pot_legal3 - 2.6 * preknow3 + 3.5 * (pot_legal3 * preknow3)
* 49.2 + 4.7 * 2 - 2.6 * 2 + 3.5 * (2*2)  = 67.4! 


*Graphing interactions
predict ftgr_cons_pred
#delimit ;
twoway 
(lfit ftgr_cons_pred pot_legal3 if preknow3==0)
(lfit ftgr_cons_pred pot_legal3 if preknow3==1)
(lfit ftgr_cons_pred pot_legal3 if preknow3==2);


*** If time allows: 

*Logit regression
*Open dataset
use gss2012, clear

*Run regression
logistic voted081 educ_yrs [pw=gssw]



** 
*Exercise Chapter 9 Ex. 1 Dummy

* Set the wd!
use world

*A.   

* mean difference between countries with the lowest GDP and the highest GDP   b2  

* mean of the dependent variable for the
*highest GDP countries      constant + b2

*mean of the dependent variable for the
*lowest GDP countries                              constant

*mean difference between the lowest
*GDP and the  middle GDP countries                             b1

*B.

xi: reg free_overall i.gdp_cap3

* so free_overall = 52.61 + 5.06 * _Igdp_cap3_2 + 16.93 * _Igdp_cap3_3

*C.
*(Low: 52.61; Middle: 57.67(52.61+5.05); High: 69.54(52.61+16.93)

*D.
*Yes. The regression coefficient, 5.06, has a t-ratio of 3.45 and a P-value of 0.001. So we can infer that middle-GDP countries are significantly higher than low-GDP countries on free_overall.  
 
*E.  
*Yes. The regression coefficient, 16.93, has a t-ratio of 11.44 and a P-value of 0.000. So we can infer that high-GDP countries are significantly higher than low-GDP countries on free_overall.

*F.
*-test _Igdp_cap3_3 ==_Igdp_cap3_2-
*Yes. The test command returns a P-value of 0.000. High-GDP countries have significantly higher values on free_overall than do middle-GDP countries.

*Exercise Chapter 9 Ex. 2 Interaction Effects

*A.
use world
tab democ_regime hi_gdp, sum(gini10) nost noobs nofreq


*B.
*Interaction is occurring. High-GDP non-democracies hahve a 
*higher Gini coefficient (44.09) than do low-GDP non-democracies (40.15). 
*For democracies, the relationship is just the opposite: 
* richer democracies have a lower Gini coefficient (38.09) than do low-GDP democracies (44.46).

*C.

reg gini10 hi_gdp democ_regime rich_democ
*gini10 = 40.15 + 3.94* hi_gdp + 4.31* democ_regime -10.31 * rich_democ.


*D.
*Correct. The mean Gini coefficient for low-GDP dictatorships is captured by the intercept, 40.15.  The coefficient on democ_regime, 4.31, is statistically significant (t = 2.01, P-value =.047), indicating that low-GDP democracies have a significantly higher value on gini10 (i.e., less equitable distribution of wealth) than do low-GDP dictatorships.

*E.
*Correct. The distribution of wealth in rich dictatorships is not significantly different from the distribution of wealth in low-GDP dictatorships: the coefficient on hi_gdp (3.94) is not statistically significant. The large and significant negative coefficient on rich_democ (-10.31) says that high-GDP democracies have a more equitable distribution of wealth than do rich dictatorships

*F.
predict gini10_pred

twoway (lfit gini10_pred hi_gdp if democ_regime==0) (lfit gini10_pred hi_gdp if democ_regime==1)




