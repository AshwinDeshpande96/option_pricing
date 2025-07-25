---
layout: post
title:  "Survival Analysis: Background"
date:   2025-07-23 12:30:48 -0500
categories: [survival]
hidden: true
# published: false
---


Survival analysis is a branch of statistics for analyzing time-to-event data. The event could be anything of interest significant to our analysis - death, failure of a manufacturing device, cloud-system failure, remission/re-emergence of cancer symptoms, loan default etc. We are interested in knowing different aspects of the event - the probability of event, time remaining to event, mean time to event.
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

If we know one of the four functions we can determine the other three uniquely. Additionally we may be interested in calculating cumulative hazard function $H(t)$. $H(t)$ is the total risk experienced by the system up to time $t$.

### Survival function

Survival function is the probability that event of interest has not occured until time $t$, denoted as $ S(t) = P(T > t)$. Ex. we can answer the question what is the probability that a patient survives for more than 12 months after surgery? This is a non-increasing monotonic function with two important conditions:

1. $S(0) = 1 \Rightarrow$ none of our candidates/processes have seen the event at start time $t=0$
2. $S(t) \rightarrow 0 \text{ as } t \rightarrow \infty \Rightarrow$ all candidates/processes are going to see the event eventually.


<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/background/survival.svg" width="70%" style="margin:17px;"> </div>
*Figure 1: a typical survival function that starts at 1 and drops to 0 with time $t$. A steeper drop indicates higher risk/hazard.*

Survival functions are used to compare life of an entity across sub-groups (treatment vs control, male vs female), for example in a factory if $S_{\text{new}}(12) > S_{\text{old}}(12)$ the newer machine is more likely to survive in the given time-frame. These helps assess risk/hazard in comparison to a baseline (old baseline vs new experimental drug, good proven customer vs new risky customer). We have a discrete random variable $T$ for the lifetimes, such that $T$ takes one values $t_{i}$, $i = 1,2,...$ where $t_1 < t_2 < ..$ and $p(t)$ is the probability mass function. Then, the survival function is given by


$$S(t_i) = Pr(T > t_i) = \sum_{t > t_i} p(t)$$

Suppose we have a discrete uniform *pmf* $P(T=t_j) = 1/3$, for $j = 1,2,3$ then survival function has the value $S(1) = 1$, $S(2) = 2/3$, $S(3) = 1/3$, $S(4) = 0$.

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/background/survival_discrete_uniform.svg" width="70%" style="margin:17px;"> </div>
*Figure 1: survival function for a discrete uniform random variable.*

When the lifetime $X$ is a continuous random variable the survival funtion is the integral of the probability density function $f(x)$.


$$S(x) = Pr(X > x) = \int_{x}^{\infty} f(t) \text{ }dt$$

$$Pr(X > x) = 1 - \int_{0}^{x} f(t) \text{ }dt = 1 - F(x)$$

<div align='center' id='eq1'> <i> Eq 1: survival function definition </i></div>

$F(x)$ is the cumulative pdf since $F(x) = Pr(X \leq x)$.



### pmf/pdf

The *pdf* or *pmf* is the unconditional probability that the event occurs at time $t$. In accordance with basic probability principles, it is required that the area under pdf/pmf is 1 & $f(x)$/$p(x)$ is non-negative for any $x$. From [eq(1)]({{ "/survival/2025/07/23/background#eq1" | relative_url }}) we can define pdf in terms of the survival function as follows:

$$S(x) = 1 - F(x)$$

Taking the derivative with respect to x on both sides, 

$$\frac{d(S(x))}{dx} = \frac{d(1 - F(x))}{dx} = -\frac{d(F(x))}{dx}$$

since derivative of cdf is the pdf $ \rightarrow \frac{d(F(x))}{dx} = f(x)$

$$\frac{d(S(x))}{dx} = -f(x)$$

$$f(x) = - \frac{d(S(x))}{dx}$$

<div align='center' id='eq2'> <i> Eq 2: survival function relation to pdf </i> </div>

The negative sign explains the relation between survival and the pdf. Since, survival function is a non-increasing function and the rate at which survival function decreases is exactly equal to the pdf at $x$. See fig(1), where the survival function decreases at the constant rate defined by its discrete uniform pdf.

### Hazard function

Hazard function is defined as the probability that the event would occur in the next instant, given that the event has not occured as of yet. Mathematically that would be the conditional probability of event occuring in the next tiniest interval ($x \leq X < x + \Delta x$) given event hasn't occured ($X \geq x$) per unit time $\Delta x$.

$$\lambda(x) = \lim_{\Delta x \to 0} \frac{P(x \leq X < x + \Delta x | X \geq x)}{\Delta x}$$

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/background/hazard_area.svg" width="70%" style="margin:17px;"> </div>

Figure 2: pdf represents the area under the curve between an interval. When the interval is infinitesimally small the shape of the area is approximately a rectangle.

