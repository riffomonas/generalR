---
layout: lesson
title: "Session 4"
output: markdown_document
---

## Topics
*




The line plot that we made in Session 1 was pretty compelling, right? The United States is a big place geographically and in its population. What does it look like in the states we are most concerned about? We've been playing with visualizing data without actually understanding much about the data we are working with. To answer the state-level question, we need to better understand our data frame.

Previously we saw this chunk of code


```r
annual_counts <- read_csv("project_tycho/US.23502006.csv",
					col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	filter(PartOfCumulativeCountSeries) %>%
	mutate(year = year(PeriodStartDate+7)) %>%
	group_by(year) %>%
	summarize(count = max(CountValue))
```

```
## Error in year(PeriodStartDate + 7): could not find function "year"
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
## Observations: 51,254
## Variables: 20
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

* Need to talk about...
  * variable types
  * count / summarizing data in a column
  * setting variable types
  * renaming column names
