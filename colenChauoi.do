clear 
set more off

//3rd Jan2019: Chau chot lay K=physical assets year end; L=full-time workers year end (--> cac bien lay trong Economic Account nhe) 

*1. RENAME
*cd M:\vietnam\2016   // If you download files to your folders, make sure you change this directory path.
use sme2005_distributionOK.dta, clear 
sort q1

keep q1 q5 q6ab q7a q12 q14b_09 q14b_10 q17a  q26d q47a q102k q104a q79b_01 kt3_01 kt3_02 kt3_03 kt3_05 kt3_08 kt3_09 kt3_10 kt3_11 kt3_16 kt3_22 
recode q5 (2 3=1) (1 4=2), gen(q5new) //industrial zone/park = code 1
rename q5new industrialzone
rename q6ab yearstart
rename q7a taxcode //1=Yes, 2= No
rename q12 ownership
rename q14b_09 accessroad
rename q14b_10 accessrail
rename q17a isic
rename q26d owneredu
rename q47a export
rename q102k totalasset
rename q104a totaldebt
rename q79b_01 labourall

rename kt3_01 sales
rename kt3_02 output
rename kt3_03 extraincome
rename kt3_05 directcosts
rename kt3_08 grossprofit
rename kt3_09 depreciation
rename kt3_10 ipaymentpnl
rename kt3_11 tax
rename kt3_16 capital
rename kt3_22 labour

*There are discrepancies in measuring constraints in wave2005 and wave2007, although these waves share somewhat similar constraints. Particularly, in wave 2005, business constraints from q137b_01 to q137b_21: 20 constraints are ranked in order of importance from 1 to 10 or lower; q137b_21 refers to no constraint. Wave 2007, however, only lists most, second most and third most important constraints - variables q133a2_1 q133a2_2 q133a2_3, respectively. 

*Our aim is to create 15 constraint dummies (constr1-constr15) which refer to a range of constraints regardless of order of importance. Thus, to be consistent, in wave2005, such newly-created constraint dummies refer to most, second most and third most important constraints only.   
*Wave 2005:
use sme2005_distributionOK.dta, clear 
sort q1
*1st step: In the next step, each constraint from the list of dummies q137b_15 to q137b_20 is in form of a dummy. I group the list as "Other constraints" by using the first variable of the list (i.e., q137b_15) or replacing it with remaining variables in the list if they take the value of 1, and then drop these remaing variables thereafter. 
foreach var of varlist q137b_16-q137b_20{  //q137b_21 refers to no constraint so not used
	replace q137b_15=`var' if `var'<.
}
drop q137b_16 q137b_17 q137b_18 q137b_19 q137b_20

*2nd step: rename q137b_01 to q137b_1. This step is specific to q137b_01-q137b_09 only
foreach var of varlist q137b_01-q137b_09{
	replace `var'=. if `var'>3
	local newvar = substr("`var'", 1, length("`var'")-2) + substr("`var'", -1, 1)
	rename `var' `newvar'
}

*3rd step: transform q137b_1 to constr1 (so on and so forth) to be consistent with other waves
forv q=1/15{    
	foreach var of varlist q137b_`q'{
		rename q137b_`q' constr`q'
		replace constr`q'=. if constr`q'>3  // newly-created constraint dummies  refer to most, second most and third most important constraints only.   
		tab constr`q'
	}
}


*20077777777777777777777777777777777
use sme2007_distributionOK.dta, clear 
sort q1
recode q133 (1=1) (2=0), g(constraint) //dummy=1 if firms are constrained, 0 otherwise

*1st step: We creat dummies constraint1*,2* and 3* correspond to names of constraints within each q133a2_1, q133a2_2 and q133a2_3.
forv i=1/3 {
	replace q133a2_`i'=0 if q133a2_`i'==98
	tab q133a2_`i', g(constraint`i')   //constraint1* (* from 1 to 16) correspond to q113a2_1; constraint2* for q113a2_2, and constraint3* for q113a2_3. 
}
*Note: After 1st step, constr11, constr21, or constr31 take value of 1 if q133a2_1 q133a2_2 q133a2_3 take value of 0 (i.e., no constraint). So in next step, we start from constr*2 (i.e., constr12, constr22 and constr32).  
*2nd step: We creat dummies constr2-constr16 to get rid of order of importance of constraints.  
forvalues q=2/16{   
	gen constr`q'=.
	forvalues i=1/3{
	replace constr`q'=`i' if constraint`i'`q'>0
	}
}

