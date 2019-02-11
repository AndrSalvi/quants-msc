* Do Handout 2 STATA PO8006 
* First and foremost, let's set up a wd. 
* Create a folder on your desktop called tutorial_2 and then run the following
* after changing the directory path 
* example cd "C:\Users\Andrea\Desktop\tutorial_2"
clear all
cd "C:\Users\Andrea\Desktop\tutorial_2"

* You can do that using the UI as well (File - Change Working Directory).
* place this do file in the new folder. 
* Let's now load the gss2012.dta data. As first step, download the data 
* from the book website or from the tutorial website and place them in the
* folder you created beforehand. To load them:

use gss2012.dta

* Describing variables:
* NOMINAL:
* "zodiac" is a nominal variable. Check the label to see what it describes 
* in order to get a sense of what we are dealing with we can run:

describe zodiac
codebook zodiac

tab zodiac // this returns a frequency table. From here we can spot the mode 
* Notice that you have 3 types of frequencies: Freq (absolute frequencies),
* percent (relative frequenies * 100) and Cum (cumulative percentages)
* Also, checking the percentages we can get a sense of the "dispersion"

tab zodiac, missing
tab zodiac, nolabel
tab zodiac, nolabel missing

* Check these variants out, what do they do?

* ORDINAL
* Same commands but we get some more info. An example could be "attend".

describe attend
codebook attend
tab attend

* A bit more info: Mode, Dispersion but also:
* Median: look at cumulative distribution, at least 50% cases.

* INTERVAL RATIOS

tab educ_yrs
describe educ_yrs
codebook educ_yrs
* Mean: remember positive skewed Mean>Median (and vice versa). Use Median as central
* tendency measure when skewed distribution.
* Avoid using tab if the variable has more than 30 values (verbose and 
* uninformative output. Take the case of "age". 
* When a variable has many values you will want to use: 

sum age

* sum stands for summary. 

sum age, detail // more details and more stats

sum age if colhomo==1 
** this gives you a summary for those obs of age with colhomo = 1

****************
**** Charts! 

* Bar Charts: for nominal and ordinal vars. (Discrete values for every column)
* try: 
hist attend, d percent

* d stands for discrete values, precent stands for percentages
* We can assign labels and other properties to the x-axis and the y axis.
* Check these out:

hist zodiac, d
hist zodiac, d percent
hist zodiac, d percent xlabel(1(1)12)
hist zodiac, d percent xlabel(1(1)12, valuelabel) // bring the actual signs in
hist zodiac, d percent xlabel(1(1)12, valuelabel angle(forty_five))
hist zodiac, d percent xlabel(1(1)12, valuelabel angle(forty_five) labsize(huge))


**** Interval Ratios. 
*** For these, we use histograms. Examples:

hist size, percent

hist age, percent
hist age, percent xlabel(20(5)89)

*** Listing and sorting

sort size // sort the units of analysis (people in this cae) by a variable.
sort age
gsort age //
gsort -age // What does this mean? Test it out and then call for a list (below)

* You can do that for multiple variables

sort size age
* With the following we would get a list of our ordered vars. Quite verbose
* list size 
* list size age
* Try this instead

list size age in 5 
list size age in 1/5 // try to change "5" to 10 and then to 15, what happens?

* What is the difference between "in 5" and in "in 1/5"?
* Some other alternatives

list age in 56/59
list age in 1970/1974


***** Transforming and generating variables

tab fepresch // let's start from tabbing our variable
* Let's recode it as follows, the command is quite intuitive

recode fepresch (1/2= 1 "Agree")(3/4=2 "Disagree")(.=.), gen(fepresch_binary)
* the last bit gen(varname) creates a new variable and store the changes we 
* asked for. Let's now label this new variable

label var fepresch_binary "Binary Preschool kids suffer if mother works"


* Let's try with another example in an alternative form. What does this do?


gen age_three = recode(age,40,80,100)
label var age_three "Age Categorical" 
label define age_label 40 "Young" 80 "Middle-Aged" 100 "Old" // clearer now?
label values age_three age_label // much more readable!
tab age_three // let's see what we did

* other examples 

gen age_in_months = age*12 // a simple operation
gen age_sq = age^2



