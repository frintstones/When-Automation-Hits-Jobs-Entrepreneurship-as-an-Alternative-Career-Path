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
* Figure 2. Automation Probability Index (API) and O*NET task measures
********************************************************************************/

 egen api1 = group(automation z_r_cog)
 bysort api1: egen api1_1 = count(api1)

 twoway  (scatter automation z_r_cog [aw = api1_1], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit automation z_r_cog), legend(off) name(api1, replace) ytitle("Automation Probability Index", size(medsmall)) xtitle("Routine Cognitive Measure", size(medsmall)) ///
    scheme(white_tableau)
	
 egen api2 = group(automation z_r_man)
 bysort api2: egen api1_2 = count(api2)

 twoway  (scatter automation z_r_man [aw = api1_2], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit automation z_r_man), legend(off) name(api2, replace) ytitle("Automation Probability Index", size(medsmall)) xtitle("Routine Manual Measure", size(medsmall)) ///
    scheme(white_tableau) 
	
 egen api3 = group(automation z_nr_cog_anal)
 bysort api3: egen api1_3 = count(api3)

 twoway  (scatter automation z_nr_cog_anal [aw = api1_3], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit automation z_nr_cog_anal), legend(off) name(api3, replace) ytitle("Automation Probability Index", size(medsmall)) xtitle("Nonroutine Analytic Measure", size(medsmall)) ///
    scheme(white_tableau) 

 egen api4 = group(automation z_nr_cog_pers)
 bysort api4: egen api1_4 = count(api4)

 twoway  (scatter automation z_nr_cog_pers [aw = api1_4], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit automation z_nr_cog_pers), legend(off) name(api4, replace) ytitle("Automation Probability Index", size(medsmall)) xtitle("Nonroutine Interpersonal Measure", size(medsmall)) ///
    scheme(white_tableau) 
	
gr combine api1 api2 api3 api4, col(2) ysize(1) xsize(1) iscale(*0.75) scheme(s1color) title("",size(medium))	

/*******************************************************************************
* Figure 3. Unconditional Relationship between Automation Probability Index (API) and Labor Mobility
********************************************************************************/

binscatter $dev5 automation, line(lfit) reportreg  msymbol(O) ///
	title("Automation Probability Index  & Unemployment", size(medium)) ///
	ytitle(P(Transition into Unemployment), size(medsmall)) ///
	xtitle("Automation Probability Index ", size(medsmall)) ylabel() saving(auto_unemp,replace)	
	
binscatter $dev4 automation, line(lfit) reportreg  msymbol(D) ///
	title("Automation Probability Index  & Unincorporated Ent.", size(medium)) ///
	ytitle(P(Transition into unincorporated entrepreneurship),size(medsmall)) ///
	xtitle("Automation Probability Index ", size(medsmall)) ylabel() saving(auto_unincor,replace)
	
binscatter $dev3 automation, line(lfit) reportreg  msymbol(Oh) ///
	title("Automation Probability Index  & Incorporated Ent.", size(medsmall)) ///
	ytitle(P(Transition into incorporated entrepreneurship), size(medsmall)) ///
	xtitle("Automation Probability Index ", size(medsmall)) ylabel() saving(auto_incor,replace)
	
gr combine "auto_unemp" "auto_unincor" "auto_incor", col(3) ysize(1) xsize(1.5) iscale(*0.8) scheme(s1color) title("",size(medium))	

/*******************************************************************************
* Figure 4. Unconditional Relationship between Automation Technology Exposure Measures and Labor Mobility
********************************************************************************/

binscatter $dev5 robot_score, line(lfit) reportreg  msymbol(O) ///
	title("Robot Exposure & Unemployment", size(med)) ///
	ytitle("Prob. Unemp.", size(med))  ///
	xtitle("Robot Exposure Score", size(med)) ylabel() saving(a1_u,replace)	
	
binscatter $dev4 robot_score, line(lfit) reportreg  msymbol(D) ///
	title("Robot Exposure & Unincorporated Ent.", size(med)) ///
	ytitle("Prob. Unincorp. Ent.",size(med) margin(r=3))  ///
	xtitle("Robot Exposure Score", size(med)) ylabel() saving(a2_u,replace)
	
binscatter $dev3 robot_score, line(lfit) reportreg  msymbol(Oh) ///
	title("Robot Exposure & Incorporated Ent.", size(med)) ///
	ytitle("Prob. Incorp. Ent.", size(med)) ///
	xtitle("Robot Exposure Score", size(med)) ylabel() saving(a3_u,replace)
	