*3rd step: transform constr2-constr16 to constr1-constr15, respectively to be consistent with other waves
local constr2-constr16
forv q=2/16{     //transform constr2 to constr1 --> q-1 
	foreach var of varlist constr`q'{
		local e=`q'-1
		rename constr`q' constra`e'
		recode constra`e'(1=3)(2=2)(3=1),gen(constr`e')
		tab constr`e'	
	}
} 














keep q1 q3be q5 q6ab q7a q7c q9a q9b q11a q11b q12 q14b_09 q14b_10 q15 q16 q17a q18 q20b_01-q20b_09 q21 q21b2_01-q21b2_11 q26d q26e q26f q27a q36 q45b_1-q45b_7 q48 q49 q72b_9 q74 q75a q79b_01 q79b_05 q79b_07 q79b_09 q80b_01 q80c_01 q80b_02 q80c_02 q80b_07 q80c_07 q80b_08 q80c_08 q80b_10 q80c_10 q80b_15 q80c_15 q102b q102c q102d q102e q102f q102g q102i q104a q102k q103a q103b2_1 q103b2_2 q103b2_3 q105a q107 q108 q112f q112g q126b_1-q126b_5 q126f q128a q128b q127b_1-q127b_5 q130a q130c q130a q131a q134a q135a q136a q140c_04 q140c_05 q140c_06 q140c_09 q140c_19 q141a q141b q141c q57b_01 q57b_02 q57b_04 q57b_05 q57b_09 q6ab q12 q32 q47a q68a q98a q98b q98b1 q98b2 q98b3 q98b4 q98b5 q98b6 q99b_1 q99b_2 q99b_3 q99b_4 q99b_5 q100 q102a q102i q102j q102k q104a q104b q104c q104d q104e q105a q105b q106a q110a q110b q111a q111b q112e q112f q112g q119e q113 q115a q115b q118a q79b_01 q130a q131a q131b2_1 q131b2_2 q131b2_3 q131b2_4 q131b2_5 q134a q134c q135a q135c q136a q136c q137b_01-q137b_21 kt2_01 kt2_02 kt2_02 kt2_03 kt2_04 kt2_05 kt2_06 kt2_07 kt2_09 kt2_10 kt2_11 kt2_16 kt2_20 kt2_21 kt2_22 kt3_01 kt3_02 kt3_03 kt3_04 kt3_05 kt3_06 kt3_07 kt3_08 kt3_09 kt3_10 kt3_11 kt3_16 kt3_20 kt3_22
/*drop if q3be==48 | q14b_10==9
recode q5 (2 3=1) (1 4=2), gen(q5new) //industrial zone/park = code 1
recode q11b (1=1) (2=2) (3=3) (4=4) (5=5)(6=6)(7=7)(81=8), gen(q11bnew)
recode q16 (1=1) (2=2) (3=3) (4=4) (51/54=5), gen(q16new)
recode q18 (1=1) (2=2) (3=3) (4=4) (5 61=5) (6=6) (7=7), gen(q18new)
recode q26e (1=1) (2=2)(3=3)(4 5=4), gen(ownerskill)
recode q26f (1=1) (2=2) (3=3) (4=4) (5=5) (6 61/64=6), gen(ownerpreviousworkstatus)
replace q49=. if q49==98 | q49==99
replace q72b_9=0 if q72b_9==99
recode q75a (1/4 =1) (5=2), gen(q75anew)
gen unskilledlabour=q80b_15+q80c_15
gen lbmanagerno=q80b_01+q80c_01
gen lbprofessionals=q80b_02+q80c_02
gen lbofficeworker=q80b_07+q80c_07
gen lbsalespersonnel=q80b_08+q80c_08
gen lbproductionworker=q80b_10+q80c_10
recode q113 (1=1)(2=2)(3=3)(4=4)(5=5)(6=6)(7 71=7), gen(q113new)
recode q126f (1=1) (2=2) (3=3) (4=4) (5 51=5), gen(contactmostimp)
replace q128b=. if q128b==9
recode q130a (1=0)(2=1)(3=2), gen(association)
forv i=1/5 {
	replace q131b2_`i'=. if q131b2_`i'==9
}
gen govassist=0 if q140c_19==1
replace govassist=1 if govassist==.
recode q140c_04 (1/max=1),gen(govtechsupport)
recode q140c_05 (1/max=1), gen(govloans)
recode q140c_06 (1/max=1), gen(govtaxsupport)
recode q140c_09 (1/max=1),gen(govhumantraining)
foreach var of varlist govtechsupport govloans govtaxsupport govhumantraining {
	replace `var'=0 if `var'==.
}

replace q141a=. if q141a==0

drop q80b_15 q80c_15 q16 q18 q26e q26f q113 q126f q140c_19 q80b_01 q80c_01 q80b_02 q80c_02 q80b_07 q80c_07 q80b_08 q80c_08 q80b_10 q80c_10 q140c_04 q140c_05 q140c_06 q140c_09
*/
/*
rename q3be city
rename q5new industrialzone // 1= Industrial zone/park, 2= No
*rename q26a gender
*/
rename q6ab yearstart
rename q7a taxcode //1=Yes, 2= No
*rename q7c registeredbusi
*rename q9a ownertransition
*rename q9b onwertransitionreason
*rename q11a locationchange
*rename q11bnew locationchangereason
rename q12 ownership
rename q14b_09 accessroad
rename q14b_10 accessrail
*rename q15 housefacilityreason
*rename q16new ownland
rename q17a isic
*rename q18new pastexperience
*rename q26d owneredu
rename q27a ownerpastown
*rename q36 supplier
*rename q32 producttool
/*
rename q45b_1 salessnontourist
rename q45b_2 salessnonSOE
rename q45b_3 salessSOE
rename q45b_4 salessgov
rename q45b_5 salesstourist
rename q45b_6 salessexport
rename q45b_7 salessforeignfirm
*/
rename q47a export
/*
rename q48 exportyear
rename q49 exportcustomerno
rename q68a busiservices
rename q72b_9 taxfee
rename q74 sharemanagertime
rename q75anew bribe 
rename q98a investment
rename q98b invcost
rename q98b1 invland
rename q98b2 invbuilding
rename q98b3 invequip
rename q98b4 invRnD 
rename q98b5 invhuman
rename q98b6 invpatents
rename q99b_1 owncapitalpercent
rename q99b_2 borrowfrbank
rename q99b_3 borrowpayi
rename q99b_4 borrowfrfriend
rename q99b_5 borrowwithouti
rename q100 invreason 
rename q102i cashndep
rename q102j outstandcredit
*/
rename q102k totalasset
rename q104a totaldebt
/*
rename q104b debtFST 
rename q104c debtinFST
rename q104d debtFLT
rename q104e debtinFLT
rename q105a ipayment
rename q105b ipay4Fdebt
rename q106a debtfail
rename q110a creditcons
rename q110b Creditconsreason
rename q111a NoloanFST
rename q111b NoloanFLT
rename q112e irateF
rename q112f collateral
rename q112g collateralhow
rename q119e irateInF
rename q113new whichbank
rename q115a NodenialloanFST
rename q115b NodenialloanFLT
rename q118a loaninF
*/

