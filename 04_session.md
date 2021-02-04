---
layout: lesson
title: "Session 4"
output: markdown_document
---

## Topics
* What is a (tidy) data frame?
* Understanding the structure of our data frame
* Data types
* Counting data
* Summarizing data frames



## What is a (tidy) data frame?

Before we go much further, it would help to define what we mean by a "data frame". A data frame is central to the concept of the tidyverse. You can think of it as the data in a spreadsheet. It is a table where each row represents a different observation and each column is a different description of that observation. Each observation has the same number of descriptors and the descriptor is the same type (e.g. text, numerical, logical) across all of the observations. For example, in the Lyme disease data, we might have a different row for each state and year. We would then have columns to record the year, state, count, and possibly other variables. This format is "tidy". Alternatively, we could have each row represent a state and each column a different year's count. For most questions, we'd consider this to be a wide, non-tidy format. If you think about our aesthetics from the previous discussion, you'll recall that we map columns of a data frame to a specific aesthetic. We can't map multiple columns to one aesthetic. For example, all the values we want to plot on the y-axis need to be in the same column. Later we'll discuss how to make a wide data frame tidy and how to make a tidy data frame wide for those cases where it is necessary.


## Understanding the structure of our data frame
The line plot that we made in Session 1 was pretty compelling, right? The United States is a big place and has a large population. What does it look like in the states we are most concerned about? We've been playing with visualizing data without actually understanding much about the data we are working with. To answer the state-level question, we need to better understand our data frame.


```r
library(tidyverse)
library(lubridate)

annual_counts <- read_csv("project_tycho/US.23502006.csv",
			col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	filter(PartOfCumulativeCountSeries) %>%
	mutate(year = year(PeriodStartDate+7)) %>%
	group_by(year) %>%
	summarize(count = max(CountValue))
```

We still haven't talked much about the code in the chunk, but hopefully you can start to make sense of what `read_csv`, `filter`, `mutate`, `group_by`, and `summarize` are doing. What I'd like to do is see the data for each state for each year. Do you have any intuition as to which line in this chunk we want to change? If you thought, "well, we grouped by year to get the data by year, perhaps I want to add the state to that command to get the state-level data" - you were right! But if we add "state" to the filter command arguments, R will tell us that it doesn't know what we're talking about. When we have a new dataset, we normally want to explore it a bit to understand what data it contains. I have three general tools that I like to use. Let me show them to you with this dataset.

If I run the `read_csv` command, I'll get an abbreviated view of the data frame


```r
read_csv("project_tycho/US.23502006.csv",
	col_type=cols(PartOfCumulativeCountSeries = col_logical()))
```

```
## # A tibble: 51,254 x 20
##    ConditionName ConditionSNOMED PathogenName PathogenTaxonID Fatalities
##    <chr>                   <dbl> <chr>                  <dbl>      <dbl>
##  1 Lyme disease         23502006 Borrelia                 138          0
##  2 Lyme disease         23502006 Borrelia                 138          0
##  3 Lyme disease         23502006 Borrelia                 138          0
##  4 Lyme disease         23502006 Borrelia                 138          0
##  5 Lyme disease         23502006 Borrelia                 138          0
##  6 Lyme disease         23502006 Borrelia                 138          0
##  7 Lyme disease         23502006 Borrelia                 138          0
##  8 Lyme disease         23502006 Borrelia                 138          0
##  9 Lyme disease         23502006 Borrelia                 138          0
## 10 Lyme disease         23502006 Borrelia                 138          0
## # … with 51,244 more rows, and 15 more variables: CountryName <chr>,
## #   CountryISO <chr>, Admin1Name <chr>, Admin1ISO <chr>, Admin2Name <lgl>,
## #   CityName <lgl>, PeriodStartDate <date>, PeriodEndDate <date>,
## #   PartOfCumulativeCountSeries <lgl>, AgeRange <chr>, Subpopulation <chr>,
## #   PlaceOfAcquisition <lgl>, DiagnosisCertainty <lgl>, SourceName <chr>,
## #   CountValue <dbl>
```

