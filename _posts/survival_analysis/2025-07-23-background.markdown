---
layout: post
title:  "Survival Analysis: Background"
date:   2025-07-23 12:30:48 -0500
categories: [survival]
hidden: true
# published: false
---


Survival analysis is a branch of statistics for analyzing time-to-event data. The event could be anything of interest significant to our analysis - death, failure of a manufacturing device, cloud-system failure, remission/re-emergence of cancer symptoms, loan default etc. We are interesting in knowing different aspects of the event - the probability of event, time remaining to event, mean time to event.
Examples:
1. Medical Application: 
    * We estimate the survival time of patient to assess the effectiveness of a treatment. Ex: chemotherapy
    * Data used: patient age, pre-existing conditions, tumor size, health history, fitness rating
2. Financial Application:
    * We estimate time until customer defaults on a personal credit loan
    * Data used: Loan amount, credit history, credit score, existing loans, loan term, income

There are various functions that help analyze these events:

### Survival function

Survival function is the probability that event of interest has not occured after time $t$, denoted as $ S(t) = P(T > t)$. Ex. we can answer the question what is the probability that a patient survives for more than 12 months after surgery? This is a non-increasing monotonic function with two important conditions:

1. $S(0) = 1 \Rightarrow$ none of our candidates/processes have seen the event at the start $t=0$
2. $S(t) \rightarrow 0 \text{ as } t \rightarrow \infty \Rightarrow$ all candidates/processes are going to see the event eventually.


<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/background/survival.svg" width="70%" style="margin:17px;"> </div>
*Figure 1: a typical survival function that starts at 1 and drops to 0 with time $t$. A steeper drop indicates higher risk/hazard.*