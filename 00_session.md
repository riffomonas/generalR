---
layout: lesson
title: "Session 0"
output: markdown_document
---

## Content
* Philosophy behind these instructional materials
* Why R?
* Introduction to R
* Getting settled in RStudio
* Setting up a project

## Philosophy
I have never taken a course or workshop in using R. I've read a lot of books on how to program with R. To be honest, I'm not sure how much they helped. I learned R by taking a single script that I wrote to create a scatter plot and modifying it or "hacking it" to get it to do what I wanted. If I ran into a problem, I would either google the error message or the question I was trying to answer. As I asked around, I learned that most people learned R by hacking their way to success along with a lot of practice. That is the underlying philosophy of this series of lessons. Most programming books slowly build to something useful with silly examples along the way. The first code you will write in Session 1 will be the basis of every other piece of code we write in these tutorials. We will start with working code for a plot that could be published and hack it until we have a plot showing which taxa are associated with health or disease.

I suspect that you will understand the first chunk of code we write. We will strive for readable code that is easy to understand. That being said, just because you suspect that the `geom_point` function will add points to a plot, doesn't mean that you know how to use `geom_point` or that you would know how to make a bar chart. Calmly accept your ignorance and know that all will be explained eventually. Learning experts have found that we do not learn best by taking on a topic and beating it to death until we've mastered it. Rather, we learn best when we learn something partially, move on to something else that we also learn partially, but can fold in the previous knowledge to help us improve our partial knowledge of the earlier topic. It's kind of like taking steps forward in a dark room only to get to the end and see that you knew the path all the way along. This is the approach that we will be taking with these lessons. My goal is not to provide a reference on R or to necessarily document every nook and cranny of the language and its myriad packages. I will empower you to do that.

The final philosophical point I will make is that I believe it is important to preach what you practice as an educator. Everything I teach, is how I want to code and how I want those that work for me to code. There is definitely always room for improvement, but be confident that I'm not trying to sell you on something that I do not use myself. That being said, although I don't claim that the plots we'll make are works of aRt, I do think that they're pretty close to being publication quality. Why make a crappy plot, when you could make a good one that puts your work in the best possible light?

If you notice a bug, something that is unclear, have an idea for a better approach, or want to see something added, please file an issue or, even better, a pull request at the project's [GitHub repository](https://github.com/riffomonas/generalR).

## Why R
If you're looking for some big "pound your chest" explanation for why you should learn R, then you're looking in the wrong place. I know R. That's why I teach R. Why did I learn R? There were people around me that new R and I knew I could depend on them to help me learn R if I ran into any problems. Less important than which language you should learn is that you learn *A* language. Any language, really.

The way I see it there are several credible languages if you are a scientist: R, Python, C/C++, Java. R and Python are "high level" languages that have a lot of built in goodies to make your life easy. As you'll see, it's pretty easy to build a graph or to calculate a mean in R (and python). These languages are engineered to make it easier on the programmer than the person running the code. In contrast, C/C++ and Java are not as easy to program, but are far more efficient and run blazing fast. You'll hear about others like Julia, Ruby, or Perl. These aren't quite mainstream for biologists or aren't fully developed yet or are past their sell by date. Unless you have needs for high performance, I'd probably stay away from C/C++ and Java isn't really all that high performance. If you need the speed of C++ you can write C++ in R.

This leaves you to chose between R and Python. You can google "Should I learn R or Python" and you'll get screed after screed telling you why one language is the best. Do not read these. They're next to worthless and smack of all sorts of machismo. I block accounts on Twitter that go off on R vs. Python screeds. I know R's warts and I know that Python could possibly cure these warts. But I also know that Python has its own warts. Rather than carry the cognitive baggage of learning both, I do what I need in R. At least a few times a year I tell myself I should learn Python to know it, but when it comes to doing it, I'm just not sold. To be honest, to really appreciate the differences between the languages you probably need a fair bit more experience than someone that is reading this. Note that someone else could/should easily rewrite this paragraph switching R and Python.

But really! What should you learn? Depends. What does your research group use? What do your collaborators use? What do the people around you use? If you have a problem, who are you going to get help from? For me, the answers to these questions were generally: R. Again, it's more important that you learn your first language than which language you learn. Master your first language and then start noodling with others. I always cringe when I see someone encouraging a novice to learn other languages. It can only sow confusion and frustration. Since you're here, I suspect someone has encouraged you to learn R or that your local community has some R chops. Welcome! I want to challenge you to not just use your community to help you, but to also nourish your community to help it grow.


## What you need to do these tutorials...
* [R](https://cloud.r-project.org/)
* Text editor (e.g. [atom](https://atom.io)) or [RStudio](https://www.rstudio.com/products/rstudio/download/#download)
* You will need to install the `tidyverse` R package. You can do this by entering `install.packages("tidyverse", dependencies=TRUE)`.
* [Raw data files](https://github.com/riffomonas/generalR_data/releases/latest). This will download a directory called `raw_data-X.X` where the "X.X" is the version number. Remove the `-X.X` and make sure the directory is uncompressed. ***This is super important!*** Once you have done this, you can double click on the `generalR.Rproj` file to launch RStudio with this directory as the working directory.




## My setup
If you run `sessionInfo` at the console, you will see the version of R and the packages you have installed and attached (more about what this all means later). Here's what mine looks like.




```r
sessionInfo()
```

```
## R version 3.6.3 (2020-02-29)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: macOS Mojave 10.14.6
##
## Matrix products: default
## BLAS:   /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRblas.0.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib
##
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
##
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
##
## other attached packages:
##  [1] forcats_0.5.0   stringr_1.4.0   dplyr_0.8.4     purrr_0.3.3    
##  [5] readr_1.3.1     tidyr_1.0.2     tibble_2.1.3    ggplot2_3.2.1  
##  [9] tidyverse_1.3.0 knitr_1.28      ezknitr_0.6    
##
## loaded via a namespace (and not attached):
##  [1] Rcpp_1.0.3        cellranger_1.1.0  pillar_1.4.3      compiler_3.6.3   
##  [5] dbplyr_1.4.2      R.methodsS3_1.8.0 R.utils_2.9.2     tools_3.6.3      
##  [9] lubridate_1.7.4   jsonlite_1.6.1    evaluate_0.14     lifecycle_0.1.0  
## [13] nlme_3.1-144      gtable_0.3.0      lattice_0.20-38   pkgconfig_2.0.3  
## [17] rlang_0.4.5       reprex_0.3.0      cli_2.0.2         rstudioapi_0.11  
## [21] DBI_1.1.0         haven_2.2.0       xfun_0.12         withr_2.1.2      
## [25] xml2_1.2.2        httr_1.4.1        fs_1.3.1          hms_0.5.3        
## [29] generics_0.0.2    vctrs_0.2.3       grid_3.6.3        tidyselect_1.0.0
## [33] glue_1.3.1        R6_2.4.1          fansi_0.4.1       readxl_1.3.1     
## [37] modelr_0.1.6      magrittr_1.5      backports_1.1.5   scales_1.1.0     
## [41] rvest_0.3.5       assertthat_0.2.1  colorspace_1.4-1  stringi_1.4.6    
## [45] lazyeval_0.2.2    munsell_0.5.0     broom_0.5.5       crayon_1.3.4     
## [49] R.oo_1.23.0
```
