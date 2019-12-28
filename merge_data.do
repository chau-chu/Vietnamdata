clear 
set more off

*=======================================================================*
*==================       1. RENAME     ================================*
*=======================    Wave2005    ================================*
*=======================================================================*
*cd M:\vietnam\2016   // If you download files to your folders, make sure you change this directory path.
use sme2005_distributionOK.dta, clear 
drop if q1==.
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

gen t=2005
save 2005.dta,replace
*=======================================================================*
*==================       1. RENAME (Cont)    ==========================*
*=======================    Wave2007    ================================*
*=======================================================================*

use sme2007_distributionOK.dta, clear 
drop if q1==.
sort q1

keep q1 q5 q6a q7a q12 q14a q14c q17a q26d q44 q93c q95 q73b_1 kt3_01 kt3_02 kt3_03 kt3_05 kt3_09 kt3_10 kt3_11 kt3_12 kt3_17 kt3_23 
rename q5new industrialzone // 1= Industrial zone/park, 2= No
rename q6a yearstart
rename q7a taxcode //1=Yes, 2= No
rename q12 ownership
rename q14a accessroad
rename q14c accessrail
rename q17a isic
rename q26d owneredu
rename q44 export
rename q93c totalasset
rename q95 totaldebt
rename q73b_1 labourall

rename kt3_01 sales
rename kt3_02 output
rename kt3_03 extraincome
rename kt3_05 directcosts
rename kt3_09 grossprofit
rename kt3_10 depreciation
rename kt3_11 ipaymentpnl
rename kt3_12 tax
rename kt3_17 capital
rename kt3_23 labour

gen t=2007
drop if q1==.
save 2007.dta,replace

*=======================================================================*
*==================      2. MERGE 2 WAVES     ==========================*
*=======================================================================*
use 2005.dta, clear
append using 2007.dta
sort q1
save 2005-07.dta , replace

*=======================================================================*
*============     3. LABEL VARS IN MERGED DATASET    ===================*
*=======================================================================*
label var q1 "Firm ID"
label var industrialzone "Firms belong to Industrial zone/Park"
label var yearstart "Year of establishment"
label var taxcode "Firms have tax code"
label var ownership "Types of ownership"
label var accessroad "Easy access to main road"
label var accessrail "Easy access to rail"
label var isic "Name of goods/services" 
label var owneredu "Education levels of owners/managers"
label var export "Export"
label var totalasset "Total assets "
label var totaldebt "Total liabilities last year "
label var labourall "Total work force number " 

label var sales "Revenue from sales"
label var output "Production output"
label var extraincome "Additional income" 
label var directcosts "Value of direct costs"
label var grossprofit "Total grossprofit"
label var depreciation "Value of depreciation"
label var ipaymentpnl "total interest payment"
label var tax "Total fee and taxes (formal)"
label var capital "Market value of total physical assets "
label var labour "Total work force number -Full-time equivalent workers" 

saveold vietnam.dta, version(12) replace
