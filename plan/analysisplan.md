Plan
====

topic
-----
Global aviation safety

dataset
-------
* airplane crashes from 1908 to 2019
* accessed from kaggle https://www.kaggle.com/datasets/saurograndi/airplane-crashes-since-1908?resource=download on 25/11/2025
* dataset originally from Open Data by Soctrata
* unclear exactly how the dataset was compiled
* appears to not be updated past 2009
* is most likely *not complete*
* coverage is biased towards the US and Europe. There is little coverage of, for example, crashes in Africa, Asia, the Soviet union, etc
* coverage cannot include crashes that happen as part of classified activity, such as covert military operations
* only includes crash data from incidents where there were fatalities recorded

research question
-----------------
Bad weather is one of the strongest predictors of aviation accidents historically, especially when flights happen in the reduced visibility of night. In addition, certain precarious weather conditions are more common at specific times of day, for example thunderstorms are most prominent in the late afternoon. Seasonal effects like pilots overtired during peak travel periods such as christmas may also modulate the likelihood of an airplane crash, and finally, over the years of the past century the frequency of flights has increased drammatically, as well as the technology used to ensure safety in the airs. We propose that there should exist correlation between the time of day of a crash and its geographical location, but only once the effects of climate, season, and year have been properly accounted for. 

Our research question is the following:

> Does the distribution of the time of day of plane crashes vary systematically with the geographic region of the crash?

We use the covariates of season and year to ensure we are probing this relationship clearly, and we define geographic region as the Koppen climate groups to account for the hypothesis that historically crash risk is most significantly influenced by weather conditions. 

model proposed
--------------
model: circular regression model
dependent variable: "time of day of crash"
independent variables: "koppen region of crash location", "year", "season"

data transformations
* map crash location to a koppen glimate group
* split crash date into season (nominal) and year (integer)
* no normalization of the time-of-day variable
* normalize the year variable following log(2020 - year)
* need to be careful - season is location dependent! I need to map this too. It cant be determined using months alone

missing data imputation
-----------------------
we plan to use random forest in R

assessment of potential bias
----------------------------
* regional biases - US and Europe are heavily over-represented
* Africa, Asia, the soviet union, etc not well represented
* potentially thousands of known crashes are missing
* military missions typically are classified, and so crashes happening as part of these missions are not present
* temporal biases too - record keeping has improved over the years spanned by the data set
* technology has also improved over the years - new records more likely to have accurate information on crash time and location than older ones
* potential for governments to downplay the number of crashes, or fatalities for a crash, as a means to cover up bureaucratic failures for example
* the potential for government distortion is particularly important for countries and periods where the government was overly controlling, careful, and less globally cooperative, as can happen in times of war, economic depression, or dictatorship (for example communism or facisism). 

workflow
--------

### clean
1. rename variables if necessary
2. cast all missing data as NA
3. convert each variable into the correct type
4. drop problematic rows
5. select useful columns

### transform

### impute

### model