rename q79b_01 labourall
/*
rename q79b_05 labourregular
rename q79b_07 FTlabour
rename q79b_09 labourcasual
rename q107 payables
rename q108 receivables 
rename q103a sellland 
rename q103b2_1 selllandvalue
rename q103b2_2 sellbuildingsvalue
rename q103b2_3 sellequipvalue

rename q131a competition
rename q131b2_2 competefrsoe
rename q131b2_1 competefrnonsoe
rename q131b2_3 competefrforeign
rename q131b2_4 competefrsmuggling
rename q131b2_5 competefrother
rename q134a newproduct
rename q134c newproductsuccess
rename q135a impproduct
rename q135c impproductsuccess
rename q136a newtech
rename q136c newtechsuccess
rename kt2_01 salespreyr
rename kt2_02 outputpreyr

rename kt2_03 extraincomepreyr
rename kt2_09 depreciationpreyr
rename kt2_21 totaldebtpreyr


rename kt2_06 valaddpreyr
rename kt2_04 indirectcostspreyr
rename kt2_05 directcostspreyr
rename kt2_07 wagepreyr
rename kt2_10 ipaymentpnlpreyr
rename kt2_11 taxpreyr
rename kt2_20 finassetpreyr
rename kt3_20 finasset
rename kt2_16 capitalpreyr
rename kt2_22 labourpreyr
*/
rename kt3_01 sales
rename kt3_02 output
rename kt3_03 extraincome
*rename kt3_04 indirectcosts
rename kt3_05 directcosts
*rename kt3_06 valueadded
*rename kt3_07 wage
rename kt3_08 grossprofit
rename kt3_09 depreciation
rename kt3_10 ipaymentpnl
rename kt3_11 tax
rename kt3_16 capital
rename kt3_22 labour

/*
rename q102b lands
rename q102c buildings
rename q102d machines
rename q102e transportequip
rename q102f inventoriesinput
rename q102g inventoriesoutput
rename q57b_01 electricity
rename q57b_02 fuels
rename q57b_04 stationary
rename q57b_05 internet
rename q57b_09 maintenance
*/
/*
rename q126b_1 contactsamesector
rename q126b_2 contactdiffsector
rename q126b_3 contactbank
rename q126b_4 contactpolitics
rename q126b_5 contactothers
rename q128a contactimes
rename q128b contactlastime
rename q127b_1 networksupplier
rename q127b_2 networkcustomer
rename q127b_3 networkdebtor
rename q127b_4 networkcreditor
rename q127b_5 networkwomen
rename q130c associationfee
rename q141a govassistauthority
rename q141b govassistcontacted
rename q141c govassistbribery

gen stockfinance=0
*/
*---- Business Constraints
rename q137b_21 constraintno //How Chau know: as this is only ranked 1, while other constraints do not. 
//This step is that I combine q137b_15-q137b_20 as they have the similar theme of "Other constraint", but I do not know the command so I just manually replace q137b_15 with numbers listed in remaining variables. Poor me!!!  
foreach var of varlist q137b_16-q137b_20{
	replace q137b_15=`var' if `var'<.
	}
drop q137b_16 q137b_17 q137b_18 q137b_19 q137b_20

foreach var of varlist q137b_01-q137b_09{
	local newvar = substr("`var'", 1, length("`var'")-2) + substr("`var'", -1, 1) //line nay hay qua
	rename `var' `newvar'
}
forv q=1/15{     //transform q137b_1 to constr1
	foreach var of varlist q137b_`q'{
		rename q137b_`q' constr`q'
		replace constr`q'=. if constr`q'>3
		tab constr`q'
	}
}
*-- End Business constraints

* --Q21: Any assistance from first establishment
foreach var of varlist q21b2_01-q21b2_11 {
	replace `var'=. if `var'==9 | `var'==0
	tab `var'
     }
gen q21b2_12=. if q21b2_08==. | q21b2_09==. | q21b2_10==. | q21b2_11==.
replace q21b2_12=2 if q21b2_08==2 | q21b2_09==2 | q21b2_10==2 | q21b2_11==2
replace q21b2_12=1 if q21b2_08==1 | q21b2_09==1 | q21b2_10==1 | q21b2_11==1
drop  q21b2_08 q21b2_09 q21b2_10 q21b2_11
rename q21b2_12 q21b2_08
rename q21b2_08 q21b_8

foreach var of varlist q21b2_01-q21b2_07{
	replace `var'=2 if q21==2
	local newvar = substr("`var'", 1, length("`var'")-4) + substr("`var'", -3, 1) + substr("`var'", -1, 1) //line nay hay qua
	rename `var' `newvar'
}
*-- End Q21


gen t=2005
gen CPI = 1
gen CPIpreviousyr=0.928
save 2005.dta,replace
******************************

*LAI NAY
keep q6ab q7a q12 q14b_09 q14b_10 q17a  q26d q47a q102k q104a q79b_01 kt3_01 kt3_02 kt3_03 kt3_05 kt3_08 kt3_09 kt3_10 kt3_11 kt3_16 kt3_22 

rename q6ab yearstart
rename q7a taxcode //1=Yes, 2= No
rename q12 ownership
rename q14b_09 accessroad
rename q14b_10 accessrail
rename q17a isic
rename q26d owneredu
rename q47a export
rename q102k totalasset
rename q104a totaldebt
rename q79b_01 labourall

rename kt3_01 sales
rename kt3_02 output
rename kt3_03 extraincome
rename kt3_05 directcosts
rename kt3_08 grossprofit
rename kt3_09 depreciation
rename kt3_10 ipaymentpnl
rename kt3_11 tax
rename kt3_16 capital
rename kt3_22 labour



