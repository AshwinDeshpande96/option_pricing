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

There are four functions that help analyze these events: 

* Survival function - $S(t)$
* pdf/pmf - $f(t)$/$p(t)$
* Hazard function - $h(t)$
* Mean residual life - $\text{mrl}(t)$

If we know one of the four functions we can determine the other three uniquely. Additionally we may be interested in calculating cumulative hazard function $H(t)$. An intuitive way of understanding $H(t)$ is the total risk experienced by the system up to time $t$.

### Survival function

Survival function is the probability that event of interest has not occured until time $t$, denoted as $ S(t) = P(T > t)$. Ex. we can answer the question what is the probability that a patient survives for more than 12 months after surgery? This is a non-increasing monotonic function with two important conditions:

1. $S(0) = 1 \Rightarrow$ none of our candidates/processes have seen the event at start time $t=0$
2. $S(t) \rightarrow 0 \text{ as } t \rightarrow \infty \Rightarrow$ all candidates/processes are going to see the event eventually.


<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/background/survival.svg" width="70%" style="margin:17px;"> </div>
*Figure 1: a typical survival function that starts at 1 and drops to 0 with time $t$. A steeper drop indicates higher risk/hazard.*

Survival functions are used to compare life of an entity across sub-groups (treatment vs control, male vs female), for example in a factory if $S_{\text{new}}(12) > S_{\text{old}}(12)$ the newer machine is more likely to survive in the given time-frame. These helps assess risk/hazard in comparison to a baseline (old baseline vs new experimental drug, good proven customer vs new risky customer). We have a discrete random variable $T$ for the lifetimes, such that $T$ takes one values $t_{i}$, $i = 1,2,...$ where $t_1 < t_2 < ..$ and $p(t_i)$ is the probability mass function. Then, the survival function is given by


$$S(t_i) = Pr(T > t_i) = \sum_{t > t_i} p(t)$$

Suppose we have a discrete uniform *pmf* $P(T=t_j) = 1/3$, for $j = 1,2,3$ the survival function has the value $S(1) = 1$, $S(2) = 2/3$, $S(3) = 1/3$, $S(4) = 0$.

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/background/survival_discrete_uniform.svg" width="70%" style="margin:17px;"> </div>
*Figure 1: survival function for a discrete uniform random variable.*

When the lifetime $X$ is a continuous random variable the survival funtion is the integral of the probability density function $f(x)$.


$$S(x) = Pr(X > x) = \int_{x}^{\infty} f(t) \text{ }dt$$

$$Pr(X > x) = 1 - \int_{0}^{x} f(t) \text{ }dt = 1 - F(x)$$

<div align='center'> Eq 1: survival function definition </div>

$F(x)$ is the cumulative pdf since $F(x) = Pr(X \leq x)$.


### pmf/pdf

The *pdf* or *pmf* is the unconditional probability that the event occurs at time $t$. From eq(1) we can define pdf in terms of the survival function as follows:

$$S(x) = 1 - F(x)$$

$$\frac{d(S(x))}{dx} = \frac{d(1 - F(x))}{dx} = -\frac{d(F(x))}{dx}$$

since derivate of cdf is the pdf $ \rightarrow \frac{d(F(x))}{dx} = f(x)$

$$\frac{d(S(x))}{dx} = -f(x)$$

$$f(x) = - \frac{d(S(x))}{dx}$$

The negative sign explains the relation between survival and the pdf. Since survival function is a non-increasing function and the rate at which survival function decreases is exactly equal to the pdf at $x$. See fig(1), where the survival function decrease exactly at the constant rate defined by its discrete uniform distribution.