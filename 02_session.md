---
layout: lesson
title: "Session 2"
output: markdown_document
---

## Topics
*




Now let's see how we can manipulate various aesthetics about the line we are plotting with the `geom_line` and see if we can make a different type of plot. There are many geom's available to us for making different types of plots. We've seen `geom_line`. Let's try two others to make a scatter plot and a barchart


```r
library(tidyverse)
library(lubridate)

annual_counts <- read_csv("project_tycho/US.23502006.csv",
			col_type=cols(PartOfCumulativeCountSeries = col_logical())) %>%
	filter(PartOfCumulativeCountSeries) %>%
	mutate(year = year(PeriodStartDate+7)) %>%
	group_by(year) %>%
	summarize(count = max(CountValue))


ggplot(annual_counts, aes(x=year, y=count)) +
	geom_point() +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="504" />



```r
ggplot(annual_counts, aes(x=year, y=count)) +
	geom_col() +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="504" />

Of the three types of plots we've made, which do you like better? Most professional data visualization practitioners would prefer the line plot. The line connecting the points indicates continuity and it has a fairly elegant and minimalist presentation compared to a bar plot. Each `geom` has its own set of aesthetics that can be manipulated when we plot the data. For example, `geom_line` has `color`, `linetype`, `size`. I know this because if I use the RStudio help menu to search for `geom_line` or if I run `?geom_line` from the R prompt, I get the help page for the function. The first thing I learn is that there are three types of line plots that I can use within the ggplot framework - `geom_path`, `geom_line`, and `geom_step`. These all have very similar syntax, but do slightly different things. As you scan through this help page, you will find a section called "Aesthetics" that tells you what thing can be manipulated for these commands.

```
Aesthetics:

     ‘geom_path()’ understands the following aesthetics (required
     aesthetics are in bold):
        • *‘x’*
        • *‘y’*
        • ‘alpha’
        • ‘colour’
        • ‘group’
        • ‘linetype’
        • ‘size’

     Learn more about setting these aesthetics in
     ‘vignette("ggplot2-specs")’.
```

Clearly `x` and `y` are going to be required. We'll talk about it in a bit, but we set those in the line `ggplot(annual_counts, aes(x=year, y=count))`.

### Questions
* What aesthetic values are available for use with `geom_point` and `geom_col`?
* Can you see a difference between `geom_line`, `geom_path`, and `geom_step`? Why might you not see a difference between the output for `geom_line` and `geom_path`?


Let's see how we can manipulate these aesthetics.

* color

`colors()`


```r
ggplot(annual_counts, aes(x=year, y=count)) +
	geom_line(color="red") +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" width="504" />

hexidecimal


```r
ggplot(annual_counts, aes(x=year, y=count)) +
	geom_line(color="#1177FF") +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" width="504" />

* size


```r
ggplot(annual_counts, aes(x=year, y=count)) +
	geom_line(size=2) +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" width="504" />

* linetype

linetype cheat sheet


```r
ggplot(annual_counts, aes(x=year, y=count)) +
	geom_line(linetype=2) +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-6-1.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" width="504" />

* plotting symbol

plotting symbol cheat sheet


```r
ggplot(annual_counts, aes(x=year, y=count)) +
	geom_point(shape=8) +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" width="504" />

* fill


```r
ggplot(annual_counts, aes(x=year, y=count)) +
	geom_col(fill="blue") +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-8-1.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" width="504" />

* Mapping aesthetics to our data
We have been putting the aesthetic and its value in the parentheses for the `geom_` function. When we do that, the value is applied to all of the points. For example, in the last example showing `fill`, all of the bars were the same color. Often, we want the aesthetic value to vary by something in our data frame. Recall that `x` and `y` are aesthetics. Can you see how we might make each year's bar a different color?


```r
ggplot(annual_counts, aes(x=year, y=count, fill=year)) +
	geom_col() +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/02_session//unnamed-chunk-9-1.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="504" />

You'll note that we removed `fill="blue"` from `geom_col()` and put `fill=year` into the `aes` function within the `ggplot` function call. In this example, year is a *continuous* variable so we get a gradient of blues. Later we'll see how this changes when the variable is a *categorical* variable.


### Questions
* what does alpha do?
* what happens if we use `color="blue"` rather than `fill="blue"` as a `geom_col` argument? Try using both arguments, but so that `color` and `fill` have different values
* what happens when you try to map the year to the `shape` aesthetic when using `geom_point`? Can you find another aesthetic to map to the year or color variables that will work?
* wesanderson, beyonce, gradient color palettes.