********************************************************************************
use sme2007_distributionOK.dta, clear 

sort q1
keep q1 q3be q5 q6a q7a q9a q9b q11a q11b q12 q14a q14c q15 q16 q17a q18 q20b_01-q20b_09 q21b_1-q21b_8 q26d q26e q26f q27a q32 q43b_1-q43b_7 q45 q46 q65 q68b_8 q69 q70 q73b_1 q73b_3 q73b_4 q73b_5 q74b_01 q74b_02 q74b_07 q74b_08 q74b_10 q74b_15 q93aa q93ab q93ac q93ad q93ae q93af q93ba q94 q94a2_1 q94a2_2 q94a2_3 q95 q93c q96 q97 q98a q98b q125 q126a q129 q130 q131 kt3_02 q55b_01 q55b_02 q55b_05 q55b_06 q55b_10 q1 q6a q12 q28 q44 q90 q90a q90aa q90ab q90ac q90ad q90ae q90af q91b_1 q91b_2 q91b_3 q91b_4 q91b_5 q92 q93a q93ba q93bb q93c q95 q95a q95b q95c q95d q96 q96a q101 q101a q102a q102b q105f q105g q105ga q108f q91b_6 q103 q104a q104b q107 q73b_1 q123b_1-q123b_6 q123c_1-q123c_5 q123d_1-q123d_5 q123e_1-q123e_5 q124a q124b q124c q124d q124e q125 q125a q125bb_1 q126a q126aa2_1 q126aa2_2 q126aa2_3 q126aa2_4 q126aa2_5 q129 q129b q130 q130b q131 q131b q132b_01 q133 q133a2_1 q133a2_2 q133a2_3 q134b_1-q134b_6 q134c_1-q134c_6 q134d_1-q134d_6 q134e_1-q134e_6 kt2_01 kt2_02 kt2_03 kt2_04 kt2_05 kt2_06 kt2_07 kt2_10 kt2_11 kt2_12 kt2_17 kt2_21 kt2_22  kt3_01 kt3_02 kt3_03 kt3_04 kt3_05 kt3_06 kt3_07 kt3_09 kt3_10 kt3_11 kt3_12 kt3_17 kt3_21 kt3_23 kt2_17 kt2_23
recode q5 (2 3=1) (1 4=2), gen(q5new) 
recode q11b (1=1) (2=2) (3=3) (4=4) (5=5)(6=6) (8=7)(7 9=8), gen(q11bnew)
recode q26e (1=1) (2=2)(3=3)(4 5=4), gen(ownerskill)
replace q32=. if q32==98
replace q46=. if q46==98 | q46==99
replace q69=. if q69>50
replace q103=. if q103==98
gen contactmostimp=.
forv q=1/5{ 
   replace contactmostimp=`q' if q123c_`q'==1
}
forv q=1/5{ 
   replace q123d_`q'=. if q123d_`q'==0
}
egen avercontactimes=rmean(q123d_1 - q123d_5)
gen contactimes=floor(avercontactimes) 
forv q=1/5{ 
   replace q123e_`q'=. if q123e_`q'==0
}
egen avercontactlastime=rmean(q123e_1 - q123e_5)
recode avercontactlastime (min/1=1)(1/2=2)(2/3=3), gen(contactlasttime)
foreach var of varlist q124a q124b q124c q124d q124e {
    replace `var'=. if q123b_6<`var'
}
recode q125 (1=1)(2=0), gen(q125new)
recode q125a (1=1) (2/max=2), gen(q125anew)
replace q125anew=q125new if q125anew==.
rename q125anew association
replace q126aa2_5=. if q126aa2_5==9
egen govassistmin=rowmin(q134b_1-q134b_6)
recode govassistmin (1=1) (2=0), gen(govassist)
recode q134b_1 (1=1) (2=0), gen(govtaxsupport)
recode q134b_2 (1=1) (2=0), gen(govloans)
recode q134b_3 (1=1) (2=0), gen(govhumantraining)
recode q134b_5 (1=1) (2=0), gen(govtechsupport)
egen q134caver=rmean(q134c_1-q134c_6)
gen govassistauthority=ceil(q134caver)
egen q134daver=rmean(q134d_1-q134d_6)
gen govassistcontacted=1 if q134daver<=1.5
replace govassistcontacted=2 if govassistcontacted==.
egen q134eaver=rmean(q134e_1-q134e_6)
gen govassistbribery=1 if q134eaver<=1.5
replace govassistbribery=2 if govassistbribery==.

drop q123b_6 q123c_1-q123c_5 q123d_1 - q123d_5 q123e_1 - q123e_5 q125 q125a q125new

rename q3be city
*rename q26a gender
rename q5new industrialzone // 1= Industrial zone/park, 2= No
rename q6a yearstart
rename q7a taxcode //1=Yes, 2= No
rename q132b_01 registeredbusi
rename q9a ownertransition
rename q9b onwertransitionreason
rename q11a locationchange
rename q11bnew locationchangereason
rename q12 ownership
rename q14a accessroad
rename q14c accessrail
rename q15 housefacilityreason
rename q16 ownland
rename q17a isic
rename q18 pastexperience
rename q26d owneredu
rename q26f ownerpreviousworkstatus
rename q27a ownerpastown
rename q32 supplier
rename q28 producttool
rename q43b_1 salessnontourist
rename q43b_4 salessnonSOE
rename q43b_5 salessSOE
rename q43b_3 salessgov
rename q43b_2 salesstourist
rename q43b_7 salessexport
rename q43b_6 salessforeignfirm
rename q44 export
rename q45 exportyear
rename q46 exportcustomerno
rename q65 busiservices
rename q68b_8 taxfee
rename q69 sharemanagertime
rename q70 bribe
rename q90 investment
rename q90a invcost
rename q90aa invland
rename q90ab invbuilding
rename q90ac invequip
rename q90ad invRnD 
rename q90ae invhuman
rename q90af invpatents
rename q91b_1 owncapitalpercent
rename q91b_2 borrowfrbank
rename q91b_3 borrowpayi
rename q91b_4 borrowfrfriend
rename q91b_5 borrowwithouti
rename q92 invreason 

