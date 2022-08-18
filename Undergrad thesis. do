**b3b_kk3: Individual physical health conditions
use ".\data\hh14_b3b_dta\b3b_kk3.dta", replace
**drop variables we don't need
drop wilcah3b version module
**This has 787957 rows, 23 rows per 34259 pidlinks
**each of the 23 rows is a question (kk3type) with coresponding answer kk03
reshape wide kk03, i(pidlink)  j(kk3type) string
sum kk03A
**n = 34259 unique pidlink's
save "WIDE_b3b_kk3.dta", replace

**b3b_kp: Individual mental health conditions
use ".\data\hh14_b3b_dta\b3b_kp.dta", replace
**drop variables we don't need
drop version module
**This has 314470 rows, 10 rows per 31447 pidlinks
**each of the 10 rows is a question (kptype) with coresponding answer kp02
reshape wide kp02, i(pidlink)  j(kptype) string
sum kp02A
**n = 31447 unique pidlink's
save "WIDE_b3b_kp.dta",replace


**bk_ar1: Individual demographics
use ".\data\hh14_bk_dta\bk_ar1.dta", replace
**ar01a: ("Still living in HH"
**	Drop if
**	  0 (Dead)
**	  3 ("No", meaning they aren't living in HH)
**	  6 (Not sure, but none of them have any demographic data anyway)
**	Keep if
**    1 ("Yes, HHM is still in HH" So they were surveyed before but are still in the same HH))
**    2 ("Yes, HHM was in other IFLS HH in previous wave"…but the "Yes' means this is where they're living, so keep them...we're not quite sure what this is, but that seems to be the right choice)
**    5 ("New HHM"…so newborn or new to survey)
**    11 ("HHM returns in current wage", so they were in HH, then were in a different HH, but they're back)
drop if ar01a == 0 | ar01a == 3 | ar01a == 6
**This leaves 8 humans (piklink) that have 2 rows
**  we're not sure why, so drop these 16 rows
bysort pidlink: gen cntForDrop=_N
drop if cntForDrop > 1
**Keep variables
** ID info: hhid14_9 pid14 hhid14 pidlink
**  ar13: Marital status
**  ar17: Highest grade completed by HHM
**  ar18c: Is HHM still in school?
**  ar07: Sex
**  ar09: Age now
keep hhid14_9 pid14 hhid14 pidlink ar13 ar17 ar18c ar07 ar09
sum ar09
**n = 58296 unique pidlink's


**b3b_kk1: Individual Health Conditions (SRH)
merge 1:1 pidlink using ".\data\hh14_b3b_dta\b3b_kk1.dta"
**b3b_kk1 has 34271 pidlinks
**6 don't match, so we keep 34265
keep if _merge==3
**keep variables
**  kk01: Generally how is your health?
**drop all other new variables
drop kk02ax kk02a kk02bx kk02b kk02i kk02k kk02l version module _merge
sum kk01
**n = 34265 unique pidlink's


**b3b_eh: Individual Early Health 
merge 1:1 pidlink using ".\data\hh14_b3b_dta\b3b_eh.dta"
**b3b_eh has 331471 pidlinks
**4 don't match, so we keep 31467
keep if _merge==3
**keep variables
**  eh01: Would you say that your health during your childhood was...
**drop all other new variables
drop eh02 eh03 eh04 eh05 eh06 eh07 eh08 eh09 version module _merge
sum eh01
**n = 31471 unique pidlink's


**WIDE_b3b_kk3: Individual physical health conditions
merge 1:1 pidlink using "WIDE_b3b_kk3.dta"
**WIDE_b3b_kk3 has 34259 pidlinks
**2804 don't match, and 12 pidlinks in master are not in WIDE_b3b_kk3, so we keep 31455
keep if _merge==3
**keep all variables except _merge 
drop _merge
sum pid14
**n = 31455 unique pidlink's



**WIDE_b3b_kp: Individual mental health conditions
merge 1:1 pidlink using "WIDE_b3b_kp.dta"
**WIDE_b3b_kk3 has 31447 pidlinks
**4 don't match, and 12 pidlinks in master are not in WIDE_b3b_kp, so we keep 31443
keep if _merge==3
**keep all variables except _merge 
drop _merge
sum pid14
**n = 31443 unique pidlink's




**bk_sc1: Household-level village, county, province
merge m:1 hhid14_9 using ".\data\hh14_bk_dta\bk_sc1.dta"
**bk_sc1 has 15921 HHs
**master has 14713 HHs and 31443 pidlinks
**all match in bk_sc1, but 1208 hhid14_9's in master are not in bk_sc1, so we keep 31443 pids
keep if _merge==3
**drop 
**  sc10 sc12 sc13 sc14 sc15 sc21x sc21, which are info about interviewer and migration
**  version module _merge, which we also don't need
drop sc10 sc12 sc13 sc14 sc15 sc21x sc21 version module _merge
**Create ID for village
gen villageID = string(sc01_14_14,"%02.0f") + "_" + string(sc02_14_14,"%02.0f") + "_" + string(sc03_14_14,"%02.0f")
sum pid14
**n = 31443 unique pidlink's


**Average kk01 (SHM) for others in HH and others in village
**create kk01_HHsum = sum of kk01 for all pid's in a hhid14_9
** egen creates total for all pid's in that hhid14_19
** gen creates running total in order for each pid in the hhid14_19
** so we want egen
bysort hhid14_9: egen kk01_HHsum = sum(kk01)
**create HHcnt = # pid's in hhid14_9
bysort hhid14_9: egen HHcnt = count(kk01)
**Average kk01 in HH excluding respondant
gen srh_avgHH = (kk01_HHsum-kk01)/(HHcnt-1)

**4068 HH only have 1 person, so those 4068 are missing (leaving 27375 with this new var)

**create male dummy from sex variable
**  ar07 = 1 if male, 3 if female
gen male = ar07
replace male=0 if ar07==3
label var male "1 if male (ar07==1), 0 if female (ar07==3)"

**create variable for years of school
** ar17 == 0 is "Did not finish 1st grade"
** ar17 == 96 is "No School"
** set "No School" same as "did not finish 1st grade",
** ar17 == 98 is "Don't know" so Drop these 
gen yearsEdu = ar17
replace yearsEdu = 0 if ar17==96
replace yearsEdu = . if ar17==98
label var yearsEdu "years of education from 0 - 7, 7 means 'Graduate'"
gen ayearSRH= kk02c
label values ayearSRH kk02c
gen childhood= eh01
label values childhood eh01

**create kk01_VillageSum = sum of kk01 for all HHs in village (so, sum the HH sums)
bysort villageID: egen kk01_VillageSum = sum(kk01)
**create Villagecnt = # HH's in villageID
bysort villageID: egen villageCnt = count(kk01)
**Average kk01 in village excluding respondant's HH
gen srh_avgVillage = (kk01_VillageSum - kk01_HHsum)/( villageCnt- HHcnt)
*1202 missing values generated)
**260 villages only have 1 HH, so those 265 are missing (leaving 14713 HHs with a total of 31178 PID's with this new var)
bysort villageID:egen villagesumpail=sum( kk03A)
bysort villageID:egen cntvillagepail= count (kk03A)
bysort hhid14_9: egen hhsumpail=sum (kk03A)
bysort hhid14_9:egen cnthhpail=count (kk03A)
gen pail_avgvillage= (villagesumpail-hhsumpail)/(cntvillagepail-cnthhpail)
bysort villageID:egen villagesumkilometers=sum( kk03C)
bysort villageID:egen cntvillagekilometers= count (kk03C)
bysort hhid14_9: egen hhsumkilometers=sum (kk03C)
bysort hhid14_9:egen cnthhkilometers=count (kk03C)
gen kilometers_avgvillage= (villagesumkilometers-hhsumkilometers)/(cntvillagekilometers-cnthhkilometers)
bysort villageID:egen villagebothersum=sum( kp02A)
bysort villageID:egen cntvillagebother= count (kp02A)
bysort hhid14_9: egen hhsumbother=sum (kp02A)
bysort hhid14_9:egen cnthhbother=count (kp02A)
gen bother_avgvillage= (villagebothersum-hhsumbother)/(cntvillagebother-cnthhbother)
bysort villageID:egen villageconcentratesum=sum( kp02B)
bysort villageID:egen cntvillageconcentrate= count (kp02B)
bysort hhid14_9: egen hhsumconcentrate=sum (kp02B)
bysort hhid14_9:egen cnthhconcentrate=count (kp02B)
gen concentrates_avgvillage= (villageconcentratesum-hhsumconcentrate)/(cntvillageconcentrate-cnthhconcentrate)
bysort hhid14_9: egen pail_HHsum = sum(kk03A)
bysort hhid14_9: egen HHcnt1 = count(kk03A)
gen pail_avgHH = (pail_HHsum-kk03A)/(HHcnt-1)
bysort hhid14_9: egen kilometers_HHsum = sum(kk03C)
bysort hhid14_9: egen HHcnt2 = count(kk03C)
gen kilometers_avgHH = (kilometers_HHsum-kk03C)/(HHcnt2-1)
bysort hhid14_9: egen bother_HHsum = sum(kp02A)
bysort hhid14_9: egen HHcnt3 = count(kp02A)
gen bother_avgHH = (bother_HHsum-kp02A)/(HHcnt3-1)
bysort hhid14_9: egen concentrate_HHsum = sum(kp02B)
bysort hhid14_9: egen HHcnt4 = count(kp02B)
gen concentrates_avgHH = (concentrate_HHsum-kp02B)/(HHcnt4-1)
drop cnthhkilometers hhsumkilometers villagesumkilometers cntvillagekilometers cnthhpail hhsumpail cntvillagepail villagesumpail villageCnt kk01_VillageSum  kk01_HHsum HHcnt villagebothersum cntvillagebother hhsumbother cnthhbother villageconcentratesum cntvillageconcentrate hhsumconcentrate cnthhconcentrate pail_HHsum HHcnt1 kilometers_HHsum HHcnt2 bother_HHsum HHcnt3 concentrate_HHsum HHcnt4


label var kk03A "carry a heavy load (like a pail of water) for 20 meters"
label var kk03D "draw a pail of water from a well"
label var kk03J "walk for 1 kilometer"
label var kk03C "walk for 5 kilometers"
label var kk03B "sweep the house floor yard"
label var kk03E "bow, squat, kneel"
label var kk03L "walk across the room"
label var kk03I "stand up from sitting on the floor without help"
label var kk03G "stand up from sitting position in a chair without help"
label var kk03EA "reach or extend your arms above shoulder level"
label var kk03EB "pick up a small coin from a table"
label var kk03F "dress without help"
label var kk03M "bathe"
label var kk03K "get out of bed"
label var kk03KA "eat  (eating food by oneself when it is ready)"
label var kk03KC "control urination or defecation"
label var kk03N "shop for personal needs"
label var kk03O "prepare hot meals (preparing ingredients, cooking, and serving food)"
label var kk03P "take medicine (taking right portion right on time)"
label var kk03PA "do household chores"
label var kk03PB "shop for groceries (deciding what to buy and pay for it)"
label var kk03PC "manage your money"

label var kp02A "was bothered by things that usually don’t bother me"
label var kp02B "had trouble concentrating in what I was doing"
label var kp02C "felt depressed"
label var kp02D "felt everything I did was an effort"
label var kp02E "felt hopeful about the future"
label var kp02F "felt fearful"
label var kp02G "sleep was restless"
label var kp02H "was happy"
label var kp02I "felt lonely"
label var kp02J "could not get going"

label var srh_avgHH "Ave-SRH of household, excluding respondent"
label var srh_avgVillage"Ave-SRH of community, excluding respondent"
label var villageID "community ID number"
label var pail_avgvillage "Ave_Pail of Water of the village, excluding respondent himself"
label var kilometers_avgvillage "Ave_Five Kilometers of the Village, excluding respondent himself"
label var ayearSRH "Compare yourself a year ago, would you say you health is..."
label var childhood "would you say your childhood health is..."
label var bother_avgvillage "Average_I was bother by things that do not bother me, excluding respondent"
label var concentrates_avgvillage "Avg_Concentratrating in what I was doing, excluding respondent"
label var pail_avgHH "HH average rating of how hard to carry a pail of water, excluding respondent"
label var kilometers_avgHH "HH average rating of how hard to walk for five kilometers, excluding respondent"
label var bother_avgHH "HH average rating of bother by things that usually don't bother me, excluding respondent"
label var concentrates_avgHH "HH average rating of had trouble concentrating in what I was doing, excluding respondent"


**Tell stata where to find (and install) packages (e.g., eststo, esttab)
sysdir set PLUS "U:\Class_Share\Economics\Econ_Packages_Stata"

gen pail=kk03A
gen kilometers= kk03C
label values pail kk03
label values kilometers kk03

gen bother=kp02A
gen concentrates= kp02B
label values bother kp02
label values concentrates kp02

label var pail "carry a pail of water for 20 meters"
label var kilometers "walk for 5 kilometers"
label var bother "I was bother by things that ususally don't bother me"
label var concentrates "Had trouble concentrating in that I was doing"
gen SRHIndividual = kk01
label values SRHIndividual kk01
label var SRHIndividual "SRH ratings of each individuals"
gen age=ar09
label var age "age now"

bysort hhid14_9: egen age_HHsum = sum(age)
bysort hhid14_9: egen agecnt = count(age)
gen age_avgHH =  age_HHsum/agecnt
drop age_HHsum agecnt
label var age_avgHH "average age of the household"

gen agesq=age^2

save "agehousehold.dta", replace
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH concentrates concentrates_avgHH concentrates_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH concentrates srh_avgHH concentrates_avgHH srh_avgVillage concentrates_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates pail_avgHH concentrates_avgHH pail_avgvillage concentrates_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates srh_avgHH pail_avgHH concentrates_avgHH srh_avgVillage pail_avgvillage concentrates_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother kilometers_avgHH bother_avgHH kilometers_avgvillage bother_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother srh_avgHH kilometers_avgHH bother_avgHH srh_avgVillage kilometers_avgvillage bother_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates kilometers_avgHH concentrates_avgHH kilometers_avgvillage concentrates_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates srh_avgHH kilometers_avgHH concentrates_avgHH srh_avgVillage kilometers_avgvillage concentrates_avgvillage if age>=40, robust
esttab using result0227.csv, p star(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace
est clear

quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH concentrates concentrates_avgHH concentrates_avgvillage yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH concentrates srh_avgHH concentrates_avgHH srh_avgVillage concentrates_avgvillage yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates pail_avgHH concentrates_avgHH pail_avgvillage concentrates_avgvillage yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates srh_avgHH pail_avgHH concentrates_avgHH srh_avgVillage pail_avgvillage concentrates_avgvillage yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother kilometers_avgHH bother_avgHH kilometers_avgvillage bother_avgvillage yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother srh_avgHH kilometers_avgHH bother_avgHH srh_avgVillage kilometers_avgvillage bother_avgvillage yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates kilometers_avgHH concentrates_avgHH kilometers_avgvillage concentrates_avgvillage yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates srh_avgHH kilometers_avgHH concentrates_avgHH srh_avgVillage kilometers_avgvillage concentrates_avgvillage yearsEdu if age>=40, robust
esttab using result0227edu.csv, p star(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace
est clear

quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH concentrates concentrates_avgHH concentrates_avgvillage yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH concentrates srh_avgHH concentrates_avgHH srh_avgVillage concentrates_avgvillage i.yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates pail_avgHH concentrates_avgHH pail_avgvillage concentrates_avgvillage i.yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates srh_avgHH pail_avgHH concentrates_avgHH srh_avgVillage pail_avgvillage concentrates_avgvillage i.yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother kilometers_avgHH bother_avgHH kilometers_avgvillage bother_avgvillage i.yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother srh_avgHH kilometers_avgHH bother_avgHH srh_avgVillage kilometers_avgvillage bother_avgvillage i.yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates kilometers_avgHH concentrates_avgHH kilometers_avgvillage concentrates_avgvillage i.yearsEdu if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates srh_avgHH kilometers_avgHH concentrates_avgHH srh_avgVillage kilometers_avgvillage concentrates_avgvillage i.yearsEdu if age>=40, robust
esttab using result0227edui.csv, p star(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace
est clear

quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH concentrates concentrates_avgHH concentrates_avgvillage i.yearsEdu age if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH concentrates srh_avgHH concentrates_avgHH srh_avgVillage concentrates_avgvillage i.yearsEdu age if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates pail_avgHH concentrates_avgHH pail_avgvillage concentrates_avgvillage i.yearsEdu age if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates srh_avgHH pail_avgHH concentrates_avgHH srh_avgVillage pail_avgvillage concentrates_avgvillage i.yearsEdu age if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother kilometers_avgHH bother_avgHH kilometers_avgvillage bother_avgvillage i.yearsEdu age if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother srh_avgHH kilometers_avgHH bother_avgHH srh_avgVillage kilometers_avgvillage bother_avgvillage i.yearsEdu age if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates kilometers_avgHH concentrates_avgHH kilometers_avgvillage concentrates_avgvillage i.yearsEdu age if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates srh_avgHH kilometers_avgHH concentrates_avgHH srh_avgVillage kilometers_avgvillage concentrates_avgvillage i.yearsEdu age if age>=40, robust
esttab using result0227eduiAgecsv, p star(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace
est clear

quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates pail_avgHH concentrates_avgHH pail_avgvillage concentrates_avgvillage i.yearsEdu age agesq if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates srh_avgHH pail_avgHH concentrates_avgHH srh_avgVillage pail_avgvillage concentrates_avgvillage i.yearsEdu age agesq if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH  childhood ayearSRH i.yearsEdu age pail pail_avgHH pail_avgvillage bother bother_avgHH bother_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH  childhood ayearSRH i.yearsEdu age srh_avgHH srh_avgVillage pail pail_avgHH pail_avgvillage bother bother_avgHH bother_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates kilometers_avgHH concentrates_avgHH kilometers_avgvillage concentrates_avgvillage i.yearsEdu age agesq if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates srh_avgHH kilometers_avgHH concentrates_avgHH srh_avgVillage kilometers_avgvillage concentrates_avgvillage i.yearsEdu age agesq if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother kilometers_avgHH bother_avgHH kilometers_avgvillage bother_avgvillage i.yearsEdu age agesq if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother srh_avgHH kilometers_avgHH bother_avgHH srh_avgVillage kilometers_avgvillage bother_avgvillage i.yearsEdu age agesq if age>=40, robust
est clear


gen age65plus = (age>=65)
replace age65plus = . if missing(age)
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates pail_avgHH concentrates_avgHH pail_avgvillage concentrates_avgvillage yearsEdu age agesq age65plus if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH pail concentrates srh_avgHH pail_avgHH concentrates_avgHH srh_avgVillage pail_avgvillage concentrates_avgvillage yearsEdu age agesq age65plus if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH  childhood ayearSRH yearsEdu age agesq age65plus pail pail_avgHH pail_avgvillage bother bother_avgHH bother_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH  childhood ayearSRH yearsEdu age agesq age65plus srh_avgHH srh_avgVillage pail pail_avgHH pail_avgvillage bother bother_avgHH bother_avgvillage if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates kilometers_avgHH concentrates_avgHH kilometers_avgvillage concentrates_avgvillage yearsEdu age agesq age65plus if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers concentrates srh_avgHH kilometers_avgHH concentrates_avgHH srh_avgVillage kilometers_avgvillage concentrates_avgvillage yearsEdu age agesq age65plus if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother kilometers_avgHH bother_avgHH kilometers_avgvillage bother_avgvillage yearsEdu age agesq age65plus if age>=40, robust
quietly eststo: reg SRHIndividual  male age_avgHH childhood ayearSRH kilometers bother srh_avgHH kilometers_avgHH bother_avgHH srh_avgVillage kilometers_avgvillage bother_avgvillage yearsEdu age agesq age65plus if age>=40, robust
esttab using ageplus.csv, p star(* 0.1 ** 0.05 *** 0.01) r2 ar2 replace
