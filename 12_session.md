---
layout: lesson
title: "Session 12"
output: markdown_document
---

## Topics
*




Before tacking representation within a specific (or broad) discipline, I'd like to understand representation of students graduating with a Bachelor's degree in 2018 at different types of institutions. Within the US there are different categories of schools based on their mission. One way of doing this is by using a [framework](http://carnegieclassifications.iu.edu/definitions.php) developed by the Carnegie Commission on Higher Education in 1970 and modified since. The data for the 2000 definition are provided in the `CARNEGIE` column of `ipdeds/hd2018.csv` (there are newer definitions that break down institutions into finer categories). Let's ease into our analysis by reading in the awards data again finding the total number of Bachelor's degrees conferred at each institution. We'll take advantage of the observation that CIP code 99 indicates the total number of degrees awarded at the institution and that AWLEVEL "05" is for the Bachelor's degree. Then we'll bring in the institution name and its Carnegie information.


```r
library(tidyverse)

bachelors_degrees <- read_csv("ipdeds/c2018_a.csv") %>%
	filter(MAJORNUM == 1 & CIPCODE == "99" & AWLEVEL == "05" & CTOTALT > 0)
```

```
## Error: 'ipdeds/c2018_a.csv' does not exist in current working directory ('/Users/pschloss/Documents/websites/riffomonas/generalR').
```

To make the data frame easier to look at I'll remove these columns that we filtered on as well as any column that starts with an "X" (the X indicates how the data were generated).


```r
bachelors_degrees <- read_csv("ipdeds/c2018_a.csv") %>%
	filter(MAJORNUM == 1 & CIPCODE == "99" & AWLEVEL == "05" & CTOTALT > 0) %>%
	select(-CIPCODE, -MAJORNUM, -AWLEVEL, -starts_with("x"))
```

```
## Error: 'ipdeds/c2018_a.csv' does not exist in current working directory ('/Users/pschloss/Documents/websites/riffomonas/generalR').
```

We're left with the column for the institution identifier ("UNITID") and the counts of different groups on campus. Let's bring in the institution name and Carnegie information


```r
inst_carnegie <- read_csv("ipdeds/hd2018.csv") %>%
	select(UNITID, INSTNM, CARNEGIE)
```

```
## Error: 'ipdeds/hd2018.csv' does not exist in current working directory ('/Users/pschloss/Documents/websites/riffomonas/generalR').
```

Of course, we'd like to bring in the title for each Carnegie code


```r
library(readxl)

carnegie_code <- read_excel("ipdeds/hd2018.xlsx", sheet = "Frequencies") %>%
	filter(varname == "CARNEGIE") %>%
	select(codevalue, valuelabel)
```

```
## Error: `path` does not exist: 'ipdeds/hd2018.xlsx'
```

Let's go ahead and merge our data frames


```r
inst_carnegie %>%
	count(CARNEGIE) %>%
	inner_join(., carnegie_code, by=c("CARNEGIE" = "codevalue"))
```

```
## Error in eval(lhs, parent, parent): object 'inst_carnegie' not found
```

Now we have a new error! In `carnegie_code`, `codevalue` is a character and in `institutions`, `CARNEGIE` is a double or numeric value. We can convert numbers to characters using `as.character` and if the character is a number (e.g. "-2") we can convert it to a number with `as.numeric`. Since we won't be doing any math on these columns, I'd suggest we convert the numbers to characters.


```r
inst_carnegie %>%
	mutate(CARNEGIE = as.character(CARNEGIE)) %>%
	inner_join(., carnegie_code, by=c("CARNEGIE" = "codevalue"))
```

```
## Error in eval(lhs, parent, parent): object 'inst_carnegie' not found
```

Let's rename the `INSTNM` and `valuelabel` columns to make them easier to read, drop the `CARNEGIE` column, and add it to the previous pipeline for generating `inst_carnegie`


```r
inst_carnegie <- read_csv("ipdeds/hd2018.csv") %>%
	select(UNITID, INSTNM, CARNEGIE) %>%
	mutate(CARNEGIE = as.character(CARNEGIE)) %>%
	inner_join(., carnegie_code, by=c("CARNEGIE" = "codevalue")) %>%
	rename("institution" = "INSTNM", "carnegie"="valuelabel") %>%
	select(-CARNEGIE)
```

```
## Error: 'ipdeds/hd2018.csv' does not exist in current working directory ('/Users/pschloss/Documents/websites/riffomonas/generalR').
```

Now we can join `inst_carnegie` and `bachelors_degrees` so that we have our demographic information for each institution with the Carnegie group labeled.


```r
bachelor_demographics <- inner_join(inst_carnegie, bachelors_degrees, by="UNITID") %>%
	select(-UNITID)
```

```
## Error in inner_join(inst_carnegie, bachelors_degrees, by = "UNITID"): object 'inst_carnegie' not found
```

Let's see how many institutions we have in each category


```r
bachelor_demographics %>%
	count(carnegie)
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

Now let's see the median fraction of graduates who were women for each type of institution


```r
bachelor_demographics %>%
	mutate(f_women =CTOTALW/CTOTALT) %>%
	group_by(carnegie) %>%
	summarize(f_women = median(f_women), n=n()) %>%
	arrange(desc(f_women))
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

These results are pretty interesting! The types of schools that have the most women are health related (nursing?) and Tribal colleges. Those with the poorest representation of women are business, engineering and technology, and theological schools.

Believe it or not, we've done a lot of analysis so far in this lesson and we haven't learned any new syntax. Let's change that and see how we might plot these data. The first type of plot is a strip or jitter plot. Personally, I like these types of plots because they show every data point. This can also be their downfall because the plots can get a bit busy. We will plot the Carnegie category on the x-axis and the fraction of women on the y-axis


```r
bachelor_demographics %>%
	mutate(f_women =CTOTALW/CTOTALT) %>%
	select(carnegie, f_women) %>%
	ggplot(aes(x=carnegie, y=f_women)) +
		geom_jitter()
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

Yeah, there are a lot of points there. There are probably too many categories as well making it impossible to resolve the labels along the x-axis. To solve this second point we could switch the variables that we map to the `x` and `y` aesthetics


```r
bachelor_demographics %>%
	mutate(f_women =CTOTALW/CTOTALT) %>%
	select(carnegie, f_women) %>%
	ggplot(aes(y=carnegie, x=f_women)) +
		geom_jitter()
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

Alternatively, we can flip the axes using `coord_flip`


```r
bachelor_demographics %>%
	mutate(f_women =CTOTALW/CTOTALT) %>%
	select(carnegie, f_women) %>%
	ggplot(aes(x=carnegie, y=f_women)) +
		geom_jitter() +
		coord_flip()
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

As far as there being too many points, there are two options - box plots and violin plots. To flip the axes for these plots we have to use `coord_flip`


```r
bachelor_demographics %>%
	mutate(f_women =CTOTALW/CTOTALT) %>%
	select(carnegie, f_women) %>%
	ggplot(aes(x=carnegie, y=f_women)) +
		geom_boxplot() +
		coord_flip()
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

...and...


```r
bachelor_demographics %>%
	mutate(f_women =CTOTALW/CTOTALT) %>%
	select(carnegie, f_women) %>%
	ggplot(aes(x=carnegie, y=f_women)) +
		geom_violin() +
		coord_flip()
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

To reduce the number of columns, let's remove those institutions that are "not in the Carnegie universe" and those categories with fewer than 100 institutions. That will still leave us with 8 categories. I'm not interested in typing those in, so let's see if we can do this with a join.


```r
carnegie_categories <- bachelor_demographics %>%
	count(carnegie) %>%
	filter(carnegie != "Not applicable, not in Carnegie universe (not accredited or nondegree-granting)" & n > 100)
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

We can now insert a join to `carnegie_categories` into our pipeline


```r
bachelor_demographics %>%
	inner_join(., carnegie_categories, by="carnegie") %>%
	mutate(f_women =CTOTALW/CTOTALT) %>%
	select(carnegie, f_women) %>%
	ggplot(aes(x=carnegie, y=f_women)) +
		geom_boxplot() +
		coord_flip()
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

How about if we want to order the categories by their median values? I would break up the last pipeline into three parts. The first to create a data frame with the fraction of women (i.e. `representation`). Then I would generate a summary table that is ordered by the median value of `f_women` (i.e. `carnegie_summary`). Then I would use the order of the `carnegie` column ni the `carnegie_summary` table to set the order of levels of the `carnegie` column in `representation` and create the plot. Let's see how that plan works out


```r
representation <- bachelor_demographics %>%
	inner_join(., carnegie_categories, by="carnegie") %>%
	mutate(f_women = CTOTALW/CTOTALT) %>%
	select(carnegie, f_women)
```

```
## Error in eval(lhs, parent, parent): object 'bachelor_demographics' not found
```

```r
carnegie_ordered <- representation %>%
	group_by(carnegie) %>%
	summarize(f_women = median(f_women)) %>%
	arrange(desc(f_women)) %>%
	pull(carnegie)
```

```
## Error in UseMethod("group_by_"): no applicable method for 'group_by_' applied to an object of class "function"
```

```r
representation %>%
	mutate(carnegie = factor(carnegie, levels=carnegie_ordered)) %>%
	ggplot(aes(x=carnegie, y=f_women)) +
		geom_boxplot() +
		coord_flip()
```

```
## Error in UseMethod("mutate_"): no applicable method for 'mutate_' applied to an object of class "function"
```

The two "tricks" here are using `pull` to create a vector, `carnegie_ordered`, which is the order of the categories as we want them in the plots. Then we used that vector to set the order of `levels` in `factor` when building the plot. We could do more to "beautify" the figure, but let's move on to other questions.

Instead of looking across all types of institutions, Let's look instead at the representation of women among institutions in the "Doctoral/Research Universities--Extensive" category. We'll look at the Bachelor's (AWLEVEL: 05) and Doctoral (Research) (AWLEVEL: 17) graduates from these institutions. As we did earlier, we'll begin by filtering the data in `ipdeds/hd2018.csv` to obtain data from institutions in the "Doctoral/Research Universities--Extensive" category, which we saw earlier was CARNEGIE codes 15.


```r
library(tidyverse)

doc_institutions <- read_csv("ipdeds/hd2018.csv") %>%
	filter(CARNEGIE == "15") %>%
	select(UNITID, INSTNM)
```

```
## Error: 'ipdeds/hd2018.csv' does not exist in current working directory ('/Users/pschloss/Documents/websites/riffomonas/generalR').
```

That results in a data frame with 258 institutions. Now we need to get the Bachelor's, Master's, and Doctorate awards data from the `ipdeds/c2018_a.csv` data frame and join it with the `doc_institutions` data frame.


```r
read_csv("ipdeds/c2018_a.csv") %>%
	filter(MAJORNUM == 1 & CIPCODE == "99" & CTOTALT > 0 & (AWLEVEL == "05" | AWLEVEL == "17")) %>%
	inner_join(doc_institutions, ., by="UNITID")
```

```
## Error: 'ipdeds/c2018_a.csv' does not exist in current working directory ('/Users/pschloss/Documents/websites/riffomonas/generalR').
```

As we did earlier, we can clean this up a bit to remove the extra columns and assign the output to a variable.


```r
doc_degrees <- read_csv("ipdeds/c2018_a.csv") %>%
	filter(MAJORNUM == 1 & CIPCODE == "99" & CTOTALT > 0 & (AWLEVEL == "05" | AWLEVEL == "17")) %>%
	inner_join(doc_institutions, ., by="UNITID") %>%
	select(-CIPCODE, -MAJORNUM, -starts_with("X"))
```

```
## Error: 'ipdeds/c2018_a.csv' does not exist in current working directory ('/Users/pschloss/Documents/websites/riffomonas/generalR').
```

I'm interested in getting a plot for the fraction of women that graduated with bachelor's or doctorate degrees. We've already seen how to calculate the fraction of women, let's expand that to include these other categories and then simplify our data frame a bit


```r
doc_degree_rates <- doc_degrees %>%
	mutate(f_women = CTOTALW / CTOTALT) %>%
	select(UNITID, INSTNM, AWLEVEL, f_women)
```

```
## Error in eval(lhs, parent, parent): object 'doc_degrees' not found
```

Like before, we can plot these data with a boxplot


```r
doc_degree_rates %>%
	ggplot(aes(x=AWLEVEL, y=f_women)) +
		geom_boxplot()
```

```
## Error in eval(lhs, parent, parent): object 'doc_degree_rates' not found
```

From these data, it appears that the fraction of women who graduate with a doctorate is less than those that graduate with a bachelor's degree. Alternatively, we could plot the data as a slope plot by connecting the bachelor's rate to the doctorate rate.


```r
doc_degree_rates %>%
	ggplot(aes(x=AWLEVEL, y=f_women, group=UNITID)) +
		geom_line()
```

```
## Error in eval(lhs, parent, parent): object 'doc_degree_rates' not found
```

It would be good to quantify the difference between the representation at the two award levels. You should be thinking about using `group_by` and `summarize`. The challenge is that we would like to group by institution and calculate the difference between the two levels. Unfortunately, we can't easily calculate the difference between rows; only columns. To pull this off, we need to spread our `f_women` column across two columns corresponding to the two award levels. To do this, we will use the `pivot_wider` function. To demonstrate it, let's simplify our `doc_degree_rates` data frame a bit.


```r
doc_degree_rates %>%
	select(INSTNM, AWLEVEL, f_women)
```

```
## Error in eval(lhs, parent, parent): object 'doc_degree_rates' not found
```

What we'd like is one line for each institution and three columns - `INSTNM`, `05`, and `17`. The `05` and `17` columns would have the `f_women` data for each institution. We'll do this with `pivot_wider`


```r
doc_degree_rates %>%
	select(INSTNM, AWLEVEL, f_women) %>%
	pivot_wider(names_from=AWLEVEL, values_from=f_women)
```

```
## Error in eval(lhs, parent, parent): object 'doc_degree_rates' not found
```

It worked - great! You should be able to see that the column names camed from `AWLEVEL` and hte values came from `f_women`. Now we can calculate the difference with a `mutate` function


```r
doc_degree_rates %>%
	select(INSTNM, AWLEVEL, f_women) %>%
	pivot_wider(names_from=AWLEVEL, values_from=f_women) %>%
	mutate(difference = `05` - `17`)
```

```
## Error in eval(lhs, parent, parent): object 'doc_degree_rates' not found
```

Finally, we can summarize the median representation for each award level as well as for the drop in women using `median`. Notice that we are using `summarize` without `group_by`


```r
doc_degree_rates %>%
	select(INSTNM, AWLEVEL, f_women) %>%
	pivot_wider(names_from=AWLEVEL, values_from=f_women) %>%
	mutate(difference = `05` - `17`) %>%
	summarize(med_bachelors = median(`05`, na.rm=T),
		med_doctorate = median(`17`, na.rm=T),
		med_difference = median(difference, na.rm=T))
```

```
## Error in eval(lhs, parent, parent): object 'doc_degree_rates' not found
```

At the most extensive doctorate institution, the percentage of women earning a doctorate degree after earning a bachelor's falls by nearly 6 percentage points or more than 10%.

Questions
* Repeat the cross Carnegie category analysis with the "Black or African American" data

* Repeat the gender analysis with the "Doctoral/Research Universities--Extensive" Carnegie category

* Repeat the gender analysis with the "Doctoral/Research Universities--Extensive" Carnegie category, but use the "Black or African American" data