rename q93ba cashndep
rename q93bb outstandcredit
rename q93c totalasset
rename q95 totaldebt
rename q95a debtFST 
rename q95b debtinFST
rename q95c debtFLT
rename q95d debtinFLT
rename q96 ipayment
rename q96a ipay4Fdebt
rename q97 debtfail
rename q98a payables
rename q98b receivables 
rename q101 creditcons
rename q101a Creditconsreason
rename q102a NoloanFST
rename q102b NoloanFLT
rename q105f irateF
rename q105g collateral
rename q105ga collateralhow
rename q108f irateInF
rename q91b_6 stockfinance
rename q103 whichbank
rename q104a NodenialloanFST
rename q104b NodenialloanFLT
rename q107 loaninF
rename q94 sellland 
rename q94a2_1 selllandvalue
rename q94a2_2 sellbuildingsvalue
rename q94a2_3 sellequipvalue

rename q126a competition
rename q126aa2_1 competefrsoe
rename q126aa2_2 competefrnonsoe
rename q126aa2_3 competefrforeign
rename q126aa2_4 competefrsmuggling
rename q126aa2_5 competefrother
rename q129 newproduct
rename q129b newproductsuccess
rename q130 impproduct
rename q130b impproductsuccess
rename q131 newtech
rename q131b newtechsuccess
rename kt2_01 salespreyr
rename kt2_02 outputpreyr
rename kt2_03 extraincomepreyr
rename kt2_10 depreciationpreyr
rename kt2_22 totaldebtpreyr

rename kt2_06 valaddpreyr



rename kt2_04 indirectcostspreyr
rename kt2_07 wagepreyr
rename kt2_11 ipaymentpnlpreyr
rename kt2_12 taxpreyr
rename kt2_21 finassetpreyr
rename kt3_21 finasset

rename kt3_01 sales
rename kt3_02 output
rename kt3_03 extraincome
rename kt3_04 indirectcosts
rename kt3_05 directcosts
rename kt3_06 valueadded
rename kt3_07 wage
rename kt3_09 grossprofit
rename kt3_10 depreciation
rename kt3_11 ipaymentpnl
rename kt3_12 tax
rename kt3_17 capital
rename kt3_23 labour
rename kt2_17 capitalpreyr
rename kt2_23 labourpreyr
rename kt2_05 directcostspreyr

rename q73b_1 labourall
rename q73b_3 labourregular
rename q73b_4 FTlabour
rename q73b_5 labourcasual
rename q74b_15 unskilledlabour
rename q74b_01 lbmanagerno
rename q74b_02 lbprofessionals
rename q74b_07 lbofficeworker
rename q74b_08 lbsalespersonnel
rename q74b_10 lbproductionworker
rename q93aa lands
rename q93ab buildings
rename q93ac machines
rename q93ad transportequip
rename q93ae inventoriesinput
rename q93af inventoriesoutput
rename q55b_01 electricity
rename q55b_02 fuels
rename q55b_05 stationary
rename q55b_06 internet
rename q55b_10 maintenance


rename q123b_1 contactsamesector
rename q123b_2 contactdiffsector
rename q123b_3 contactbank
rename q123b_4 contactpolitics
rename q123b_5 contactothers
rename q124a networksupplier
rename q124b networkcustomer
rename q124c networkdebtor
rename q124d networkcreditor
rename q124e networkwomen
rename q125bb_1 associationfee

*--Business constraints
recode q133 (1=1) (2=0), g(constraint)
forv i=1/3 {
	replace q133a2_`i'=0 if q133a2_`i'==98
	tab q133a2_`i', g(constraint`i')
}
/*
forvalues q=2/16{     
   count if constraint1`q'==1
   local mostconstraint`q'=r(N)
   count if constraint2`q'==1
   local 2ndconstraint`q'=r(N)
   count if constraint3`q'==1
   local 3rdconstraint`q'=r(N)
   display "constr`q'score ="
} //With these values, I put them in excel to calculate the Weighted Average and Weighted SD. Chau da tim ra cach k can cho vao excel nua hehehe 
*/
forvalues q=2/16{
	gen constr`q'=.
	forvalues i=1/3{
	replace constr`q'=`i' if constraint`i'`q'>0
	}
}
local constr2-constr16
forv q=2/16{     //transform constr2 to constr1 --> q-1 nhe + Weighted Average Rank + Weighted SD. Chau sieu thong minh
	foreach var of varlist constr`q'{
		local e=`q'-1
		rename constr`q' constra`e'
		recode constra`e'(1=3)(2=2)(3=1),gen(constr`e')
		su constr`e'	
	}
} 
*--End Business constraints
*--Q21: Assistance in the first establishment 
foreach var of varlist q21b_1-q21b_8 {
	replace `var'=. if `var'==9 | `var'==0
	tab `var'
     }
*--End Q21
	 
gen t=2007
gen CPI = 1.163
gen CPIpreviousyr=1.083
save 2007.dta,replace
*********************************************************************************
********************************************************************************
*2. APPEND
use m:\vietnam\2016\2005.dta, clear
drop if q1==.
sort q1
save m:\vietnam\2016\2005a.dta, replace

use m:\vietnam\2016\2007.dta, clear
drop if q1==.
sort q1
save m:\vietnam\2016\2007a.dta, replace


use m:\vietnam\2016\2005a.dta, clear
append using m:\vietnam\2016\2007a.dta
sort q1
save m:\vietnam\2016\2005-07b.dta , replace