gr combine "a1_u" "a2_u" "a3_u", col(3) ysize(1) xsize(2.5) iscale(*1) scheme(s1color) title("A. Webb Measure of Robot Exposure",size(medium)) saving(webb_robot,replace)

binscatter $dev5 ai_score, line(lfit) reportreg  msymbol(O) ///
	title("AI Exposure & Unemployment", size(med)) ///
	ytitle("Prob. Unemp.", size(med)) ///
	xtitle("AI Exposure Score", size(med)) ylabel() saving(b1_u,replace)	
	
binscatter $dev4 ai_score, line(lfit) reportreg  msymbol(D) ///
	title("AI Exposure & Unincorporated Ent.", size(med)) ///
	ytitle("Prob. Unincorp. Ent.",size(med)) ///
	xtitle("AI Exposure Score", size(med)) ylabel() saving(b2_u,replace)
	
binscatter $dev3 ai_score, line(lfit) reportreg  msymbol(Oh) ///
	title("AI Exposure & Incorporated Ent.", size(med)) ///
	ytitle("Prob. Incorp. Ent.", size(med)) ///
	xtitle("AI Exposure Score", size(med)) ylabel() saving(b3_u,replace)
	
gr combine "b1_u" "b2_u" "b3_u", col(3) ysize(1) xsize(2.5) iscale(*1) scheme(s1color) title("B. Webb Measure of AI Exposure",size(medium)) saving(webb_ai,replace)

binscatter $dev5 aioe, line(lfit) reportreg  msymbol(O) ///
	title("AI Exposure & Unemployment", size(med)) ///
	ytitle("Prob. Unemp.", size(med)) ///
	xtitle("AI Exposure Score", size(med)) ylabel() saving(c1_u,replace)	
	
binscatter $dev4 aioe, line(lfit) reportreg  msymbol(D) ///
	title("AI Exposure & Unincorporated Ent.", size(med)) ///
	ytitle("Prob. Unincorp. Ent.",size(med)) ///
	xtitle("AI Exposure Score", size(med)) ylabel() saving(c2_u,replace)
	
binscatter $dev3 aioe, line(lfit) reportreg  msymbol(Oh) ///
	title("AI Exposure & Incorporated Ent.", size(med)) ///
	ytitle("Prob. Incorp. Ent.", size(med)) ///
	xtitle("AI Exposure Score", size(med)) ylabel() saving(c3_u,replace)
	
gr combine "c1_u" "c2_u" "c3_u", col(3) ysize(1) xsize(2.5) iscale(*1) scheme(s1color) title("C. Felten et al. Measure of AI Exposure",size(medium)) saving(felton_ai,replace)

gr combine "webb_robot" "webb_ai" "felton_ai", col(1) ysize(2) xsize(2) iscale(*0.7) scheme(s1color) title("",size(medium))


/*******************************************************************************
* Figure 5. Automation Technology Exposure Measures and O*NET task measures
********************************************************************************/

 egen a1 = group(robot_score z_r_cog)
 bysort a1: egen aa1 = count(a1)

 twoway  (scatter robot_score z_r_cog [aw = aa1], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit robot_score z_r_cog), legend(off) name(robot1, replace) ytitle("Robot Exposure Score", size(medsmall)) xtitle("Routine Cognitive", size(medsmall)) ///
    scheme(white_tableau) 
	
 egen a2 = group(robot_score z_r_man)
 bysort a2: egen aa2 = count(a2)
	
 twoway  (scatter robot_score z_r_man [aw = aa2], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit robot_score z_r_man),legend(off) name(robot2, replace) ytitle("Robot Exposure Score", size(medsmall)) xtitle("Routine Manual", size(medsmall)) ///
    scheme(white_tableau)

	
 egen a3 = group(robot_score z_nr_cog_anal)
 bysort a3: egen aa3 = count(a3)

 twoway  (scatter robot_score z_nr_cog_anal [aw = aa3], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit robot_score z_nr_cog_anal),legend(off) name(robot3, replace) ytitle("Robot Exposure Score", size(medsmall)) xtitle("Nonroutine Analytic", size(medsmall)) ///
    scheme(white_tableau) 
	
 egen a4 = group(robot_score z_nr_cog_pers)
 bysort a4: egen aa4 = count(a4)

 twoway  (scatter robot_score z_nr_cog_pers [aw = aa4], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit robot_score z_nr_cog_pers),legend(off) name(robot4, replace) ytitle("Robot Exposure Score", size(medsmall)) xtitle("Nonroutine Interpersonal", size(medsmall)) ///
    scheme(white_tableau) 