You'll get the first 10 rows of the data frame and depending on the size of your screen, you'll get different numbers of columns. You'll also get a listing of the various column names, but without their data. You'll also see an abbreviation between `< >` characters that tells you the type of data you have. For example, `ConditionName` has `<chr>` under it telling you that it's a column that contains "character" or text data. The neighboring column `ConditionSNOMED` has `<dbl>`, which is shorthand for "double", a type of numerical data. We'll discuss this later, but for now, you can see that we are telling `read_csv` that `PartOfCumulativeCountSeries` should be a logical variable.

Another approach is to use `colnames` on the data frame to get a simple listing of the column names


```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	colnames()
```

```
##  [1] "ConditionName"               "ConditionSNOMED"            
##  [3] "PathogenName"                "PathogenTaxonID"            
##  [5] "Fatalities"                  "CountryName"                
##  [7] "CountryISO"                  "Admin1Name"                 
##  [9] "Admin1ISO"                   "Admin2Name"                 
## [11] "CityName"                    "PeriodStartDate"            
## [13] "PeriodEndDate"               "PartOfCumulativeCountSeries"
## [15] "AgeRange"                    "Subpopulation"              
## [17] "PlaceOfAcquisition"          "DiagnosisCertainty"         
## [19] "SourceName"                  "CountValue"
```

I find this approach generates a listing of variables in my data frame that is easy to read. Scanning through the column names, nothing jumps out at me as representing the names of the states.

The third approach is to use the `glimpse` function similar to how we used `colnames`


```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	glimpse()
```

```
## Rows: 51,254
## Columns: 20
## $ ConditionName               <chr> "Lyme disease", "Lyme disease", "Lyme dis…
## $ ConditionSNOMED             <dbl> 23502006, 23502006, 23502006, 23502006, 2…
## $ PathogenName                <chr> "Borrelia", "Borrelia", "Borrelia", "Borr…
## $ PathogenTaxonID             <dbl> 138, 138, 138, 138, 138, 138, 138, 138, 1…
## $ Fatalities                  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
## $ CountryName                 <chr> "UNITED STATES OF AMERICA", "UNITED STATE…
## $ CountryISO                  <chr> "US", "US", "US", "US", "US", "US", "US",…
## $ Admin1Name                  <chr> "WISCONSIN", "WISCONSIN", "WISCONSIN", "W…
## $ Admin1ISO                   <chr> "US-WI", "US-WI", "US-WI", "US-WI", "US-W…
## $ Admin2Name                  <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ CityName                    <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ PeriodStartDate             <date> 2007-09-09, 2007-09-16, 2007-10-28, 2007…
## $ PeriodEndDate               <date> 2007-09-15, 2007-09-22, 2007-11-03, 2007…
## $ PartOfCumulativeCountSeries <lgl> FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,…
## $ AgeRange                    <chr> "0-130", "0-130", "0-130", "0-130", "0-13…
## $ Subpopulation               <chr> "None specified", "None specified", "None…
## $ PlaceOfAcquisition          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ DiagnosisCertainty          <lgl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
## $ SourceName                  <chr> "US Nationally Notifiable Disease Surveil…
## $ CountValue                  <dbl> 3, 1, 1, 1, 1, 1, 1, 2, 5, 2, 2, 2, 1, 1,…
```

Looking at this output, it should be more straightforward to figure out which variable name contains the name (or the abbreviation of the name) of each state. The `Admin1Name` variable contains the names of the states in all caps.

Another approach that people find useful is to use the `View` function in place of `glimpse`.


```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	View()
```

This opens a window that looks like a spreadsheet that you can only view, but cannot edit.

A final approach is brute force. We can use the `print` function to set the number of rows to report by adjusting the `n` argument. Setting `n=Inf` will return all of the rows


