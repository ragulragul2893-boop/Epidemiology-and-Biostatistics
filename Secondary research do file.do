
* 1. Keep only 60 years and above

* 1. Start fresh by reloading your dataset

* 2. Check age variable
summarize dm005

**# Bookmark #1
* 3. Keep only 60 and above
keep if dm005 >= 60

* 4. Generate age category

gen age_cat = .

replace age_cat = 1 if dm005 >= 60 & dm005 < 69
replace age_cat = 2 if dm005 >= 70 & dm005 < 79
replace age_cat = 3 if dm005 >= 80

* 5. Label categories
label define agegrp 1 "60-69" 2 "70-79" 3 "80+"
label values age_cat agegrp


* 6. Tabulate
tab age_cat

 tab age_cat, m

///////bmi/////////////

gen bmi = bm071 / (bm067^2)
drop bmi
gen height_m = bm067 / 100
gen bmi = bm071 / (height_m^2)



gen bmi_cat = .
replace bmi_cat = 1 if bmi < 18.5
replace bmi_cat = 2 if bmi >= 18.5 & bmi < 25
replace bmi_cat = 3 if bmi >= 25 & bmi < 30
replace bmi_cat = 4 if bmi >= 30

label define bmi_lbl 1 "Underweight" 2 "Normal" 3 "Overweight" 4 "Obese", replace
label values bmi_cat bmi_lbl
tab bmi_cat, m




//////////////obese//////////

gen bmii = bm071 / ((bm067/100)^2)
gen obese = .
replace obese = 1 if bmi >= 30
replace obese = 0 if bmi < 30
label define ob 0 "Not Obese" 1 "Obese"
label values obese ob
tab obese


/////////////Malnutrition////////////


gen malnutrition = .
replace malnutrition = 1 if bmi < 18.5
replace malnutrition = 0 if bmi >= 18.5 & bmi < .
label define uw 0 "Not underweight" 1 "Underweight"
label values malnutrition uw

replace malnutrition = 0 if missing(malnutrition)


tab malnutrition

//////////preventive check up////////////
gen prev_check = .
replace prev_check = 1 if hc004s1 == 1
replace prev_check = 0 if hc004s1 == 0
label define prev_lbl 0 "No" 1 "Yes"
label values prev_check prev_lbl

replace prev_check = 0 if missing(prev_check)

tab prev_check, m

///////////health insurance /////////

gen health_insurance = .
replace health_insurance = 1 if hc102 == 1
replace health_insurance = 0 if hc102 == 2

label define hea_lbl 0 "No" 1 "Yes"
label values health_insurance hea_lbl

replace health_insurance = 0 if missing(health_insurance)


tab health_insurance, m


////////////education////////////


gen educ_cat = .
replace educ_cat = 1 if inlist(dm008, 1, 2)
replace educ_cat = 2 if dm008 == 3
replace educ_cat = 3 if dm008 == 4
replace educ_cat = 4 if inrange(dm008, 5, 9)

label define edu_lbl 1 "No education / Less than Primary" ///
                    2 "Primary / Middle school" ///
                    3 "Matric / Secondary" ///
                    4 "Higher Secondary and above"

label values educ_cat edu_lbl

replace educ_cat = 0 if missing(educ_cat)

tab educ_cat
tab educ_cat, m

//////////////caste////////////////////

gen caste_cat = .
replace caste_cat = 1 if dm013 == 1
replace caste_cat = 2 if dm013 == 2
replace caste_cat = 3 if dm013 == 3
replace caste_cat = 4 if missing(dm013) | inlist(dm013, .d, .r)

label define caste_lbl 1 "Scheduled Caste" ///
                      2 "Scheduled Tribe" ///
                      3 "OBC" ///
                      4 "General/Other"

label values caste_cat caste_lbl



tab caste_cat



////////////UPDATE WORK_STATUS ///////

* Step 1: Generate the variable
gen working_status = .

* Step 2: Code working_status
replace working_status = 1 if !missing(we308)
replace working_status = 0 if missing(we308)

* Step 3: Define value labels
label define work_lbl 0 "Not Working" 1 "Working"

* Step 4: Attach labels to the variable
label values working_status work_lbl

* Step 5: Tabulate with labels
tab working_status



/////////////religion////////////////

gen religion_cat = .
replace religion_cat = 1 if dm010 == 2                    // Hindu
replace religion_cat = 2 if dm010 == 3                    // Muslim
replace religion_cat = 3 if dm010 == 4                    // Christian
replace religion_cat = 4 if inlist(dm010, 1,5,6,7,8,9,10) | dm010 == .r   // Others

label define rel 1 "Hindu" 2 "Muslim" 3 "Christian" 4 "Others"
label values religion_cat rel

tab religion_cat


/////////////smoke//////////////

gen smoke_current = .
replace smoke_current = 1 if hb003 == 1
replace smoke_current = 0 if inlist(hb003, 2, ., .d, .r)
label define tob_curr 0 "No" 1 "Yes"
label values smoke_current tob_curr

label variable smoke_current "Current tobacco use"

replace smoke_current = 0 if missing(smoke_current)


tab smoke_current, m



////////////////alcohol///////////////

gen alcohol_used = .
replace alcohol_used = 1 if hb101 == 1
replace alcohol_used = 0 if hb101 == 2 | hb101 == . | hb101 == .d | hb101 == .r

label define alcohol_lbl 0 "No" 1 "Yes"
label values alcohol_used alcohol_lbl

label variable alcohol_used "Alcohol used"

replace alcohol_used = 0 if missing(alcohol_used)


tab alcohol_used


* Recode dm021 (marital status) into two categories
gen marita_status = .
replace marita_status = 1 if dm021 == 1        // Currently married
replace marita_status = 0 if inlist(dm021, 2, 3, 4, 5, 6, 7)   // Widowed, divorced, separated, deserted, live-in, never married

* Label the new variable
label define mar_lbl 0 "Widowed/Separated/Divorced/Others" 1 "Currently married"
label values marita_status mar_lbl

* Check the recode
tab marita_status




///////////////////////////sociodemographic FRE & PER ///////////////////


tab age_cat
tab residence 
tab dm003
tab caste_cat
tab religion_cat
tab marita_status
tab working_status
tab educ_cat
tab smoke_current
tab alcohol_used
tab bmi_cat



///////////// prevalence of preventive health checkup utilization /////////
tab prev_check

/////////////association between preventive health check-up utilization and nutritional status (malnutrition & obesity)/////////////

tab prev_check malnutrition, row chi2
tab prev_check obese, row chi2


//////////////////sociodemographic and health-related factors associated with the utilization of preventive health checkups//////////////multivariable logistic regression////////////

logit prev_check i. age_cat i.residence i.dm003 i.caste_cat i.religion_cat i.marita_status i.educ_cat i.smoke_current i.alcohol_used i.obese

/////drop variables /////////


logit prev_check i.age_cat i.residence i.dm003 i.caste_cat i.religion_cat i.marita_status i.educ_cat i.smoke_current i.alcohol_used i.obese, or




///////////////sociodemographic and health-related factors associated with the utilization of preventive health checkups//////////////

tab prev_check age_cat, row chi2
tab prev_check residence, row chi2
tab prev_check dm003, row chi2
tab prev_check caste_cat, row chi2
tab prev_check religion_cat, row chi2
tab prev_check marita_status, row chi2
tab prev_check educ_cat, row chi2
tab prev_check smoke_current, row chi2
tab prev_check alcohol_used, row chi2




