gr combine robot1 robot2 robot3 robot4, col(4) ysize(1) xsize(3) iscale(*1) scheme(s1color) title("Webb Measure of Robot Exposure & O*NET Task Measures",size(medium)) name(task_robot, replace)

/////////////////////

egen b1 = group(ai_score z_r_cog)
 bysort b1: egen bb1 = count(b1)

 twoway  (scatter ai_score z_r_cog [aw = bb1], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit ai_score z_r_cog), legend(off) name(ai1, replace) ytitle("AI Exposure Score", size(medsmall)) xtitle("Routine Cognitive", size(medsmall)) ///
    scheme(white_tableau) 
	
 egen b2 = group(ai_score z_r_man)
 bysort b2: egen bb2 = count(b2)
	
 twoway  (scatter ai_score z_r_man [aw = bb2], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit ai_score z_r_man),legend(off) name(ai2, replace) ytitle("AI Exposure Score", size(medsmall)) xtitle("Routine Manual", size(medsmall)) ///
    scheme(white_tableau)

	
 egen b3 = group(ai_score z_nr_cog_anal)
 bysort b3: egen bb3 = count(b3)

 twoway  (scatter ai_score z_nr_cog_anal [aw = bb3], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit ai_score z_nr_cog_anal),legend(off) name(ai3, replace) ytitle("AI Exposure Score", size(medsmall)) xtitle("Nonroutine Analytic", size(medsmall)) ///
    scheme(white_tableau) 
	
 egen b4 = group(ai_score z_nr_cog_pers)
 bysort b4: egen bb4 = count(b4)

 twoway  (scatter ai_score z_nr_cog_pers [aw = bb4], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit ai_score z_nr_cog_pers),legend(off) name(ai4, replace) ytitle("AI Exposure Score", size(medsmall)) xtitle("Nonroutine Interpersonal", size(medsmall)) ///
    scheme(white_tableau) 

gr combine ai1 ai2 ai3 ai4, col(4) ysize(1) xsize(3) iscale(*1) scheme(s1color) title("Webb Measure of AI Exposure & O*NET Task Measures",size(medium)) name(task_ai, replace)


///////////////////////

egen c1 = group(aioe z_r_cog)
 bysort c1: egen cc1 = count(c1)

 twoway  (scatter aioe z_r_cog [aw = cc1], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit aioe z_r_cog), legend(off) name(aioe1, replace) ytitle("AI Exposure Score", size(medsmall)) xtitle("Routine Cognitive", size(medsmall)) ///
    scheme(white_tableau) 
	
 egen c2 = group(aioe z_r_man)
 bysort c2: egen cc2 = count(c2)
	
 twoway  (scatter aioe z_r_man [aw = cc2], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit aioe z_r_man),legend(off) name(aioe2, replace) ytitle("AI Exposure Score", size(medsmall)) xtitle("Routine Manual", size(medsmall)) ///
    scheme(white_tableau)

	
 egen c3 = group(aioe z_nr_cog_anal)
 bysort c3: egen cc3 = count(c3)

 twoway  (scatter aioe z_nr_cog_anal [aw = cc3], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit aioe z_nr_cog_anal),legend(off) name(aioe3, replace) ytitle("AI Exposure Score", size(medsmall)) xtitle("Nonroutine Analytic", size(medsmall)) ///
    scheme(white_tableau) 
	
 egen c4 = group(aioe z_nr_cog_pers)
 bysort c4: egen cc4 = count(c4)

 twoway  (scatter aioe z_nr_cog_pers [aw = cc4], mcolor(%60) mlwidth(0) msize(0.5) legend(off)) ///
    (lfit aioe z_nr_cog_pers),legend(off) name(aioe4, replace) ytitle("AI Exposure Score", size(medsmall)) xtitle("Nonroutine Interpersonal", size(medsmall)) ///
    scheme(white_tableau) 

gr combine aioe1 aioe2 aioe3 aioe4, col(4) ysize(1) xsize(3) iscale(*1) scheme(s1color) title("Felten et al. Measure of AI Exposure & O*NET Task Measures",size(medium)) name(task_aioe, replace)

gr combine task_robot task_ai task_aioe, col(1) ysize(1) xsize(1) iscale(*0.75) scheme(s1color) title("",size(medium))
