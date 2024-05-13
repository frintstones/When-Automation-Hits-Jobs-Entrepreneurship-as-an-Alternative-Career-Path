/******************************************************************************/
/*                                                                            */
/*  When Automation Hits Jobs: Entrepreneurship as an Alternative Career Path */
/*                                                                            */
/******************************************************************************/

clear all
global sbe "E:\PERSONS\Daehyun Kim\ENT_Covid\Dataroom"
use "${sbe}\automation_ent_data.dta",clear

char _dta[omit] "prevalent"
global dev3 "ent_raw_incor" // Transition into Incorporated Entrepreneurship
global dev4 "ent_raw_unincor" // Transition into Unincorporated Entrepreneurship
global dev5 "c_unemp" // Transition into Unemployment
global cont_var_ii "i.sex i.income i.ethnic i.edu_cat i.married i.citizen" // Individual controls
global fixed_var "i.stfips#i.year i.season i.naics3" // Macro level controls
global cont_var "unemp_rate_recent c.age##c.age" // state-level unemployment rate & Individual Age
global reg_tail "$cont_var [pweight=cmpwgt], cluster(soccode) absorb($fixed_var $cont_var_ii)"
global esttab_tail "se noomitted nobaselevels drop(age c.age#c.age unemp_rate_recent _cons) star(* 0.1 ** 0.05 *** 0.01)"
label drop _all

/*******************************************************************************
** Table 2. Automation Probability Index (API), Unemployment, and Entrepreneurship
********************************************************************************/

 qui reghdfe $dev5 c.automation $reg_tail
 est store auto_v1

 qui reghdfe $dev4 c.automation $reg_tail
 est store auto_v2

 qui reghdfe $dev3 c.automation $reg_tail
 est store auto_v3

 esttab auto_v* , stats(N r2_a) $esttab_tail 


/*******************************************************************************
** Table 3. Automation Technology Exposure Measures, Unemployment, and Entrepreneurship
********************************************************************************/

*Panel A: Webb Measure of Robot Exposure
 qui reghdfe $dev5 c.robot_score c.software_score $reg_tail
 est store robot_v1

 qui reghdfe $dev4 c.robot_score c.software_score $reg_tail
 est store robot_v2

 qui reghdfe $dev3 c.robot_score c.software_score $reg_tail
 est store robot_v3

 esttab robot_v* , stats(N r2_a) $esttab_tail 

*Panel B: Webb Measure of AI Exposure
 qui reghdfe $dev5 c.ai_score c.software_score $reg_tail
 est store ai_v1

 qui reghdfe $dev4 c.ai_score c.software_score $reg_tail
 est store ai_v2

 qui reghdfe $dev3 c.ai_score c.software_score $reg_tail
 est store ai_v3

 esttab ai_v* , stats(N r2_a) $esttab_tail 
 
*Panel C: Felten et al. Measure of AI Exposure
 qui reghdfe $dev5 c.aioe c.software_score $reg_tail
 est store aioe_v1

 qui reghdfe $dev4 c.aioe c.software_score $reg_tail
 est store aioe_v2

 qui reghdfe $dev3 c.aioe c.software_score $reg_tail   
 est store aioe_v3

 esttab aioe_v* , stats(N r2_a) $esttab_tail 
 
/*******************************************************************************
** Table 4. Automation Probability Index (API), Unemployment, and Entrepreneurship by Sex
********************************************************************************/

 qui reghdfe $dev5 c.automation##i.female $reg_tail 
 est store auto_g1

 qui reghdfe $dev4 c.automation##i.female $reg_tail 
 est store auto_g2

 qui reghdfe $dev3 c.automation##i.female $reg_tail 
 est store auto_g3

esttab auto_g* , stats(N r2_a) $esttab_tail 
 
*********************************************************************************
** Table 5. Automation Probability Index (API), Unemployment, and Entrepreneurship (by COVID-19)
*********************************************************************************

 qui reghdfe $dev5 c.automation covid_20_21_auto covid_22_auto covid_23_auto covid_20_21 covid_22 covid_23 exposure proximity $reg_tail   
 est store covid_v1
 
 qui reghdfe $dev4 c.automation covid_20_21_auto covid_22_auto covid_23_auto covid_20_21 covid_22 covid_23 exposure proximity $reg_tail   
 est store covid_v2
 
 qui reghdfe $dev3 c.automation covid_20_21_auto covid_22_auto covid_23_auto covid_20_21 covid_22 covid_23 exposure proximity $reg_tail   
 est store covid_v3

esttab covid_v* , stats(N r2_a) $esttab_tail 