```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	print(n=5)
```

```
## # A tibble: 51,254 x 20
##   ConditionName ConditionSNOMED PathogenName PathogenTaxonID Fatalities
##   <chr>                   <dbl> <chr>                  <dbl>      <dbl>
## 1 Lyme disease         23502006 Borrelia                 138          0
## 2 Lyme disease         23502006 Borrelia                 138          0
## 3 Lyme disease         23502006 Borrelia                 138          0
## 4 Lyme disease         23502006 Borrelia                 138          0
## 5 Lyme disease         23502006 Borrelia                 138          0
## # … with 51,249 more rows, and 15 more variables: CountryName <chr>,
## #   CountryISO <chr>, Admin1Name <chr>, Admin1ISO <chr>, Admin2Name <lgl>,
## #   CityName <lgl>, PeriodStartDate <date>, PeriodEndDate <date>,
## #   PartOfCumulativeCountSeries <lgl>, AgeRange <chr>, Subpopulation <chr>,
## #   PlaceOfAcquisition <lgl>, DiagnosisCertainty <lgl>, SourceName <chr>,
## #   CountValue <dbl>
```

Similarly, you can set `width=Inf` to see all of the columns


```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	print(width=Inf)
```


## Data types
Previously, we used `glimpse` to get a compact report of the data in our data frame. In the output we saw a variety of types...

* `chr` - character or text
* `dbl` - double / numeric data with a decimal (default numeric format)
* `date` - date
* `lgl` - logical (`TRUE` and `FALSE`)

Other types we might see later include integer (count data), numeric (generic number data), datetime (date and time), time, and factor (categorical data). Depending on the type of data in the column, we may be able to use certain functions to perform analyses. For example, using `mean` on a character variable doesn't make sense, but it does for a double variable.

It is possible to convert back and forth between variable types using functions that start `as.`. Often this is perilous because it may not be easy to predict how the conversion will work. Consider the following examples


```r
x <- c(0, 1, 2, 3, 4)
x
```

```
## [1] 0 1 2 3 4
```


```r
as.character(x)
```

```
## [1] "0" "1" "2" "3" "4"
```


```r
as.logical(x)
```

```
## [1] FALSE  TRUE  TRUE  TRUE  TRUE
```


```r
as.logical(x) %>% as.character()
```

```
## [1] "FALSE" "TRUE"  "TRUE"  "TRUE"  "TRUE"
```


```r
as.logical(x) %>% as.numeric()
```

```
## [1] 0 1 1 1 1
```


```r
as.character(x) %>% as.logical()
```

```
## [1] NA NA NA NA NA
```


```r
as.logical(x) %>% as.character() %>% as.logical()
```

```
## [1] FALSE  TRUE  TRUE  TRUE  TRUE
```


```r
as.numeric(c("a", "b", "c"))
```

```
## [1] NA NA NA
```

As you can see, it's best to keep these types straight.

One special data type that causes confusion is `factor`. An R `factor` allows you to represent categorical data. For example, if you wanted to represent "male" and "female" subjects or different religious denominations. Of course, you could represent those values as text data, but sometimes their order matters to the analysis or to the visualization. Then the data become ordinal. By default a factor takes its order from the alphanumeric order of the values in the variable.


```r
x <- c("male", "female", "other")
factor(x)
```

```
## [1] male   female other 
## Levels: female male other
```

That output shows us that our factor has three levels - "female", "male", and "other". Because "female" precedes "male" and "other", alphabetically, that is the order the `factor` function uses to define the function. Alternatively, we can set the order using the `levels` argument


```r
x <- c("male", "female", "other")
factor(x, levels=c("other", "male", "female"))
```

```
## [1] male   female other 
## Levels: other male female
```

We'll try to keep our use of factors to a minimum. Being aware of them makes it easier to generate plots where we want the data depicted in a specific order.


## Counting data

