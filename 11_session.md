---
layout: lesson
title: "Session 11"
output: markdown_document
---

## Topics
* Developing questions and finding data
* Getting familiar with and focusing on data
* Working with spreadsheets
* Joining data frames together




## Developing questions and finding data

In the previous lessons I've given you data without much explanation for how I found the data. Of course, for many, you will be generating data through a survey you deploy or with an experiment you are conducting. Reading a paper, news story, or listening to a podcast never satisfies my curiosity. I want to play with the data to answer my own variation on a question. My general strategy of finding data, frankly, is to use google with words like "download" or "raw data". For example, "temperature raw data" will get you pretty close to the site that I got our Ann Arbor data from.

I have been working on a project that is asking how well women are represented in scientific publishing and as gate keepers throughout peer review. This analysis got me to thinking about how well women and other groups are represented at various levels of training. I also wondered how that representation varies by discipline. Thinking about these types of questions, my ears perked up when I heard of a service on my campus that quantifies what the demographic pool of applicants for faculty positions should look like based on the representation of various groups amongst its trainees.

To answer these types of questions, for the next few sessions we are going to look at data collected by the National Center for Education Statistics at the US Department of Education. They maintain the [Integrated Postsecondary Education Data System (IPEDS)](https://nces.ed.gov/ipeds/), which houses a number of surveys on higher education. This is an amazingly rich dataset that we'll use to explore some questions. According to their website, "Institutions submit data through 12 interrelated survey components about general higher education topics for 3 reporting periods." I have provided you a subset of the data as "csv" files in the `ipeds` directory along with the data dictionaries. These dictionaries explain the column names and codes used in the two csv files. If you go to their ["Use the Data"](https://nces.ed.gov/ipeds/use-the-data) page, on the right side of the page there is a heading "Survey Data" with a drop down menu. In the drop down menu select, "Complete Data Files". In the next page you can leave the default choices of "All years" and "All surveys" and then press "Continue". On this page you'll see the 12 surveys for each year going back to 1980. As I've found, the surveys change over time as do how the data are reported and recorded. To avoid wrangling data across years, we'll work with data that was reported for 2018.


## Getting familiar with and focusing on data

Again, there are *many* questions we could try to answer with these data. I'm going to focus on degrees granted in 2018 by field across institutions. By looking through the files, I decided that I was most interested in "Institutional Characteristics	Directory information" and "Completions	Awards/degrees conferred by program (6-digit CIP code), award level, race/ethnicity, and gender: July 1, 2017 to June 30, 2018". These files are in the `ipeds` directory as `c2018.csv`/`c2018.xlsx` and `hd2018.csv`/`hd2018.xlsx`, respectively. The csv files contain the data and the xlsx files contain the data dictionary for each csv file. We'll start by loading the `tidyverse` package and reading in the `c2018_a` csv file as the `degrees` data frame.


```r
library(tidyverse)
degrees <- read_csv("ipeds/c2018_a.csv")
degrees
```

```
## # A tibble: 290,119 x 64
##    UNITID CIPCODE MAJORNUM AWLEVEL XCTOTALT CTOTALT XCTOTALM CTOTALM XCTOTALW
##     <dbl> <chr>      <dbl> <chr>   <chr>      <dbl> <chr>      <dbl> <chr>   
##  1 100654 01.0999        1 05      R              5 Z              0 R       
##  2 100654 01.1001        1 05      R              9 R              2 R       
##  3 100654 01.1001        1 07      R              5 R              1 R       
##  4 100654 01.1001        1 17      R              1 R              1 Z       
##  5 100654 01.9999        1 05      R              6 R              1 R       
##  6 100654 01.9999        1 07      R              7 R              2 R       
##  7 100654 01.9999        1 17      R              1 Z              0 R       
##  8 100654 03.0599        1 05      R             12 R             11 R       
##  9 100654 04.0301        1 05      R              2 Z              0 R       
## 10 100654 04.0301        1 07      R             11 R              7 R       
## # … with 290,109 more rows, and 55 more variables: CTOTALW <dbl>,
## #   XCAIANT <chr>, CAIANT <dbl>, XCAIANM <chr>, CAIANM <dbl>, XCAIANW <chr>,
## #   CAIANW <dbl>, XCASIAT <chr>, CASIAT <dbl>, XCASIAM <chr>, CASIAM <dbl>,
## #   XCASIAW <chr>, CASIAW <dbl>, XCBKAAT <chr>, CBKAAT <dbl>, XCBKAAM <chr>,
## #   CBKAAM <dbl>, XCBKAAW <chr>, CBKAAW <dbl>, XCHISPT <chr>, CHISPT <dbl>,
## #   XCHISPM <chr>, CHISPM <dbl>, XCHISPW <chr>, CHISPW <dbl>, XCNHPIT <chr>,
## #   CNHPIT <dbl>, XCNHPIM <chr>, CNHPIM <dbl>, XCNHPIW <chr>, CNHPIW <dbl>,
## #   XCWHITT <chr>, CWHITT <dbl>, XCWHITM <chr>, CWHITM <dbl>, XCWHITW <chr>,
## #   CWHITW <dbl>, XC2MORT <chr>, C2MORT <dbl>, XC2MORM <chr>, C2MORM <dbl>,
## #   XC2MORW <chr>, C2MORW <dbl>, XCUNKNT <chr>, CUNKNT <dbl>, XCUNKNM <chr>,
## #   CUNKNM <dbl>, XCUNKNW <chr>, CUNKNW <dbl>, XCNRALT <chr>, CNRALT <dbl>,
## #   XCNRALM <chr>, CNRALM <dbl>, XCNRALW <chr>, CNRALW <dbl>
```

Ugh, those column names!

`ipeds/c2018_a.xlsx` contains the data dictionary. Open it up in Excel, it has different pages that tell you what the column names mean and what the various values are. For example, the "varlist" and "Description" tabs tell us that "UNITID" tells us the "Unique identification number of the institution". It also tells us that "CIPCODE" is the "CIP Code -  2010 Classification" and that "AWLEVEL" is the "Award Level code". If we want to know the values that correspond to each CIP or Award Level codes, we need to look at the "Frequencies" tab. We see that the first 1426 rows of the "Frequencies" tab are different CIP codes. These correspond to different "majors". Below the CIP codes, we see entries for "MAJORNUM" and "AWLEVEL". Cool - I'd like to look at the 2018 awards data for the University of Michigan. Which "UNITID" corresponds to the University of Michigan or any other university? That "decoder" isn't in this workbook.

If you do some digging on the page where we saw the "C2018_A" data, at the top of the page you'll find "HD2018". The description for this survey is "Institutional Characteristics,	Directory information". Those data and the data dictionary are provided for you in `ipeds/`. Opening `ipeds/hd2018.xlsx` in Microsoft Excel and clicking on the "varlist" or "Description" tab show us that this survey will give us the mapping between "UNITID" and the institution name or "INSTNM". Now, let's open `ipeds/hd2018.csv` in Excel. You can do this by doing "File -> Open..." and browsing to `ipeds/hd2018.csv`. We can then click on the "Edit" menu and click on "Find". In the dialog window that opens, enter "University of Michigan" and press the return key. You'll see that the "University of Michigan-Ann Arbor"'s "UNITID" is "170976".

Now we want to pull all of the rows from the `degrees` data frame that correspond to that `UNITID` value. Remember how to do that?


```r
degrees %>%
	filter(UNITID == 170976)
```

```
## # A tibble: 570 x 64
##    UNITID CIPCODE MAJORNUM AWLEVEL XCTOTALT CTOTALT XCTOTALM CTOTALM XCTOTALW
##     <dbl> <chr>      <dbl> <chr>   <chr>      <dbl> <chr>      <dbl> <chr>   
##  1 170976 03.0101        1 05      R              0 R              0 Z       
##  2 170976 03.0101        1 07      R            107 R             40 R       
##  3 170976 03.0101        1 17      R              2 R              0 R       
##  4 170976 03.0103        1 05      R             93 R             37 R       
##  5 170976 03.0103        1 06      R              0 R              0 Z       
##  6 170976 03.0103        1 08      R              0 R              0 Z       
##  7 170976 03.0103        2 05      R             20 R              9 R       
##  8 170976 03.0201        1 05      R              0 R              0 Z       
##  9 170976 03.0201        1 06      R              0 R              0 Z       
## 10 170976 03.0201        1 07      R              0 R              0 Z       
## # … with 560 more rows, and 55 more variables: CTOTALW <dbl>, XCAIANT <chr>,
## #   CAIANT <dbl>, XCAIANM <chr>, CAIANM <dbl>, XCAIANW <chr>, CAIANW <dbl>,
## #   XCASIAT <chr>, CASIAT <dbl>, XCASIAM <chr>, CASIAM <dbl>, XCASIAW <chr>,
## #   CASIAW <dbl>, XCBKAAT <chr>, CBKAAT <dbl>, XCBKAAM <chr>, CBKAAM <dbl>,
## #   XCBKAAW <chr>, CBKAAW <dbl>, XCHISPT <chr>, CHISPT <dbl>, XCHISPM <chr>,
## #   CHISPM <dbl>, XCHISPW <chr>, CHISPW <dbl>, XCNHPIT <chr>, CNHPIT <dbl>,
## #   XCNHPIM <chr>, CNHPIM <dbl>, XCNHPIW <chr>, CNHPIW <dbl>, XCWHITT <chr>,
## #   CWHITT <dbl>, XCWHITM <chr>, CWHITM <dbl>, XCWHITW <chr>, CWHITW <dbl>,
## #   XC2MORT <chr>, C2MORT <dbl>, XC2MORM <chr>, C2MORM <dbl>, XC2MORW <chr>,
## #   C2MORW <dbl>, XCUNKNT <chr>, CUNKNT <dbl>, XCUNKNM <chr>, CUNKNM <dbl>,
## #   XCUNKNW <chr>, CUNKNW <dbl>, XCNRALT <chr>, CNRALT <dbl>, XCNRALM <chr>,
## #   CNRALM <dbl>, XCNRALW <chr>, CNRALW <dbl>
```

From that filter, we have winnowed our data frame down to the 570 rows that correspond to the University of Michigan. Each row of this data frame corresponds to a different `CIPCODE`/`MAJORNUM`/`AWLEVEL` combination. To simplify things, let's only look at people's first major. Also, the first CIPCODE - "99" - is a grand total so we don't want to include those data.


```r
degrees %>%
	filter(UNITID == 170976 & MAJORNUM == 1 & CIPCODE != 99)
```

```
## # A tibble: 503 x 64
##    UNITID CIPCODE MAJORNUM AWLEVEL XCTOTALT CTOTALT XCTOTALM CTOTALM XCTOTALW
##     <dbl> <chr>      <dbl> <chr>   <chr>      <dbl> <chr>      <dbl> <chr>   
##  1 170976 03.0101        1 05      R              0 R              0 Z       
##  2 170976 03.0101        1 07      R            107 R             40 R       
##  3 170976 03.0101        1 17      R              2 R              0 R       
##  4 170976 03.0103        1 05      R             93 R             37 R       
##  5 170976 03.0103        1 06      R              0 R              0 Z       
##  6 170976 03.0103        1 08      R              0 R              0 Z       
##  7 170976 03.0201        1 05      R              0 R              0 Z       
##  8 170976 03.0201        1 06      R              0 R              0 Z       
##  9 170976 03.0201        1 07      R              0 R              0 Z       
## 10 170976 03.0201        1 08      R              1 R              1 Z       
## # … with 493 more rows, and 55 more variables: CTOTALW <dbl>, XCAIANT <chr>,
## #   CAIANT <dbl>, XCAIANM <chr>, CAIANM <dbl>, XCAIANW <chr>, CAIANW <dbl>,
## #   XCASIAT <chr>, CASIAT <dbl>, XCASIAM <chr>, CASIAM <dbl>, XCASIAW <chr>,
## #   CASIAW <dbl>, XCBKAAT <chr>, CBKAAT <dbl>, XCBKAAM <chr>, CBKAAM <dbl>,
## #   XCBKAAW <chr>, CBKAAW <dbl>, XCHISPT <chr>, CHISPT <dbl>, XCHISPM <chr>,
## #   CHISPM <dbl>, XCHISPW <chr>, CHISPW <dbl>, XCNHPIT <chr>, CNHPIT <dbl>,
## #   XCNHPIM <chr>, CNHPIM <dbl>, XCNHPIW <chr>, CNHPIW <dbl>, XCWHITT <chr>,
## #   CWHITT <dbl>, XCWHITM <chr>, CWHITM <dbl>, XCWHITW <chr>, CWHITW <dbl>,
## #   XC2MORT <chr>, C2MORT <dbl>, XC2MORM <chr>, C2MORM <dbl>, XC2MORW <chr>,
## #   C2MORW <dbl>, XCUNKNT <chr>, CUNKNT <dbl>, XCUNKNM <chr>, CUNKNM <dbl>,
## #   XCUNKNW <chr>, CUNKNW <dbl>, XCNRALT <chr>, CNRALT <dbl>, XCNRALM <chr>,
## #   CNRALM <dbl>, XCNRALW <chr>, CNRALW <dbl>
```

I'd like to know how many award levels are represented at the University of Michigan and how many majors correspond to each award level. Do you recall how to count the number of times a value appears in a column? We can use the `count` function.


```r
degrees %>%
	filter(UNITID == 170976 & MAJORNUM == 1 & CIPCODE != 99) %>%
	count(AWLEVEL)
```

```
## # A tibble: 6 x 2
##   AWLEVEL     n
##   <chr>   <int>
## 1 05        152
## 2 06         39
## 3 07        153
## 4 08         48
## 5 17        104
## 6 18          7
```

We see that the most common award levels are codes "05", "07", and "17". Reopening `ipeds/c2018_a.xlsx` in Excel, we can turn to the "Frequencies" tab and scroll to the bottom where we see the translation of the "AWLEVEL" codes. These three codes correspond to "Bachelor's degree",
"Master's degree", and "Doctor's degree - research/scholarship", respectively. The university also awards "Postbaccalaureate certificate" (`06`), "Post-master's certificate" (`08`), and "Doctor's degree - professional practice" (`18`). Note that the values in the `n` column of this new data frame are the number of majors that awarded one of these "degree" types in 2018. I'd like to know how many people graduated with these degrees, across all marjors. Hopefully, this is ringing bells in your head and you're thinking about how you can use `group_by` and `summarize`. Before we can use those functions, we need to figure out which column in `degrees` contains the number of students to receive an award. From the data dictionary, we see that "CTOTALT" contains the "Grand total". Let's try that and save it as a variable.


```r
um_degrees <- degrees %>%
	filter(UNITID == 170976 & MAJORNUM == 1 & CIPCODE != 99) %>%
	group_by(AWLEVEL) %>%
	summarize(n_graduates = sum(CTOTALT))
```

The University of Michigan awarded 7,450 Bachelor's degrees, 4,677 Master's degrees, 874 research-based doctorates, and 682 professional doctorates. What we've seen so far in this lesson is a bit of review from what we have done in previous lessons. I don't expect that you could have done these steps on your own, but I hope these steps jogged some memories. Even if the syntax is still hard to master, I hope your mind is swimming with questions to ask with these datasets! How do these numbers break down by gender? Race or ethnicity? Do they vary over year? Which program has the most students? Whoa! We'll get to these but let's see if we can improve upon what we've already done.


## Working with spreadsheets

The first thing I would like to do is automate a few steps. To figure out things like "UNITID" and "AWLEVEL" we have had to flip back and forth to Excel. That's a little cumbersome for a single institution, but if we wanted to compare multiple schools. I'm also struggling to remember the codes for the different awards. I'd like the last data frame we generated showing the number of awards given in 2018 by award type to list the actual award rather than the code. To do this we need to learn two new things: how to read Excel files (those that end in `xlsx`) and how to join two data frames together.

We've seen that the "AWLEVEL" codes are provided in the "Frequencies" tab of `ipeds/c2018_a.xlsx`. We can read in an Excel file using the `read_excel` function from the `readxl` package, which is part of `tidyverse`.


```r
library(readxl)

read_excel("ipeds/c2018_a.xlsx")
```

```
## # A tibble: 14 x 2
##    `File Documentation for the Completi… ...2                                   
##    <chr>                                 <chr>                                  
##  1 (Provisional release)                 <NA>                                   
##  2 <NA>                                  <NA>                                   
##  3 Filename                              C2018_A                                
##  4 <NA>                                  <NA>                                   
##  5 Overview                              This file contains the number of award…
##  6 Note:                                 Preliminary release data have been edi…
##  7 <NA>                                  <NA>                                   
##  8 Contents of spreadsheet               <NA>                                   
##  9 <NA>                                  <NA>                                   
## 10 Varlist                               Variable list: Lists all variables in …
## 11 Description                           Long description or glossary definitio…
## 12 Frequencies                           This worksheet contains the code value…
## 13 Statistics                            This worksheet lists the sum, mean, mi…
## 14 Imputation code values                This worksheet lists the code values f…
```

From the output, you should notice that it read in the first page of the workbook - "Introduction". We'd like the "Frequencies" tab. Can you use `?read_excel` to figure out how to get the "Frequencies" tab?


```r
read_excel("ipeds/c2018_a.xlsx", sheet="Frequencies")
```

```
## # A tibble: 1,438 x 6
##    varnumber varname codevalue valuelabel                      frequency percent
##        <dbl> <chr>   <chr>     <chr>                               <dbl>   <dbl>
##  1     32000 CIPCODE 99        Grand total                         20385    7.03
##  2     32000 CIPCODE 01.0000   Agriculture, General                  249    0.09
##  3     32000 CIPCODE 01.0101   Agricultural Business and Mana…       185    0.06
##  4     32000 CIPCODE 01.0102   Agribusiness/Agricultural Busi…       203    0.07
##  5     32000 CIPCODE 01.0103   Agricultural Economics                121    0.04
##  6     32000 CIPCODE 01.0104   Farm/Farm and Ranch Management         84    0.03
##  7     32000 CIPCODE 01.0105   Agricultural/Farm Supplies Ret…        30    0.01
##  8     32000 CIPCODE 01.0106   Agricultural Business Technolo…        16    0.01
##  9     32000 CIPCODE 01.0199   Agricultural Business and Mana…        24    0.01
## 10     32000 CIPCODE 01.0201   Agricultural Mechanization, Ge…        45    0.02
## # … with 1,428 more rows
```

Cool, eh? There is nothing inherently wrong with using Excel! Many of us find it very useful for recording data and sharing it with others. As you grow in your comfort with R, you may find it is easier to work with the data in R rather than Excel. I'm not really sure how I would do the commands in this lesson in Excel, but they will grow to become straightforward for you in R. An added motivation, is that instead of having to remember your mouse clicks and communicating those to someone else, you can record your R commands in a script to share with a friend or to apply on the 2019 data when they are released.

Let's focus on the rows for the "AWLEVEL", get rid of the extraneous columns, and save it as a new data frame


```r
award_code <- read_excel("ipeds/c2018_a.xlsx", sheet="Frequencies") %>%
	filter(varname == "AWLEVEL") %>%
	select(codevalue, valuelabel)
```

## Joining data frames together

Great! Now we want to join our two data frames. We can do this using a `dplyr` function called `inner_join`. This function expects two data frames that will be merged using either a column name that is in both data frames or that is specified by us. If a value is missing from either data frame is is not retained in the resulting data frame (see `?left_join`, `?right_join`, `?full_join` for how to get other behaviors). For example, assume we have two data frames:


```r
animal_sounds <- tibble(animal = c("cat", "dog", "fish", "pig"),
		sound = c("meow", "bark", "blub", "oink"))
animal_legs <- tibble(animal = c("cat", "chicken", "pig", "fish"),
		n_legs = c(4, 2, 0, 4))

inner_join(animal_sounds, animal_legs)
```

```
## # A tibble: 3 x 3
##   animal sound n_legs
##   <chr>  <chr>  <dbl>
## 1 cat    meow       4
## 2 fish   blub       4
## 3 pig    oink       0
```

In this example, because there is an `animal` column in both data frames, it is used to join the data frames. Here, `inner_join` returns a new data frame with three rows and three columns. You'll see that there's no row for "dog" or "chicken" because those animals were not found in both data frames. You'll also see that we have all three columns represented by the two data frames - `animal`, `sound`, `n_legs`. To see how we join data frames, like ours, where the two data frames don't have a common column between them let's add a third data frame


```r
pats_farm <- tibble(type=c("cat", "dog", "chicken", "pig", "fish"),
		he_has=c(TRUE, TRUE, TRUE, TRUE, FALSE))
```

The `pats_farm` doesn't have an `animal` column, it has a `type` column. We could use `rename` to "fix" `pats_farm`. But we can also leave it is by providing an extra argument to `inner_join`


```r
inner_join(animal_sounds, pats_farm, by=c("animal"="type"))
```

```
## # A tibble: 4 x 3
##   animal sound he_has
##   <chr>  <chr> <lgl> 
## 1 cat    meow  TRUE  
## 2 dog    bark  TRUE  
## 3 fish   blub  FALSE 
## 4 pig    oink  TRUE
```

Note that even in the case where we have a column in common between the data frames, we can tell `inner_join` which we want to join on. This can be helpful if there are multiple columns in common between the data frames and we want to exclude one of them. See if you can see the subtle difference between setting the `by` argument and not in this case


```r
inner_join(animal_sounds, animal_legs, by="animal")
```

```
## # A tibble: 3 x 3
##   animal sound n_legs
##   <chr>  <chr>  <dbl>
## 1 cat    meow       4
## 2 fish   blub       4
## 3 pig    oink       0
```

Finally, we can chain together our joins if we have multiple data frames to join


```r
inner_join(animal_sounds, animal_legs, by="animal") %>%
	inner_join(., pats_farm, by=c("animal" = "type"))
```

```
## # A tibble: 3 x 4
##   animal sound n_legs he_has
##   <chr>  <chr>  <dbl> <lgl> 
## 1 cat    meow       4 TRUE  
## 2 fish   blub       4 FALSE 
## 3 pig    oink       0 TRUE
```

To put `inner_join` into a pipeline like we did here, you need to put a `.` where data from the pipeline goes. Also, notice that for our `by` argument, the order of the columns needs to match their representation in the `inner_join`. For example, if we did `inner_join(pats_farm, ., by=c("animal" = "type"))` we will get an error, but if we do `inner_join(pats_farm, ., by=c("type" = "animal"))`, we won't.

Let's try this with our `um_degrees` and `award_code` data frames!


```r
inner_join(um_degrees, award_code, by=c("AWLEVEL"="codevalue"))
```

```
## # A tibble: 2 x 3
##   AWLEVEL n_graduates valuelabel                             
##   <chr>         <dbl> <chr>                                  
## 1 17              874 Doctor's degree - research/scholarship 
## 2 18              682 Doctor's degree - professional practice
```

Fantastic! Oops, maybe not. We only have our rows corresponding to the doctorate degrees. You might notice a subtle difference between the values in `codevalue` from `award_code` and `AWLEVEL` in `um_degrees`. The single digit values in `AWLEVEL` have a "0" on the left side to make the code a two digit string; the values in `codevalue` don't have the padding. We can add pad the numbers using the `str_pad` function, which is part of the `strignr` package that was loaded when we did `library(tidyverse)`. We'll see more of functions from `stringr` in the next few lessons. It's a powerful package for working with string data. Look at `?str_pad` to see if you can figure out how we might apply it for our case.

`str_pad` takes a string to be padded, the width to pad to, the side to pad (left is the default), and what to use as the pad (a space is the default). Say we have a set of numbers (i.e. a vector) from 1 to 20, we can define that as `1:20`


```r
x <- 1:20

# can you figure out why these two versions of `str_pad` do the same thing?
str_pad(string=x, width=2, side="left", pad="0")

# or

str_pad(x, 2, pad="0")
```

```
##  [1] "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15"
## [16] "16" "17" "18" "19" "20"
##  [1] "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15"
## [16] "16" "17" "18" "19" "20"
```

Do you remember how we can modify an existing column? `mutate`! Let's modify the `codevalue` column


```r
award_code <- read_excel("ipeds/c2018_a.xlsx", sheet="Frequencies") %>%
	filter(varname == "AWLEVEL") %>%
	select(codevalue, valuelabel) %>%
	mutate(codevalue = str_pad(codevalue, 2, pad="0"))
```

Now that the formatting of `codevalue` is fixed, let's try that join again


```r
inner_join(um_degrees, award_code, by=c("AWLEVEL"="codevalue"))
```

```
## # A tibble: 6 x 3
##   AWLEVEL n_graduates valuelabel                             
##   <chr>         <dbl> <chr>                                  
## 1 05             7450 Bachelor's degree                      
## 2 06               43 Postbaccalaureate certificate          
## 3 07             4677 Master's degree                        
## 4 08              185 Post-master's certificate              
## 5 17              874 Doctor's degree - research/scholarship 
## 6 18              682 Doctor's degree - professional practice
```

We can clean up the output a little using `select` and `rename`


```r
inner_join(um_degrees, award_code, by=c("AWLEVEL"="codevalue")) %>%
	select(valuelabel, n_graduates) %>%
	rename("degree" = "valuelabel")
```

```
## # A tibble: 6 x 2
##   degree                                  n_graduates
##   <chr>                                         <dbl>
## 1 Bachelor's degree                              7450
## 2 Postbaccalaureate certificate                    43
## 3 Master's degree                                4677
## 4 Post-master's certificate                       185
## 5 Doctor's degree - research/scholarship          874
## 6 Doctor's degree - professional practice         682
```


## Exercises

1\. Use the `left_join`, `right_join`, and `full_join` functions to merge `animal_sounds` and `animal_legs`. What happens with these functions (and `inner_join`) if you switch the order of `animal_sounds` and `animal_legs` in the arguments to these functions?

<input type="button" class="hideshow">
<div markdown="1" style="display:none;">

```r
# only information for shared animals is outputted
inner_join(animal_sounds, animal_legs, by="animal")
</div>
```

```
## Error: <text>:3:1: unexpected '<'
## 2: inner_join(animal_sounds, animal_legs, by="animal")
## 3: <
##    ^
```

```r
# only information for animals in animal_sounds is outputted; missing get NA
left_join(animal_sounds, animal_legs, by="animal")
</div>
```

```
## Error: <text>:3:1: unexpected '<'
## 2: left_join(animal_sounds, animal_legs, by="animal")
## 3: <
##    ^
```

```r
# only information for animals in animal_legs is outputted; missing get NA
right_join(animal_sounds, animal_legs, by="animal")
</div>
```

```
## Error: <text>:3:1: unexpected '<'
## 2: right_join(animal_sounds, animal_legs, by="animal")
## 3: <
##    ^
```

```r
# information from both data frames is outputted; missing get NA
full_join(animal_sounds, animal_legs, by="animal")
</div>
```

```
## Error: <text>:3:1: unexpected '<'
## 2: full_join(animal_sounds, animal_legs, by="animal")
## 3: <
##    ^
```

```r
# the order of the columns is determined by the order of the data frames
inner_join(animal_legs, animal_sounds, by="animal")
```

```
## # A tibble: 3 x 3
##   animal n_legs sound
##   <chr>   <dbl> <chr>
## 1 cat         4 meow 
## 2 pig         0 oink 
## 3 fish        4 blub
```
</div>

2\. Which programs at the University of Michigan awarded a Postbaccalaureate certificate (AWLEVEL: 06) in 2018? What about a Post-master's certificate (AWLEVEL: 08)?

<input type="button" class="hideshow">
<div markdown="1" style="display:none;">

```r
cip_codes <- read_excel("ipeds/c2018_a.xlsx", sheet="Frequencies") %>%
	filter(varname == "CIPCODE" & codevalue != 99) %>%
	rename("major" = "valuelabel" ) %>%
	select(codevalue, major)

degrees %>%
	filter(UNITID == 170976 & MAJORNUM == 1 & AWLEVEL == "06" & CIPCODE != 99 & CTOTALT != 0) %>%
	select(CIPCODE, CTOTALT) %>%
	inner_join(., cip_codes, by=c("CIPCODE"="codevalue"))

degrees %>%
	filter(UNITID == 170976 & MAJORNUM == 1 & AWLEVEL == "08" & CIPCODE != 99 & CTOTALT != 0) %>%
	select(CIPCODE, CTOTALT) %>%
	inner_join(., cip_codes, by=c("CIPCODE"="codevalue")) %>%
	arrange(desc(CTOTALT)) %>%
	print(n=Inf)
```

```
## # A tibble: 1 x 3
##   CIPCODE CTOTALT major               
##   <chr>     <dbl> <chr>               
## 1 51.2299      43 Public Health, Other
## # A tibble: 30 x 3
##    CIPCODE CTOTALT major                                                        
##    <chr>     <dbl> <chr>                                                        
##  1 11.0802      41 Data Modeling/Warehousing and Database Administration        
##  2 30.9999      28 Multi-/Interdisciplinary Studies, Other                      
##  3 44.0701      19 Social Work                                                  
##  4 11.9999      13 Computer and Information Sciences and Support Services, Other
##  5 51.2706      10 Medical Informatics                                          
##  6 44.0501       8 Public Policy Analysis, General                              
##  7 50.9999       7 Visual and Performing Arts, Other                            
##  8 52.1501       7 Real Estate                                                  
##  9 26.0806       6 Human/Medical Genetics                                       
## 10 30.1501       6 Science, Technology and Society                              
## 11 05.0201       4 African-American/Black Studies                               
## 12 30.0601       4 Systems Science and Theory                                   
## 13 30.1401       4 Museology/Museum Studies                                     
## 14 05.0101       3 African Studies                                              
## 15 05.0207       3 Women's Studies                                              
## 16 27.0501       3 Statistics, General                                          
## 17 14.1001       2 Electrical and Electronics Engineering                       
## 18 26.0102       2 Biomedical Sciences, General                                 
## 19 38.0206       2 Jewish/Judaic Studies                                        
## 20 50.0904       2 Music Theory and Composition                                 
## 21 51.2205       2 Health/Medical Physics                                       
## 22 03.0201       1 Natural Resources Management and Policy                      
## 23 05.0106       1 European Studies/Civilization                                
## 24 05.0203       1 Hispanic-American, Puerto Rican, and Mexican-American/Chican…
## 25 26.1201       1 Biotechnology                                                
## 26 26.1301       1 Ecology                                                      
## 27 30.1301       1 Medieval and Renaissance Studies                             
## 28 50.0601       1 Film/Cinema/Video Studies                                    
## 29 51.9999       1 Health Professions and Related Clinical Sciences, Other      
## 30 52.1399       1 Management Sciences and Quantitative Methods, Other
```
</div>

3\. Which major at the University of Michigan awarded the most Bachelor's degrees? Master's? Doctorates (Research)? Doctorates (Professional)? Can you join a data frame with the CIPCODES data?

<input type="button" class="hideshow">
<div markdown="1" style="display:none;">

```r
cip_codes <- read_excel("ipeds/c2018_a.xlsx", sheet="Frequencies") %>%
	filter(varname == "CIPCODE" & codevalue != 99) %>%
	rename("major" = "valuelabel" ) %>%
	select(codevalue, major)


um_degrees_majors <- degrees %>%
	filter(UNITID == 170976 & MAJORNUM == 1 & CIPCODE != 99) %>%
	group_by(AWLEVEL, CIPCODE) %>%
	summarize(n_graduates = sum(CTOTALT)) %>%
	ungroup() %>%
	inner_join(., cip_codes, by=c("CIPCODE" = "codevalue")) %>%
	inner_join(., award_code, by=c("AWLEVEL" = "codevalue")) %>%
	arrange(desc(n_graduates)) %>%
	rename("degree" = "valuelabel") %>%
	select(degree, AWLEVEL, major, n_graduates) %>%
	arrange(desc(n_graduates))


um_degrees_majors %>% filter(AWLEVEL == "05")
um_degrees_majors %>% filter(AWLEVEL == "07")
um_degrees_majors %>% filter(AWLEVEL == "17")
um_degrees_majors %>% filter(AWLEVEL == "18")
```

```
## # A tibble: 152 x 4
##    degree           AWLEVEL major                                    n_graduates
##    <chr>            <chr>   <chr>                                          <dbl>
##  1 Bachelor's degr… 05      Computer and Information Sciences, Gene…         624
##  2 Bachelor's degr… 05      Business Administration and Management,…         544
##  3 Bachelor's degr… 05      Economics, General                               440
##  4 Bachelor's degr… 05      Experimental Psychology                          351
##  5 Bachelor's degr… 05      Physiological Psychology/Psychobiology           328
##  6 Bachelor's degr… 05      Political Science and Government, Gener…         295
##  7 Bachelor's degr… 05      Mechanical Engineering                           279
##  8 Bachelor's degr… 05      Speech Communication and Rhetoric                247
##  9 Bachelor's degr… 05      Industrial Engineering                           195
## 10 Bachelor's degr… 05      Neuroscience                                     195
## # … with 142 more rows
## # A tibble: 153 x 4
##    degree         AWLEVEL major                                      n_graduates
##    <chr>          <chr>   <chr>                                            <dbl>
##  1 Master's degr… 07      Business Administration and Management, G…         678
##  2 Master's degr… 07      Social Work                                        329
##  3 Master's degr… 07      Electrical and Electronics Engineering             307
##  4 Master's degr… 07      Mechanical Engineering                             186
##  5 Master's degr… 07      Information Science/Studies                        178
##  6 Master's degr… 07      Architectural and Building Sciences/Techn…         154
##  7 Master's degr… 07      Systems Engineering                                146
##  8 Master's degr… 07      Education, General                                 123
##  9 Master's degr… 07      Health/Health Care Administration/Managem…         114
## 10 Master's degr… 07      Natural Resources/Conservation, General            107
## # … with 143 more rows
## # A tibble: 104 x 4
##    degree                  AWLEVEL major                             n_graduates
##    <chr>                   <chr>   <chr>                                   <dbl>
##  1 Doctor's degree - rese… 17      Electrical and Electronics Engin…          55
##  2 Doctor's degree - rese… 17      Chemistry, General                         46
##  3 Doctor's degree - rese… 17      Mechanical Engineering                     39
##  4 Doctor's degree - rese… 17      Physics, General                           34
##  5 Doctor's degree - rese… 17      Aerospace, Aeronautical and Astr…          33
##  6 Doctor's degree - rese… 17      Computer Engineering, General              29
##  7 Doctor's degree - rese… 17      Economics, General                         29
##  8 Doctor's degree - rese… 17      Education, General                         23
##  9 Doctor's degree - rese… 17      Experimental Psychology                    23
## 10 Doctor's degree - rese… 17      Chemical Engineering                       21
## # … with 94 more rows
## # A tibble: 7 x 4
##   degree                         AWLEVEL major                       n_graduates
##   <chr>                          <chr>   <chr>                             <dbl>
## 1 Doctor's degree - professiona… 18      Law                                 293
## 2 Doctor's degree - professiona… 18      Medicine                            165
## 3 Doctor's degree - professiona… 18      Dentistry                           128
## 4 Doctor's degree - professiona… 18      Pharmacy                             82
## 5 Doctor's degree - professiona… 18      Registered Nursing/Registe…           9
## 6 Doctor's degree - professiona… 18      Public Health/Community Nu…           4
## 7 Doctor's degree - professiona… 18      Geriatric Nurse/Nursing               1
```
</div>


4\. Without looking up numbers in Excel, can you compare the total number of different degrees granted in 2018 at the "University of Michigan-Ann Arbor" and "Michigan State University"?

<input type="button" class="hideshow">
<div markdown="1" style="display:none;">

```r
institution_code <- read_csv("ipeds/hd2018.csv") %>%
	filter(INSTNM == "University of Michigan-Ann Arbor" | INSTNM == "Michigan State University") %>%
	select(UNITID, INSTNM)

inner_join(degrees, institution_code, by="UNITID") %>%
	filter(MAJORNUM == 1) %>%
	group_by(AWLEVEL, INSTNM) %>%
	summarize(n_graduates = sum(CTOTALT)) %>%
	ungroup() %>%
	inner_join(., award_code, by=c("AWLEVEL"="codevalue")) %>%
	select(INSTNM, valuelabel, n_graduates) %>%
	rename("institution"="INSTNM", "degree_type"="valuelabel")
```

```
## # A tibble: 13 x 3
##    institution                degree_type                            n_graduates
##    <chr>                      <chr>                                        <dbl>
##  1 Michigan State University  Award of at least 1 but less than 2 a…         342
##  2 Michigan State University  Bachelor's degree                            18240
##  3 University of Michigan-An… Bachelor's degree                            14900
##  4 Michigan State University  Postbaccalaureate certificate                  348
##  5 University of Michigan-An… Postbaccalaureate certificate                   86
##  6 Michigan State University  Master's degree                               4480
##  7 University of Michigan-An… Master's degree                               9354
##  8 Michigan State University  Post-master's certificate                        4
##  9 University of Michigan-An… Post-master's certificate                      370
## 10 Michigan State University  Doctor's degree - research/scholarship        1106
## 11 University of Michigan-An… Doctor's degree - research/scholarship        1748
## 12 Michigan State University  Doctor's degree - professional practi…        1166
## 13 University of Michigan-An… Doctor's degree - professional practi…        1364
```
</div>