********************************************************************************
*3. LABEL

drop q130a //of wave2005
drop q3be q3bee q5 q11b q26c q126 q126a2_1 q126a2_2 q126a2_3 q133 q133a2_1 q133a2_2 q133a2_3  q134b_1-q134e_6 q134caver-q134eaver q128b_1-q128e_6 q128b_1-q128eaver govassistmin
rename q20b_01 firstlackcapital
rename q20b_02 firstlackrawmat
rename q20b_03 firstlackmarketingoutlet
rename q20b_04 firstlackmarketingskill
rename q20b_05 firstlacktechnical
rename q20b_06 firstlackequip
rename q20b_07 firstlackpremises
rename q20b_08 firstlacklicenses
rename q20b_09 firstlackskilledlab
label var firstlackcapital "First time established - Lack of capital"
label var firstlackrawmat "First time established - Lack of raw materials"
label var firstlackmarketingoutlet "First time established - Lack of marketing outlet"
label var firstlackmarketingskill "First time established - Lack of marketing skills"
label var firstlacktechnical "First time established - Lack of technical know-how"
label var firstlackequip "First time established - Lack of equipment"
label var firstlackpremises "First time established - Lack of premises" 
label var firstlacklicenses "First time established - Lack of licenses"
label var firstlackskilledlab "First time established - Lack of skilled labour"

rename q21b_1 firstassistfrgov
rename q21b_2 firstassistfrsobank
rename q21b_3 firstassistfrsoe
rename q21b_4 firstassistfrforeign
rename q21b_5 firstassistfrmassorg
rename q21b_6 firstassistfrprivate
rename q21b_7 firstassistfrrelatives
rename q21b_8 firstassistfrrothers
label var firstassistfrgov "First time established - Assitance from Government"
label var firstassistfrsobank "First time established - Assistance from State-owned Banks"
label var firstassistfrsoe "First time established - Assitance from SOEs"
label var firstassistfrforeign "First time established - Assitance from Foreign banks/firms"
label var firstassistfrmassorg "First time established - Assitance from mass organisation"
label var firstassistfrprivate "First time established - Assitance from private firms/banks"
label var firstassistfrrelatives "First time established - Assitance from relatives"
label var firstassistfrrothers "First time established - Assistance from others"

label var owneredu "Education levels of owners/managers"
label define q222 1 "No education" 2 "Not finished primary" 3 "Finsihed primary" 4 "Finished lower secondary" 5 "Finished upper secondary"
label values owneredu q222
label var ownerskill "Professional levels of owners/managers"
label define q2222 1 "No prof.skill" 2 "Technical certificate/Elementary/vocational edu" 3 "Technical secondary/professional" 4 "College/Uni/Postuni"
label values ownerskill q2222
label var ownerpreviousworkstatus "previous work status of owners/managers"
label define q333 1 "Wage employee in SOEs" 2 "Wage employee in nonSOEs" 3 "Self-employed in manufacturing" 4 "Self-employed in trade/services" 5 "Own or collective farms" 6 "Others" 
label values ownerpreviousworkstatus q333

label var q1 "Firm ID"
label var city "City"
label var yearstart "Year of establishment"
label var labour "Total work force number " 
label var FTlabour "Number of full-time workers" 
label var output "Value of production/manufactured output"

*Cost (1,000VND - Year 2005/11) (1,000,000 - Year 2013)
label var electricity "Cost of electricity"
label var fuels "Cost of liquid/solid fuels and gas"
label var stationary "Cost of stationary and office supplies"
label var internet "Cost of telephone/Internet"
label var maintenance "Cost of maintenance and repairs of plant/equipment and buildings"

*Capital (1,000VND - Year 2005/11) (1,000,000 - Year 2013)
label var capital "Market value of total physical assets "
label var land "Market value of lands"
label var buildings "Market value of buildings"
label var machines "Market value of machines"
label var transportequip "Market value of transport equipment"
label var inventoriesinput "Market value of inventories of materials or input products"
label var inventoriesoutput  "Market value of inventories of finished products"

