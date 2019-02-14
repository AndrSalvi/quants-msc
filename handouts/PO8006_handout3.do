*** Handout 3
**** Crosstabs  
* Rule of thumbs for good crosstabs:
* 1. Remember that the DV always go on the rows while the IV on the columns
* 2. Calculate the % on the IV column and compare those. 

clear all
cd "C:\Users\Andrea\Dropbox\GitProjects\quants-msc\data

use nes2012
** Let's use xtile to rework incgroup_prepost into a new variable

xtile income3 = incgroup_prepost [aw=nesw], nquantiles(3)
** Have a look at page 42 for more info.
** Let's not assign some label to the new var

label define income3_label 1 "Low" 2 "Mid" 3 "High"
label values income3 income3_label

tab income3 [aw=nesw]

*** 

tab pid_3 income3 [aw= nesw], col

** A bit hard to read. How do we solve that?
** Try 

tab pid_3 income3 [aw=nesw], col nofreq nokey

** nofreq suppresses frequencies while "nokey" suppresses space consuming keyboxes
** What is this table telling us?

* If you use LaTeX, the following code does the same but provides you with
* a ready-to-use TeX code

ssc install latab
latab  pid_3 income3 [aw=nesw], col

**** Bivariate Mean Comparison
*** This is useful for ordinal vars and interval ratios. 
*** Let's make an example based on a categorical IV and an interval DV
*** Instead of comparing percentages we are going to compare MEANS of the DV
*** across the categories of the IV. Let's take attitude towards obama DV and
*** partisanship (IV)

tab pid_x [aw=nesw], sum(Obama_therm)

*** The output is a bit verbose. Let's fix it:

tab pid_x [aw=nesw], sum(Obama_therm) nost nofreq noobs

*** A note on decimals. Try:

format Obama_therm %9.4f 
* 9 is the width (9 is usually fine)
*  4 is the number of decimal digits. Try differnt combinations of that. 
* As discussed in the book, mean comparison is usually graphed with boxplots or
* bar charts. 
* Box plots: 

graph box Obama_therm [aweight = nesw], over(pid_x)

** What does this show? if uncertain see page 58 of the Stata Companion
** Let's make our boxplot fancier:

#delimit ;
graph box Obama_therm [aw= nesw], over(pid_x)
bar(1, fcolor(blue)) // fill color of bars
graphregion(fcolor(white)) // white in the graphregion
ytitle("Obama Rating")
ytitle(, size(medsmall))
title("Obama Ratings, by Party Id", size(medlarge))
note("Sources: 2012 ANES"); 

#delimit cr

**** let's try with a barplot

graph bar (mean) Obama_therm [aw= nesw], over(pid_x)

*** Fancier: 

#delimit ;
graph bar (mean) Obama_therm [aw= nesw], over(pid_x)
bar(1, fcolor(gs12))
graphregion(fcolor(white))
ytitle("Obama Rating")
ytitle(, size(medsmall))
title("Obama Ratings, by Party Id", size(medlarge))
note("Sources: 2012 ANES"); 

#delimit cr

**** Bar Charts for two categorical variables
** Let's start again from the code we had earlier.

tab pid_3 income3 [aw=nesw], col nofreq nokey

**** We will want a bar chart that shows on the y axies the percentage of R
**** who are democrats. Cat of income in the x axis
**** We create a dummy variable for each category of pid_3

tab pid_3 [aw= nesw], gen(piddum)
tab income3 [aw= nesw], sum(piddum1) nost nofreq noobs
*** The mean of an dummy variable is equal to the proportion of cases coded 1 

replace piddum1=piddum1*100

*** note on replace, see what happens running gen piddum1=piddum1*100
*** Let's try to graph this: 

#delimit ;
graph bar (mean) piddum1 [aweight = nesw], over(income3)
bar(1, fcolor(blue))
	graphregion(fcolor(white))
	ytitle("Percent Democratic")
	ytitle(, size(medsmall))
	title("Percent Democratic by Income", size(medlarge))
	note("Source: 2012 ANES");
	

#delimit cr

save tutorial3_1.dta

***  Strip Charts
use states, clear 

tab region, sum(union10)
scatter union10 region

** Fancier version

# delimit ;
scatter union10 region, 
 xlabel(, valuelabel)
 graphregion(fcolor(white))
 title("Unionization, by Region", 
       size(medlarge))
 note(Source: "States Dataset")

 jitter(8)

 msize(medlarge)
 msymbol(circle)

 mfcolor(red)
 mlcolor(black);

#delimit cr


*** Exercises
** Ex 2 Chapter 4

use nes2012, clear

*First hyp
tab gay_marry relig_attend3[aw=nesw], col nofreq nokey
* Second 
tab gay_marry gender[aw=nesw], col nofreq nokey
*third
tab gay_marry libcon3[aw=nesw], col nofreq nokey

*B. support Hypothesis 1. The “yes” percentages decline steeply across 
* the values of religious attendance, 
* from 56.91 among low attenders to 18.84 among high attenders.  
 
*C. support Hypothesis 2. Females (43.70 percent) are about five percentage-points more likely 
* to favor gay marriage than are males (38.17 percent).  
 
*D. support Hypothesis 3. Over two-thirds of liberals support gay marriage (67.34 percent), 
*compared with 43.51 percent of moderates and 21.94 percent of conservatives.

*E.

tab gay_marry [aw=nesw], gen(gaydum)
replace gaydum2=gaydum2*100

graph bar (mean) gaydum2 [aweight = nesw], over(relig_attend3)

** Ex 3 Chapter 4

use nes2012, clear
tab pres_vote12 econ_ecpast [aw=nesw], col nofreq nokey

* B. Yes, the data are consistent with the hypothesis. Over 90 percent of respondents 
*who thought that the economy had improved voted for Obama, a percentage that declined 
*to 53.31 percent among those who thought that economic conditions had not changed, 
*and only 18.96 percent among those who thought that the economy had worsened.
 
*C. Loss aversion does not help explain the results. Obama still received 18.96 percent 
*of the vote among those who said the economy was worse, compared with Romney’s 9.81 percent 
*among those who thought the economy had improved. If the rational god of vengeance was stronger 
*than the rational god of reward, then Obama’s vote among the “Worse” respondents should have 
*been lower than Romney’s vote among the “Better” respondents. [Also, Romney’s vote among the 
*“Worse” respondents was lower than Obama’s vote among the “Better” respondents.