Another tool we have for understanding the structure of a data frame is to use the `count` function. This function is useful when we have a column that is a character type. It counts the number of times each value in the column appears in that column. For example, if I wasn't sure which column contained the state name, I could do this over and over for each column


```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	count(Admin1Name)
```

```
## # A tibble: 53 x 2
##    Admin1Name               n
##    <chr>                <int>
##  1 ALABAMA               1019
##  2 ALASKA                 726
##  3 AMERICAN SAMOA           1
##  4 ARIZONA                664
##  5 ARKANSAS               480
##  6 CALIFORNIA            1539
##  7 COLORADO               536
##  8 CONNECTICUT           1213
##  9 DELAWARE              1642
## 10 DISTRICT OF COLUMBIA   988
## # … with 43 more rows
```

Alternatively, perhaps I'm not sure if data from Canada are included in this dataset


```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	count(CountryName)
```

```
## # A tibble: 1 x 2
##   CountryName                  n
##   <chr>                    <int>
## 1 UNITED STATES OF AMERICA 51254
```

Looks like it's all from the United States.


## Summarizing data frames

When we have a data frame that has columns with continuous data, it can be helpful to get a summary of the data. We can get R's summary of our data frame with the `summary` function


```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	summary()
```

```
##  ConditionName      ConditionSNOMED    PathogenName       PathogenTaxonID
##  Length:51254       Min.   :23502006   Length:51254       Min.   :138    
##  Class :character   1st Qu.:23502006   Class :character   1st Qu.:138    
##  Mode  :character   Median :23502006   Mode  :character   Median :138    
##                     Mean   :23502006                      Mean   :138    
##                     3rd Qu.:23502006                      3rd Qu.:138    
##                     Max.   :23502006                      Max.   :138    
##    Fatalities CountryName         CountryISO         Admin1Name       
##  Min.   :0    Length:51254       Length:51254       Length:51254      
##  1st Qu.:0    Class :character   Class :character   Class :character  
##  Median :0    Mode  :character   Mode  :character   Mode  :character  
##  Mean   :0                                                            
##  3rd Qu.:0                                                            
##  Max.   :0                                                            
##   Admin1ISO         Admin2Name     CityName       PeriodStartDate     
##  Length:51254       Mode:logical   Mode:logical   Min.   :1990-12-30  
##  Class :character   NA's:51254     NA's:51254     1st Qu.:1999-01-03  
##  Mode  :character                                 Median :2006-01-01  
##                                                   Mean   :2005-01-10  
##                                                   3rd Qu.:2012-01-01  
##                                                   Max.   :2016-12-25  
##  PeriodEndDate        PartOfCumulativeCountSeries   AgeRange        
##  Min.   :1991-02-02   Mode :logical               Length:51254      
##  1st Qu.:1999-01-30   FALSE:5681                  Class :character  
##  Median :2006-09-09   TRUE :45573                 Mode  :character  
##  Mean   :2005-07-20                                                 
##  3rd Qu.:2012-02-18                                                 
##  Max.   :2016-12-31                                                 
##  Subpopulation      PlaceOfAcquisition DiagnosisCertainty  SourceName       
##  Length:51254       Mode:logical       Mode:logical       Length:51254      
##  Class :character   NA's:51254         NA's:51254         Class :character  
##  Mode  :character                                         Mode  :character  
##                                                                             
##                                                                             
##                                                                             
##    CountValue     
##  Min.   :    0.0  
##  1st Qu.:    3.0  
##  Median :   11.0  
##  Mean   :  159.8  
##  3rd Qu.:   51.0  
##  Max.   :12200.0
```

The output can be a bit painful to wade through. For character data, the output of `summary` tells us that it was character data and the number of values in the data frame. For double and date data, we get the five cardinal values and the mean across the observations. For logical data we get a count of the number of `TRUE`, `FALSE`, and `NA` observations. This view is useful for identifying values that don't make sense. For example if we had a variable for height and it was negative, we'd want to note that and fix the value later.


