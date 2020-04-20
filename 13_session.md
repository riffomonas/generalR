---
layout: lesson
title: "Session 13"
output: markdown_document
---

## Topics
*




In the last lesson we looked at the representation of women among people graduating with a Bachelor's degree at different types of institutions and at the difference in representation of women who graduated from large research extensive universities with a bachelor's degree and a doctorate degree. To achieve this, we used a number of functions we had seen in previous lessons but in a new context: `read_csv`, `read_excel`, `filter`, `group_by`, `summarize`, `select`, `inner_join`, and `arrange`. We also met some new functions including those to plot continuous data against categorical data like `geom_jitter`, `geom_boxplot`, and `geom_violin`. We also learned how to move rows to columns using `pivot_wider`. We put this all to good effect to see some interesting relationships in the data, namely, there's evidence for a "leaky pipeline" as women move from a bachelor's to doctoral degree program.

In this lesson, I want to revisit some of the ideas in the exercises to see the difference in representation of other groups who are generally poorly represented in science. Like the exercises, we could repeat the analysis we did for women, substituting each women for each group. We'll do it better in this analysis, building upon those earlier concepts and using a new function, `pivot_longer`.
