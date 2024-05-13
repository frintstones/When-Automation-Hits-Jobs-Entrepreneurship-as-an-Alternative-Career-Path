/******************************************************************************/
/*                                                                            */
/*  When Automation Hits Jobs: Entrepreneurship as an Alternative Career Path */
/*                                                                            */
/******************************************************************************/

/****************************************************************************
** Table1 : Descriptive Statistics
****************************************************************************/

clear all
global sbe "E:\PERSONS\Daehyun Kim\ENT_Covid\Dataroom"
use "${sbe}\automation_ent_data.dta",clear

preserve
 drop if automation == .
 asdoc sum c_unemp ent_raw_unincor ent_raw_incor automation age sex income ethnic edu_cat married citizen unemp_rate_recent naics3 state_duma year season, dec(5)
restore

preserve
 drop if ai_score == .
 asdoc sum robot_score ai_score aioe, dec(5)
restore