*Cash and deposits (1,000VND - Year 2005/11) (1,000,000 - Year 2013)
label var cashndep "Cash and deposits "
*Total assets (1,000VND - Year 2005/11) (1,000,000 - Year 2013)
label var totalasset "Total assets "
*Total liabilities last year (1,000VND - Year 2005/11) (1,000,000 - Year 2013)
label var totaldebt "Total liabilities last year "
*Total interest payments last year (1,000VND - Year 2005/11) (1,000,000 - Year 2013)
label var ipayment "Total interest payments last year "
*Government assistant No(0), Yes (~=0)
*Member of one or more business associations? (1: Yes, 2=No)
label var association "Asso: Member of 0,1 or over 2 business associations"
*Firm face competition in the field (
label var competition "Competition Firm face competition in the field"
*Firm introduced new product groups, Yes (1), No (2)
label var newproduct "Firm introduced new product groups"
*Firm improve existing products, Yes (1), No (2)
label var impproduct "Firm improve existing products"
*Firm introduce new technology, Yes (1), No (2)
label var newtech "Firm introduce new technology"

label var yearstart "Year of establishment"
label var city "City"
label var industrialzone "Firms belong to Industrial zone/Park"
label var taxcode "Firms have tax code"
label var registeredbusi "Firms have business registration/ have registered under Business Law"
label var ownland "Firms have CLUR to use land"
label define q9999 1"Own CLUR" 2"Inherit CLUR" 3 "Informal arrange to use land" 4 "Rent/Lease" 5 "Others"
label values ownland q9999
label var pastexperience "Owners work with similar products/services prior to establishing the firm"
label var ownertransition "Any changes in owners since last survey year?"
label var onwertransitionreason "Reason for changes in owners"
label var locationchange "Location of main production facility change"
label var locationchangereason "Reason for change in location"
label var accessroad "Easy access to main road"
label var accessrail "Easy access to rail"

label var ownership "Type of owenership"
*Current technology
*Code: Only hand tools, no machinery (1), Manually operated machinery only (2), Power driven machinery only (3), Both manually and power driven machinery (4)
label var producttool "Current technology "
*Does firm export (in)directly (99 unknown, Yes=1, No=2)
label var export "Export"
*Firm make investment since last survey? (99 unknown, Yes=1, No=2)
label var investment "Firm make investment since last survey"
*Cost of investment
label var invcost "Cost of investment"
*Value of Investment in Land
label var invland "Value of Investment in Land"
*Value of Investment in Buildings
label var invbuilding "Value of Investment in Buildings"
*Value of Investment in Equipment/Machinery
label var invequip "Value of Investment in Equipment/Machinery"
*Value of Investment in R&D 
label var invRnD "Value of Investment in R&D"
*q70ae: Value of Investment in Human capital 
label var invhuman "Value of Investment in Human capital"
*q70af: Value of Investment in Patents 
label var invpatents "Value of Investment in Patents"
*q71a: Percentage of Investments financed by own capital 
label var owncapitalpercent "Percentage of Investments financed by own capital "
*q71b: Percentage of Investments financed by loans from bank/credit institution
label var borrowfrbank " Percentage of Investments financed by bank/credit institution "
*q71c: Percentage of Investments financed by interest from other sources
label var borrowpayi "Percentage of Investments financed by loans from interest from other sources "
*q71d: Percentage of Investments financed by loans from friends and relatives without interest
label var borrowfrfriend "Percentage of Investments financed by loans from friends and relatives without interest"
label var borrowwithouti "Percentage - Lonas from other sources without interest"
*q72: Main purpose of Investment
*Code: Add to capacity (1), Replace old equipment (2), Improve productivity (3), Improve quality of output (4), 
*Produce a new output (5), Safety (6), Environmental requirements (7), Other purpose (8).
label var invreason "Main purpose of Investment "
*q73bb: Outstanding credits
label var outstandcredit "Outstanding credits "
*q75a: Formal short term debt (up to one year)
label var debtFST "Formal short term debt (up to one year) "
*q75b: Informal short term debt (up to one year) 
label var debtinFST "Informal short term debt (up to one year) "
*q75c: Formal long term debt (over a year)
label var debtFLT "Formal long term debt (over a year) "
*q75d: Informal long term debt (over a year)
label var debtinFLT "Informal long term debt (over a year)"
*q76a: Percentage of Interest payment on formal loans
label var ipay4Fdebt "Percentage of Interest payment on formal loans "
label var debtfail "Firm failure to service its debt last year" 
label var payables "Payables owed to suppliers"
label var receivables  "Receivables due from customers"
label var sellland "Sell any land, buildings, equipments last year"
label var selllandvalue "Value of land sold last year"

*q81: Have problems of getting the loan (99 unknown, Yes=1, No=2)
label var creditcons "Have problems of getting the loan "
*q81a: Reason for problems of getting the loan
*Code: Lack of collateral (1); Did not deliver a proper description of the potential of the enterprise (2); 
*Complicated government regulations (3) Administrative difficulties in obtaining clearance from bank authorities (4); Other (5).
label var Creditconsreason "Reason for problems of getting the loan"
*q82a: Number of formal short term loans since last survey
label var NoloanFST "Number of formal short term loans"
*q82b: Number of formal long- term loans
label var NoloanFLT "Number of formal long term loans "
*Interest rate (%month) from Formal loans
label var irateF "Interest rate (percent month) from Formal loans"
*Interest rate (%month) from Informal loans
label var irateInF "Interest rate (percent month) from Informal loans"
*Percentage of Investments financed by stocks issued
label var collateral "Firms offer any collateral for the loan"
label var collateralhow "What kind of collateral: (1)Land (2) Housing (3)Capital (4) Personal belongings (5) Others"
label var stockfinance "Percentage of Investments financed by stocks issued"
*q83a: Type of bank/formal credit institution firm use?
*Code: State Owned Commercial Bank (SOCB) (1), Private bank (2), Foreign bank (3), Social Policy Bank (4), 
*DAF (Development assistance fund) (5), Targeted programs (6), Other (7)
label var whichbank "Type of bank/formal credit institution firm use?"
*q84a: Number of formal short term loans denied since last survey 
label var NodenialloanFST "Number of formal short term loans denied since last survey"
*q84b: Number of formal long term loans denied since last survey
label var NodenialloanFLT "Number of formal long term loans denied since last survey"
*q88: borrowed from informal sources since last survey (99 unknown, Yes=1, No=2)
label var loaninF "Borrowed from informal sources since last survey"
label var newproductsuccess "Success of introduction of new product groups"
*q123c: Success of firm improve existing products
*Code: Successful (1), Unsuccessful (2), Too early to tell (3)
label var impproductsuccess "Success of firm improve existing products"
*q124c: Success of firm introduce new technology
*Code: Successful (1), Unsuccessful (2), Too early to tell (3)
label var newtechsuccess "Newtechsucc Success of firm introduce new technology"
label var sales "Revenue from sales"
label var indirectcosts "Total indirect costs"
label var directcosts "Value of direct costs"
label var valueadded "Total value-added"
label var wage "Total wage"
label var grossprofit "Total grossprofit"
label var extraincome "Additional income" 
label var capitalpreyr " Capital year t-1"
label var labourpreyr "Labour year t-1"
label var directcostspreyr "Direct costs year t-1"
label var valaddpreyr "Value added year t-1"
label var salespreyr "Sales year t-1"
label var outputpreyr "Output year t-1"

* Name of goods/services (2 digits)- ISIC digit - GSO product list, given in manual of John Rand
label var isic "Name of goods/services" 
label var depreciation "Value of depreciation"
label var ipaymentpnl "total interest payment"
label var tax "Total fee and taxes (formal)"
*Constraints and competition
label var constr1 "Shortage of capital/credit"
label var constr2 "Cannot afford to hire wage labour"
label var constr3 "Lack of skilled workers in the local job market"
label var constr4 "Lack of technical know-how"
label var constr5 "Current products/services have limited/reduced demand"
label var constr6 "Too much competition/unfair competition"
label var constr7 "Lack marketing services or transport facilities"
label var constr8 "Lack of modern machinery/equipment"
label var constr9 "Lack of raw material"
label var constr10 "Lack of energy (power, fuel)"
label var constr11 "Inadequate premises/land"
label var constr12 "Too much interference by local officials"
label var constr13 "Government policies uncertain"
label var constr14 "ifficult to get licences/permissions from authorities"
label var constr15 "Other factors"
label var competefrsoe "Competition from SOE"
label var competefrnonsoe "Competition from Non-SOEs"
label var competefrforeign "Competition from Foreign firms"
label var competefrsmuggling "Competition from Smuggling"
label var competefrother "Competition from others"
*Business environments
label var labourregular "Regular labour FT+PT"
label var labourcasual "Number of casual labour"
label var unskilledlabour "Number of unskilled labour"

label var ownerpastown "Do owners own any other enterprise in the past?"
label var supplier "Suppliers are SOE/private/Direct import"
label var salessnontourist "Sales structure from nontourist"
label var salessnonSOE "Sales structure from nonSOE"
label var salessSOE "Sales structure from SOE"
label var salessgov "Sales structure from Gov authorities"
label var salesstourist "Sales structure from tourists"
label var salessexport "Sales structure from export"
label var salessforeignfirm "Sales structure from foreign firms"
label var exportyear "Year of export"
label var exportcustomerno "Number of export customers"
label var busiservices "Any business services that you purchase?"
label var collateral "Any collateral offered by firms for their loans"
label var collateralhow "What collateral: (1)Land, (2) Housing, (3) ... "
label var taxfee "Tax and fee paid"
label var sharemanagertime "Share of Manager time for tax, fee paid"
label var bribe "Do firms do bribery"
*Network
label var contactsamesector "No. contacts from same sector"
label var contactdiffsector "No. contacts from different sector"
label var contactbank "No. contacts from banks"
label var contactpolitics "No. contacts from politics"
label var contactothers "No. contacts from others"
label var contactmostimp "Amongst your contact, who is the most important"
label var contactimes "How many times of contact for firm operation?"
label var contactlastime "When is the last time of contact for firm operation? (1)less than a month, ..." 
label var networksupplier "Percentage of contacts are suppliers"
label var networkcustomer "Percentage of contacts are customers"
label var networkdebtor "Percentage of contacts are debtors"
label var networkcreditor "Percentage of contacts are creditors"
label var networkwomen "Percentage of contacts are women"
label var associationfee "Fee to join association"
*Gov Support
label var govassist "Received supports from gov"
label var govassistauthority "Which gov authority that you receive gov assitance" 
label var govassistcontacted "How did you get contact with authority (1)You contacted, (2) You are contacted"
label var govassistbribery "Did you bribes to obtain assistance"
label var govtechsupport "Gov support in tech"
label var govloans "Gov support in loans"
label var govtaxsupport "Gov support in tax"
label var govhumantraining "Gov support in human training"

sort q1 t
save m:\vietnam\2016\2007-09-11-13b.dta, replace

notes producttool: Code 1: Only hand tools, no machinery
notes producttool: Code 2: Manually operated machinery only 
notes producttool: Code 3: Power driven machinery only 
notes producttool: Code 4: Both manually and power driven machinery 
notes producttool: Code 5: Other

notes association: Code 1: Yes, one ore more association
notes association: Code 2: No association

notes competition: Yes=1, No=2
notes newproduct: Yes=1, No=2
notes newtech: Yes=1, No=2
notes impproduct: Yes=1, No=2
notes competefrsoe: Average ranking from (1)Severe (2)Moderate (3)Insignificant (4)No competition - Weights in the reverse

replace extraincome=0 if extraincome==99
replace owncapitalpercent=0 if owncapitalpercent==.

foreach var of varlist invland invbuilding invequip invRnD invhuman{
replace `var'=0 if `var'==.
}
replace stockfinance=0 if stockfinance==.

replace investment=1 if investment==2 & invcost>0 
replace investment=2 if investment==1 & invcost==0 & invland==0 & invbuilding==0 & invequip==0 & invRnD==0 & invhuman==0 & invpatents==0   
replace invcost=invland+invbuilding+invequip+invRnD+invhuman+invpatents if invland!=99 & invcost==99 
replace invcost=invland+invbuilding+invequip+invRnD+invhuman+invpatents if invbuilding!=0 & invcost==0
replace invcost=0 if invcost==. | invcost==99
foreach var of varlist selllandvalue sellbuildingsvalue sellequipvalue sales grossprofit depreciation ipaymentpnl tax extraincome output valueadded indirectcosts directcosts wage{
  replace `var'=0 if `var'==. | `var'==99 | `var'==98
}
replace labourpreyr=. if labourpreyr==99 | labourpreyr==98
foreach var of varlist salespreyr outputpreyr extraincomepreyr indirectcostspreyr directcostspreyr valaddpreyr wagepreyr depreciationpreyr ipaymentpnlpreyr taxpreyr capitalpreyr finassetpreyr totaldebtpreyr labourpreyr {
	replace `var'=0 if `var'<0
}

saveold "M:\vietnam\2016\vietnamnhieu.dta", version(12) replace
*clear

********************************************************************************



