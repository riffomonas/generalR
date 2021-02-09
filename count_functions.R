#!/usr/bin/env Rscript --vanilla

library(tidyverse)

count_function_usage <- function(session) {

	md_file <- paste0("_rmd_files/", str_pad(session, width=2, side="left", 0), "_session.Rmd")

	scan(md_file, what="character", quiet=TRUE) %>% str_subset("[a-zA-Z_.]+\\(")

	function_lines <- scan(md_file, what="character", quiet=TRUE) %>%
		str_subset("[a-zA-Z_.]*[a-zA-Z]\\(") %>%
		str_subset("names_pattern", negate=T) %>% #use parentheses to define regular expressions
		str_subset("‘", negate=T) %>% #use parentheses to define regular expressions
		str_replace_all("\\(", "( ") %>%
		str_split(" ") %>%
		unlist() %>%
		str_subset("[a-zA-Z_.]+\\(") %>%
		str_replace_all(".*\\n", "")

	stopifnot(!any(str_detect(function_lines, "\\(.*\\(")))

	function_count <- function_lines %>%
		str_replace(".*?([a-zA-Z_.]+\\()", "\\1") %>%
		enframe(name=NULL, value="function_name") %>%
		count(function_name) %>%
		mutate(session = session) %>%
		filter(function_name != "set(") %>% # every Rmd file has knitr set functions in the header
		mutate(n = ifelse(function_name == "library(", n-2, n)) # every Rmd file has 2 library calls in header

	any_problems <- function_count %>%
		mutate(ok = str_detect(function_name, "\\).*\\(")) %>%
		summarize(sum = sum(ok)) %>%
		pull(sum)
	stopifnot(any_problems == 0)

	return(function_count)
}

function_usage <- map_dfr(1:15, count_function_usage)

session_with_most_use <- function_usage %>%
	group_by(function_name) %>%
	mutate(percentage = 100 * n / sum(n), total = sum(n)) %>%
	top_n(percentage, n=1) %>%
	ungroup() %>%
	arrange(session) %>%
	rename(dominant_session = session) %>%
	select(function_name, dominant_session)

function_usage %>%
	group_by(function_name) %>%
	mutate(percentage = 100 * n / sum(n), total = sum(n)) %>%
	ungroup() %>%
	inner_join(., session_with_most_use, by="function_name") %>%
	mutate(function_name = fct_reorder(function_name, dominant_session)) %>%
	ggplot(aes(x=session, y=function_name, fill=percentage)) +
		geom_tile() +
		scale_fill_gradient(name=str_wrap("% of mentions"), low="white", high="red") +
		labs(x="Session", y=NULL) +
		scale_x_continuous(minor_breaks=1:15)

ggsave("functions.png")

function_usage %>% group_by(function_name) %>% summarize(total = sum(n), n_sessions = n()) %>% arrange(desc(total))

function_usage %>% group_by(function_name) %>% summarize(total = sum(n), n_sessions = n()) %>% arrange(desc(n_sessions))