Consider the fig(2), $P(a \leq X < b) \approx f(a) \cdot (b-a)$. When $[\Delta x = b-a]$ is infinitesimally small the vertical length a & b is approximately the same $a = b = f(x)$. The area under the curve is approximately area of a rectangle $area =f(x) \cdot \Delta x$. Hence,

$$P(x \leq X < x + \Delta x) \approx f(x) \cdot \Delta x$$

Since the inequality $X \geq x$ is present in $(x \leq X < x + \Delta x)$ we have,

$$P(x \leq X < x + \Delta x | X \geq x) = \frac{P((x \leq X < x + \Delta x) \& (X \geq x) )}{P(X \geq x)} = \frac{P(x \leq X < x + \Delta x )}{P(X \geq x)}$$

We also know that $S(x) = P(X \geq x)$,

$$\lambda(x) = \lim_{\Delta x \to 0} \frac{\frac{f(x) \cdot \Delta x}{S(x)}}{\Delta x} = \lim_{\Delta x \to 0} \frac{f(x) \cdot \Delta x}{S(x) \cdot \Delta x}$$

$$\lambda(x) = \frac{f(x)}{S(x)}$$

Also from [eq(2)]({{ "/survival/2025/07/23/background#eq2" | relative_url }}),

$$\lambda(x) = \frac{1}{S(x)} \cdot \left[-\frac{d(S(x))}{dx}\right] = - \frac{d(ln[S(x)])}{dx}$$

Hence the **cumulative hazard function** is 

$$H(x) = \int_{0}^{\infty}  h(u) \text{ } du = - ln[S(x)]$$

<div align='center' id='eq3'> <i> Eq 3: hazard function relation to survival hazard </i> </div>

Inversely, 

$$S(x) = exp(-H(x)) = exp\left(-\int_{0}^{\infty}  h(u) \text{ } du\right) $$

#### Discrete random variable

Hazard function for discrete random variable $X$ is given by

$$h(x_j) = Pr(X = x_j | X > x_j) = \frac{p(x_j)}{S(x_{j-1})}$$

Since $S(x_{j-1}) - S(x_j) = P(X > x_{j-1}) - P(X > x_{j})$ we then have $p(x_j) = S(x_{j-1}) - S(x_j)$. Hence,

$$h(x_j) = 1 - \frac{S(x_j)}{S(x_{j-1})}$$

Since we know $S(x_0) = 1$. Consider,

$$S(x) = \prod_{x_j \leq x} \frac{S(x_j)}{S(x_{j-1})} = \frac{S(x_1)}{S(x_0)} \cdot \frac{S(x_2)}{S(x_1)} \cdot \text{ ... } \cdot \frac{S(x_{n-1})}{S(x_{n-2})} \cdot \frac{S(x)}{S(x_{n-1})} $$

$$ S(x) = \prod_{x_j \leq x} \left[ 1 - h(x_j)\right]$$

From [eq(3)]({{ "/survival/2025/07/23/background#eq3" | relative_url }}),

$$H(x) = - ln\left(\prod_{x_j \leq x} \left[ 1 - h(x_j)\right]\right)$$

$$H(x) = - \sum_{x_j \leq x} ln\left[ 1 - h(x_j)\right]$$

<div align='center' id='eq4'> <i> Eq 3: cumulative hazard function relation to hazard function</i> </div>

### Mean residual life

The mean residual life at time $x$ measures the average remaining lifetime of individuals whose current age is $x$. Mathematically mean residual life is defined as the expected remaining life given that event has not occured yet i.e. $\mathbb{E}(X-x \| X > x)$. Mean life is mean residual life at time 0 i.e. $\text{mrl}(0) = \mu$. When mean residual life is constant i.e. $\text{mrl}(0) = \text{mrl}(x)$ the property is called **memoryless**. Memorylessness, tells us that the function is independent of time and remains the same if you check $mrl$ now or an arbitrary time period later. 

When we have a continuous random variable, 

$$\mathbb{E}(Y|A) = \frac{1}{P(A)} \cdot \int Y \cdot f_{Y|A}(y) \text{ } dy $$

Hence the mean residual life,

$$mrl(x) = \mathbb{E}(T-x|T > x) = \frac{1}{P(T>x)} \cdot \int (t-x) \cdot f_{T-x|T>x}(y) \text{ } dy $$

To apply the condition $X > x$ 


$$mrl(x) = \frac{1}{S(x)} \cdot \int_{x}^{\infty} (t-x) \cdot f(t) \text{ } dt $$

Consider $\int_{x}^{\infty} (t-x) \cdot f(t) \text{ } dt$,

Using integration by parts we determine,

* $u = t-x$
* $dv = f(t) dt$
    * $\int_{t}^{\infty} dv = \int_{t}^{\infty} f(t) dt $ 
    * $ v = \int_{t}^{\infty} \left[ \frac{d(S(t))}{dt} \right] \Rightarrow v = S(\infty) - S(t)$
* $v = -S(t)$