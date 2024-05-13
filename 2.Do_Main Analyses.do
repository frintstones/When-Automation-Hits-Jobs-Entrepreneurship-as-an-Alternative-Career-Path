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


*********************************************************************************
** Figure 2. Automation Probability Index (API) and O*NET task measures
*********************************************************************************

binscatterhist automation z_r_cog, histogram(automation z_r_cog) xhistbins(40) yhistbins(40) msymbols(T) text(0.2 2 "Coeff. = 0.1974" "Std. err. = 0.0005", place(e))  xhistbarheight(15) yhistbarheight(15) ///
	title("Automation Probability Index  & Routine Cognitive Task", size(medium)) ///
	ytitle("Automation Probability Index ", size(medsmall)) ///
	xtitle("Routine Cognitive Task", size(medsmall)) ylabel() saving(auto_rc,replace)
	
binscatterhist automation z_r_man, histogram(automation z_r_man) xhistbins(40) yhistbins(40) ymin(0.001) msymbols(Oh) text(0.8 0.7 "Coeff. = -0.4794" "Std. err. = 0.0012", place(e))  ///
	title("Automation Probability Index  & Routine Manual Task", size(medium)) ///
	ytitle("Automation Probability Index ", size(medsmall)) ///
	xtitle("Routine Manual Task", size(medsmall)) ylabel() saving(auto_rm,replace)		

binscatterhist automation z_nr_cog_anal, histogram(automation z_nr_cog_anal) xhistbins(40) yhistbins(40) ymin(0.001) msymbols(X) text(0.7 0.9 "Coeff. = -0.1260" "Std. err. = 0.0003", place(e))  ///
	title("Automation Probability Index  & Nonroutine analytic", size(medium)) ///
	ytitle("Automation Probability Index ", size(medsmall)) ///
	xtitle("Nonroutine analytic", size(medsmall)) ylabel() saving(auto_na,replace)
	
binscatterhist automation z_nr_cog_pers, histogram(automation z_nr_cog_pers) xhistbins(40) yhistbins(40) ymin(0.001) msymbols(X) text(0.7 0.9 "Coeff. = -0.1260" "Std. err. = 0.0003", place(e))  ///
	title("Automation Probability Index  & Nonroutine Interpersonal", size(medium)) ///
	ytitle("Automation Probability Index ", size(medsmall)) ///
	xtitle("Nonroutine Interpersonal", size(medsmall)) ylabel() saving(auto_ni,replace)	
	
gr combine "auto_rc" "auto_rm" "auto_na"  "auto_ni", col(2) ysize(3) xsize(2) iscale(*0.8) scheme(s1color) title("",size(medium))		