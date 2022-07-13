*******************************************************
*Actual trends graph from today
********************************************************

/***************************   HEADER **********************************/
	clear all

	//set local directory
	*If Mac
	if regexm("`c(pwd)'","/Users/")==1  { //Mac user
		global startDir ""
		global repoDir ""
		//sysdir set PLUS $startDir/../../toolbox/STATA_toolbox/plus
		sysdir set PLUS $repoDir/scripts/toolbox/STATA/plus 
	}
	*If PC
	else if regexm(c(os),"Windows")==1 { //PC user
		global startDir "C:\"
		global repoDir "C:\"
	}
	if "$startDir"=="" exit 
	disp "local path is $startDir"

	//set subfolders
	global processedDir "$startDir/replication_folder"
	global figuresDir "$repoDir/figures"
	
	set scheme plotplainblind

*Replication figure 4 panel a
use $processedDir/census_tract_year_pm25_from_electricity, clear
collapse (mean) totalpm25, by(year)

line totalpm25  year , lpattern(solid) lcolor(black)  lwidth(medthick)   ylabel(0(0.5)2.5) xlabel(2000(2)2018, labsize(small)) ytitle("PM{sub:2.5}")
 

	graph export $figuresDir/figures_replication/avgpm25_inmap.png, as(png) replace


*Replication figure 4 panels b and c
use $processedDir/census_tract_year_pm25_from_electricity, clear


	
gen white_num=totalpm25*(1-minority_pct)*total_pop
gen white_den=(1-minority_pct)*total_pop

local group "minority black hispanic"

foreach g in `group'{
	gen `g'_num=totalpm25*`g'_pct*total_pop
	gen `g'_den=`g'_pct*total_pop
}

egen deciles_inc=xtile(median_income), nq(10) by(year)

forvalues d=1/10{
	gen dec_`d'=(deciles_inc==`d')
	gen deciles_num_`d'=totalpm25*dec_`d'*total_pop
	gen deciles_den_`d'=dec_`d'*total_pop
}

egen quantiles_inc=xtile(median_income), nq(4) by(year)

forvalues d=1/4{
	gen quan_`d'=(deciles_inc==`d')
	gen quantiles_num_`d'=totalpm25*quan_`d'*total_pop
	gen quantiles_den_`d'=quan_`d'*total_pop
}

collapse (sum) white_num white_den minority_num minority_den black_num black_den hispanic_num hispanic_den deciles_num_* deciles_den_* quantiles_den_* quantiles_num_*, by(year)

gen W=white_num/white_den
gen B=black_num/black_den
gen H=hispanic_num/hispanic_den
gen M=minority_num/minority_den
gen D1=deciles_num_1/deciles_den_1
gen D10=deciles_num_10/deciles_den_10
gen Q1=quantiles_num_1/quantiles_den_1
gen Q4=quantiles_num_4/quantiles_den_4

la var W "White"
la var B "Black/African American"
la var H "Hispanic"

gen stat_BW=B-W
gen stat_MW=M-W
gen stat_HW=H-W
gen stat_deciles=D1-D10	
gen stat_quantiles=Q1-Q4

la var stat_BW "Black-White Gap"
la var stat_HW "Hispanic-White Gap"
la var stat_deciles "Decile 1-Decile 10 Gap"

twoway (line B year, lwidth(medthick) lcolor(gs10) lpattern(solid) xlabel(2000(4)2018)) (line H year, lwidth(medthick) lcolor(sky) lpattern(solid) xlabel(2000(4)2018, labsize(medium)) ) (line W year, lwidth(medthick) lcolor(black) lpattern(solid) xlabel(2000(4)2018)), xtitle("")  ytitle("PM{sub:2.5} ({&mu}/m{sup:3}/person)", size(medium)) legend(pos(8) ring(0) col(1) order(1 "Black" 2 "Hispanic" 3 "White" ) size(medsmall)) 
	graph export $figuresDir/figures_replication/trends_W_B_H_all.png, as(png) replace

twoway (line D1 year, lwidth(medthick) lcolor(orange%50)  lpattern(solid) xlabel(2000(4)2018, labsize(medium))) (line D10 year, lwidth(medthick) lcolor(turquoise%50) lpattern(solid) xlabel(2000(4)2018)), xtitle("")  ytitle("PM{sub:2.5} ({&mu}/m{sup:3}/person)", size(medium)) legend(pos(8) ring(0) col(1) order(1 "1st Decile" 2 "10th Decile") size(medsmall)) 
	graph export $figuresDir/figures_replication/trends_D1_D10_all.png, as(png) replace

