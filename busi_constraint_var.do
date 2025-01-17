*There are discrepancies in measuring constraints in wave2005 and wave2007, although these waves share somewhat similar constraints. Particularly, in wave 2005, business constraints from q137b_01 to q137b_21: 20 constraints are ranked in order of importance from 1 to 10 or lower; q137b_21 refers to no constraint. Wave 2007, however, only lists most, second most and third most important constraints - variables q133a2_1 q133a2_2 q133a2_3, respectively. 

*Our aim is to create 15 constraint dummies (constr1-constr15) which refer to a range of constraints regardless of order of importance. Thus, to be consistent, in wave2005, such newly-created constraint dummies refer to most, second most and third most important constraints only.   

**======================================================================**
**==================       Wave 2005         ===========================**
**======================================================================**
use sme2005_distributionOK.dta, clear 
sort q1

*================1st step: Each constraint from the list of dummies q137b_15 to q137b_20 is in form of a dummy. Group the list as "Other constraints" by using the first variable of the list (i.e., q137b_15) or replacing it with remaining variables in the list if they take the value of 1, and then drop these remaing variables thereafter. 

foreach var of varlist q137b_16-q137b_20{  //q137b_21 refers to no constraint so not used
	replace q137b_15=`var' if `var'<.
}
drop q137b_16 q137b_17 q137b_18 q137b_19 q137b_20

*================2nd step: Rename q137b_01 to q137b_1. This step is specific to q137b_01-q137b_09 only
foreach var of varlist q137b_01-q137b_09{
	replace `var'=. if `var'>3
	local newvar = substr("`var'", 1, length("`var'")-2) + substr("`var'", -1, 1)
	rename `var' `newvar'
}

*================3rd step: Transform q137b_1 to constr1 (so on and so forth) to be consistent with other waves
forv q=1/15{    
	foreach var of varlist q137b_`q'{
		rename q137b_`q' constr`q'
		replace constr`q'=. if constr`q'>3  // newly-created constraint dummies  refer to most, second most and third most important constraints only.   
		tab constr`q'
	}
}


**======================================================================**
**==================       Wave 2007         ===========================**
**======================================================================**
use sme2007_distributionOK.dta, clear 
sort q1
recode q133 (1=1) (2=0), g(constraint) //dummy=1 if firms are constrained, 0 otherwise

*================1st step: Creat dummies constraint1*,2* and 3* correspond to names of constraints within each q133a2_1, q133a2_2 and q133a2_3.
forv i=1/3 {
	replace q133a2_`i'=0 if q133a2_`i'==98
	tab q133a2_`i', g(constraint`i')   //constraint1* (* from 1 to 16) correspond to q113a2_1; constraint2* for q113a2_2, and constraint3* for q113a2_3. 
}
*Note: After 1st step, constr11, constr21, or constr31 take value of 1 if q133a2_1 q133a2_2 q133a2_3 take value of 0 (i.e., no constraint). So in next step, we start from constr*2 (i.e., constr12, constr22 and constr32).  

*================2nd step: Creat dummies constr2-constr16 to get rid of order of importance of constraints.  
forvalues q=2/16{   
	gen constr`q'=.
	forvalues i=1/3{
	replace constr`q'=`i' if constraint`i'`q'>0
	}
}

*================3rd step: Transform constr2-constr16 to constr1-constr15, respectively to be consistent with other waves
local constr2-constr16
forv q=2/16{     //transform constr2 to constr1 --> q-1 
	foreach var of varlist constr`q'{
		local e=`q'-1
		rename constr`q' constra`e'
		recode constra`e'(1=3)(2=2)(3=1),gen(constr`e')
		tab constr`e'	
	}
}












