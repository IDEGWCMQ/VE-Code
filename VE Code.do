

use Data
gen Sex=1 if gender=="Male"
replace Sex=2 if gender=="Female"
label define Sex 1"Male" 2"Female"
label values Sex Sex
gen AgeCat1=1 if Age<20
replace AgeCat1=2 if (Age>=20 & Age<30) 
replace AgeCat1=3 if (Age>=30 & Age<40) 
replace AgeCat1=4 if (Age>=40 & Age<50) 
replace AgeCat1=5 if (Age>=50 & Age<60) 
replace AgeCat1=6 if (Age>=60 & Age<70) 
replace AgeCat1=7 if (Age>=70) 
label define AgeCat1 1"<20" 2"20-29" 3"30-39" 4"40-49" 5"50-59" 6"60-69" 7"70+"
label values AgeCat1 AgeCat1
gen AgeR10=1 if Age<10 
replace AgeR10=2 if (Age>=10 & Age<20) 
replace AgeR10=3 if (Age>=20 & Age<30) 
replace AgeR10=4 if (Age>=30 & Age<40) 
replace AgeR10=5 if (Age>=40 & Age<50) 
replace AgeR10=6 if (Age>=50 & Age<60) 
replace AgeR10=7 if (Age>=60 & Age<70) 
replace AgeR10=8 if (Age>=70) 
label define AgeR10 1"0-9" 2"10-19" 3"20-29" 4"30-39" 5"40-49" 6"50-59" 7"60-69" 8"70+"
label values AgeR10 AgeR10
keep if ReasonforPCRTesting=="Clinical suspicion"
gen CaseControl=1 if PCRresult==1
replace CaseControl=0 if PCRresult==0
label define CaseControl 1"PCR positive" 0"PCR negative"
label values CaseControl CaseControl
gen CaseControlBA1=1 if BA1==1 &  PCRresult==1
replace CaseControlBA1=0 if PCRresult==0
label define CaseControlBA1 1"BA1 positive" 0"PCR negative"
label values CaseControlBA1 CaseControlBA1
gen CaseControlBA2=1 if BA2==1 &  PCRresult==1
replace CaseControlBA2=0 if PCRresult==0
label define CaseControlBA2 1"BA2 positive" 0"PCR negative"
label values CaseControlBA2 CaseControlBA2
merge 1:1 id using Vaccine
drop if _merge==2
save Analysis, replace
ccmatch Sex Age Nationality ReasonforPCRTesting WeekInterval, cc(CaseControl) id(id)
keep if match~=.
tab CaseControl
bys CaseControl: summ Age, detail
stddiff Age, by(CaseControl)
tab AgeR10 CaseControl
tab AgeR10 CaseControl, col nofreq
stddiff i.AgeR10, by(CaseControl)
tab Sex CaseControl, col chi2
stddiff i.Sex, by(CaseControl)
tab Nationality CaseControl
tab Nationality CaseControl, col nofreq
stddiff i.Nationality, by(CaseControl)
tab Nationality if CaseControl==1 
tab Nationality if CaseControl==0 
tab CaseControl Vaccination
clogit CaseControl i.Vaccination, group(match) or
di 1-OR
clear all
use Analysis
ccmatch Sex Age Nationality ReasonforPCRTesting WeekInterval, cc(CaseControlBA1) id(id)
keep if match~=.
tab CaseControlBA1
bys CaseControlBA1: summ Age, detail
stddiff Age, by(CaseControlBA1)
tab AgeR10 CaseControlBA1
tab AgeR10 CaseControlBA1, col nofreq
stddiff i.AgeR10, by(CaseControlBA1)
tab Sex CaseControlBA1, col chi2
stddiff i.Sex, by(CaseControlBA1)
tab Nationality CaseControlBA1
tab Nationality CaseControlBA1, col nofreq
stddiff i.Natr2, by(CaseControlBA1)
tab Nationality if CaseControlBA1==1 
tab Nationality if CaseControlBA1==0 
tab CaseControlBA1 Vaccination
clogit CaseControlBA1 i.Vaccination, group(match) or
di 1-OR
clear all
use Analysis
ccmatch Sex Age Nationality ReasonforPCRTesting WeekInterval, cc(CaseControlBA2) id(id)
keep if match~=.
tab CaseControlBA2
bys CaseControlBA2: summ Age, detail
stddiff Age, by(CaseControlBA2)
tab AgeR10 CaseControlBA2
tab AgeR10 CaseControlBA2, col nofreq
stddiff i.AgeR10, by(CaseControlBA2)
tab Sex CaseControlBA2, col chi2
stddiff i.Sex, by(CaseControlBA2)
tab Nationality CaseControlBA2
tab Nationality CaseControlBA2, col nofreq
stddiff i.Nationality, by(CaseControlBA2)
tab Nationality if CaseControlBA2==1 
tab Nationality if CaseControlBA2==0 
tab CaseControlBA2 Vaccination
clogit CaseControlBA2 i.Vaccination, group(match) or
di 1-OR
clear all