## Exercises

1\. Thinking of the types of data you interact with regularly, what would you represent as a logical, character, double, factor, date?

<input type="button" class="hideshow">
<div markdown="1" style="display:none;">
* logical: minor? eligible for social security? left-handed?
* character: name, school
* double: age, weight, height
* factor: color, income class, state
* date: birth day, anniversary, due dates
</div>

2\. If we left out the `col_type=cols(PartOfCumulativeCountSeries = col_logical())` argument, what data type would `PartOfCumulativeCountSeries` be? If we include it, what type is it? Can you think of why we need to specify the column type?

<input type="button" class="hideshow">
<div markdown="1" style="display:none;">

If we leave this argument out it will be a double. With the argument it will be a logical. It will be useful for filtering the data frame to only retrieve those observations where the value is true.

</div>


3\. A column is a logical type and has 3 `TRUE` values and 2 `FALSE` values. When we calculate the mean for the column (using `mean`) we get a value of 0.6. Can you explain why?

<input type="button" class="hideshow">
<div markdown="1" style="display:none;">
If you convert `TRUE` to a number it has the value of 1; the value of `FALSE` is 0.


```r
x <- c(TRUE, TRUE, TRUE, FALSE, FALSE)
as.numeric(x)

mean(x)
sum(x)
```

```
## [1] 1 1 1 0 0
## [1] 0.6
## [1] 3
```

The mean value for a logical variable tells us the fraction of observations where the value was `TRUE`.
</div>


4\. How do I view all of the rows of the data frame that contains the number of times each "state" appear in the data frame?

<input type="button" class="hideshow">
<div markdown="1" style="display:none;">

```r
read_csv("project_tycho/US.23502006.csv",
		col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	count(Admin1Name) %>%
	print(n=Inf)
```

```
## # A tibble: 53 x 2
##    Admin1Name               n
##    <chr>                <int>
##  1 ALABAMA               1019
##  2 ALASKA                 726
##  3 AMERICAN SAMOA           1
##  4 ARIZONA                664
##  5 ARKANSAS               480
##  6 CALIFORNIA            1539
##  7 COLORADO               536
##  8 CONNECTICUT           1213
##  9 DELAWARE              1642
## 10 DISTRICT OF COLUMBIA   988
## 11 FLORIDA               1744
## 12 GEORGIA                864
## 13 GUAM                    39
## 14 HAWAII                  96
## 15 IDAHO                  965
## 16 ILLINOIS               771
## 17 INDIANA               1067
## 18 IOWA                  1172
## 19 KANSAS                1075
## 20 KENTUCKY              1083
## 21 LOUISIANA              601
## 22 MAINE                 1181
## 23 MARYLAND              1848
## 24 MASSACHUSETTS         1280
## 25 MICHIGAN              1133
## 26 MINNESOTA             1005
## 27 MISSISSIPPI            430
## 28 MISSOURI               949
## 29 MONTANA                375
## 30 NEBRASKA               965
## 31 NEVADA                 803
## 32 NEW HAMPSHIRE         1310
## 33 NEW JERSEY            1382
## 34 NEW MEXICO             540
## 35 NEW YORK               310
## 36 NORTH CAROLINA        1415
## 37 NORTH DAKOTA           439
## 38 OHIO                  1507
## 39 OKLAHOMA               397
## 40 OREGON                1144
## 41 PENNSYLVANIA          1884
## 42 RHODE ISLAND          1161
## 43 SOUTH CAROLINA        1137
## 44 SOUTH DAKOTA           403
## 45 TENNESSEE             1263
## 46 TEXAS                 1173
## 47 UTAH                   791
## 48 VERMONT               1441
## 49 VIRGINIA              1659
## 50 WASHINGTON             865
## 51 WEST VIRGINIA         1210
## 52 WISCONSIN              870
## 53 WYOMING                699
```
</div>
