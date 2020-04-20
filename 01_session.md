---
layout: lesson
title: "Session 1"
output: markdown_document
---

## Topics
*




### Motivation...
* Jaw dropping heatmaps based on Project Tycho data
* Debate over whether the heatmaps were an effective means of displaying the data
* Wanted to check out the data and found the Project Tycho dataset
* Surprised by the variety of diseases that the researchers have aggregated over a long period of time
* My questions - is Lyme disease spreading west? As a Michigander should I be worried? Should my in laws in Missouri be worried?


### Show answer


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
	geom_line() +
	scale_y_continuous(limits=c(0,NA)) +
	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()

ggsave("lyme_disease_annual_counts.pdf", width=6, height=4)
```

<img src="assets/images/01_session//unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" width="504" />

Our goals are to:
* use this to understand a common data analysis pipeline in R
* modify this to plot by state
* plot other diseases



### Syntax

* R is expressive
  - the (best) function names are verbs that tell us what the code will do - read_csv, filter, mutate, group_by, summarize, ggplot
  - we can define variables (e.g. `annual_counts`) that can be used as input to other functions (e.g. `gg_plot`)
  - In R, we typically use the `<-` to assign the values on the right to the variable name on the left. You could use an `=`, but to R users, it will look weird. Here we took the output of the pipe starting with `read_csv` through `summarize` and assigned it to `annual_counts`. We then used that variable as input to `ggplot`
* R isn't just for statistics
	- others can contribute code as packages with useful functions that aren't in the vanilla version of R (e.g. all of the functions above, but especially lubridate for working with date data ~ `year()`)
	- there are powerful graphics abilities through both base R and ggplot (as part of tidyverse). although beyond the scope of this series, everything in the plot we just generated can be manipulated from the type of plot through the font choice
	- we can express a series of commands as a pipeline using a pipe character (i.e. `%>%`)


### Figuring things out
* Each line in the following code chunk does something. You can remove code by deleting it or by putting a `#` before the code you want to ignore


```r
ggplot(annual_counts, aes(x=year, y=count)) +
	geom_line() +
	scale_y_continuous(limits=c(0,NA)) +
#	scale_x_continuous(breaks=c(1990, 1995, 2000, 2005, 2010, 2015)) +
	labs(x="Year",
			y="Number of cases",
			title="The number of Lyme disease cases has been rising since 1990") +
	theme_classic()
```

<img src="assets/images/01_session//unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" width="504" />

Notice a difference? Try this with other lines in the code chunk and see if you can figure out what each line does. Feel free to play with the code by changing argument values. That is how many people, including me, have learned to program in R! You can keep copies of code that works to go back to. You aren't going to break anything by experimenting.


Questions:
* What line of code is responsible for generating the line in the plot?
* How can you remove the `theme_classic()` function call without deleting any code?
* Can you get the plot to show data for 1990, 2000, 2010, and 2020?
* What will happen if you set the `limits` argument value for `scale_y_continuous` to `c(0, 10000)`?
* We won't get to discuss much about the options for themes. The `theme()` function is what allows you to change all the little things in the plot like font, font size, spacing, etc. There are a variety of preset theme options that have their own function name. We used `theme_classic()`. Others include `theme_bw`, `theme_dark`, `theme_gray`, `theme_light`, `theme_linedraw`, and `theme_minimal`. Other R users have developed their own themes that they have made available for others to you. You can find some in the [`ggthemes` package](https://jrnold.github.io/ggthemes/index.html). Which of the built in themes provides a plot that looks like the plot when you removed the `theme_classic` line? Which theme do you like the most?