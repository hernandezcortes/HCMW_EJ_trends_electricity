# HCMW_EJ_trends_electricity
Replication files and repository for the paper "Decomposing Trends in U.S. Air Pollution Disparities from Electricity" by Danae Hernandez-Cortes, Kyle C. Meng, and Paige Weber. Full manuscript can be found in https://www.nber.org/papers/w30198.

The dataset census_tract_year_pm25_from_electricity.dta contains census tract level data for 2000-2018 with the following variables:

```
gisjoin: census tract ID.

year: calendar year.

totalpm25: PM2.5 concentrations from all electricity generating units in our sample.

median_income: median real income at the census tract level from the ACS.

minority_pct: percent of non-White population at the census tract level from the ACS.

black_pct: percent of Black population at the census tract level from the ACS.

hispanic_pct: percent of Hispanic population at the census tract level from the ACS.

total_pop: 2000-2018 average total population at the census tract level from the ACS.

fuel: "all" which denotes that the emissions come from all the facilities, regardless of the fuel used.
```

The do file HCMW_figure4_replication.do uses the census_tract_year_pm25_from_electricity.dta dataset to replicate Figure 4 of the manuscript.
