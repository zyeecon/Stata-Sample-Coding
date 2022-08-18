cd "C:\zye_labor"
use "ASEC_2019_Data", clear
log using zye_labor, replace

gen agesq = a_age^2 
gen nonlainc = (htotval- pearnval)/1000
gen avbeftaxwage = pearnval/annhrs
gen avafttaxwage = (pearnval/annhrs)*(100-frate -srate -ficar)/100
replace avbeftaxwage=0 if avbeftaxwage==.
replace avafttaxwage=0 if avafttaxwage==.

tabulate gereg, gen (geo)
rename geo1 N_East
rename geo2 Midwest
rename geo3 South
gen worker = 1
replace worker = 0 if annhrs <=0

***Q 1***
global edu "hhs somecollege collegemore"
global race "black other hispanic"
global marital "nevmar widdivsep"
global geo "N_East Midwest South"
global state "tanf_3ppl povrate governor refundable_EITC minwage"
global demographics "a_age agesq $edu $marital $geo $race totchild13" 

save _temp, replace
bys female: sum avbeftaxwage avafttaxwage annhrs worker disability h_numper $demographics [aweight=marsupwt] 

***Q 2***
putpdf clear
putpdf begin

probit worker disability urate nonlainc h_numper $demographics $state [pw=marsupwt], robust
estimates store result1
putpdf table q2a = etable
test _b[urate] =_b[tanf_3ppl] =_b[povrate] =_b[governor] =_b[refundable_EITC] =_b[minwage] =0

putpdf save Q2.pdf, replace

***Q 3***
estimates restore result1

predict probitxb, xb
ge pdf = normalden(probitxb)
ge cdf = normal(probitxb)
ge imr = pdf/cdf
sum imr, d

keep if worker == 1

putpdf clear
putpdf begin
reg avbeftaxwage nonlainc urate $state $demographics disability imr, r
putpdf table q3a = etable
putpdf save Q3.pdf, replace
test _b[imr] = 0
predict double resid, residuals

***Q 4***
putpdf clear
putpdf begin

reg annhrs $demographics avbeftaxwage nonlainc urate resid imr disability, r
putpdf table q4a = etable
putpdf save Q4.pdf, replace
test _b[imr] = 0
test _b[resid] = 0

summarize avbeftaxwage annhrs nonlainc
reg annhrs $demographics disability avbeftaxwage nonlainc urate resid, r
reg annhrs $demographics disability avbeftaxwage nonlainc urate imr, r

***Part 2

use "mom.dta", clear


***1
sum lnhr lnwg kids agsq age disab year

**2a
reg lnhr lnwg kids age agsq disab year

**2b
xtset id year
xtreg lnhr lnwg kids age agsq disab year, re
 estimates store random
**2c
xtreg lnhr lnwg kids age agsq disab year, fe
 estimates store fixed
 hausman fixed random, sigmamore

**2d
gen hrdif= lnhr[_n]- lnhr[_n-1]
gen wgdif= lnwg[_n]- lnwg[_n-1]
reg hrdif kids age agsq disab i.year wgdif
// reg D.( lnhr kids disab lnwg ) i.year, nocons
******2e
xtivreg hrdif kids year (wgdif= age agsq disab)

log close
