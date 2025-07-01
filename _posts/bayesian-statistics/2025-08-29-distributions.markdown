---
layout: post
title:  "Distributions"
date:   2025-06-29 12:30:48 -0500
categories: [bayesian]
hidden: true
# published: false
---

### 1. Discrete

#### 1.1. Bernoulli Distribution

<div id='bernoulli'></div>

This distribution is used to model a single event that has a binary outcome. The two outcomes can be any binary process (Coin flip: Head/Tail, Win a game: Yes/No, Direction to take: Left/Right) one of which is assigned a value 1 and the other 0 depending on the application. The value 1 occurs with a probability $p$ and value 0 occurs with probability $q=1-p$. If $X$ follows a Bernoulli distribution we write $X \sim \text{Bern}(p)$.

Probability mass function is given by:

$$f(x) = p^x \cdot (1-p)^{1-x}, \text{where } x \in \{0, 1\}$$

| Mean       | Variance            |    
| :--------: | :-----------------: |
| $E[X] = p$ | $Var[X] = p(1-p)$|

#### 1.2. Binomial Distribution

<div id='binomial'></div>

This distribution is used to model multiple events that have a binary outcome. The two outcomes can be any binary process (Multiple coin flips: Head/Tail, Numbers of wins in a tournament: Yes/No). One of the outcomes is assigned a value 1 and the other 0 depending on the application. The value 1 occurs with a probability $p$ and value 0 occurs with probability $q=1-p$. If $X$ follows a Binomial distribution we write $X \sim B(n, p)$.

Probability mass function gives us the probability of $k$ successes in $n$ independent  Bernoulli trials. The independence indicates that the probability of success $p$ remains the same for each trial. The *pmf* is given by:

$$f(x) = \binom{n}{x} \cdot p^x \cdot (1-p)^{n-x}, \text{for } x \in \{0, 1, 2, ..., n\}$$

| Mean       | Variance            |    
| :--------: | :-----------------: |
| $E[X] = np$ | $Var[X] = np(1-p)$|

#### 1.3. Multinomial Distribution

<div id='multinomial'></div>

The multinomial distribution extends the binomial distribution to $n$ trials of $k$ outcomes. This can modeled as $n$ throws of k sided dice. Each of the k outcomes is assigned a probability $p_{i}$ where $\sum_{i}^{k} p_{i} = 1$. If $X$ follows a multinomial distribution we write $X \sim \text{Multinomial}(n, p_{1}, p_{2}, ..., p_{k})$.

The probability mass function for a multinomial distribition gives the proability of getting $x_{1}$ occurences of outcome 1, $x_{2}$ occurences of outcome 2 till $x_{k}$ occurences of outcome k, given $\sum_{i=1}^{k} x_{i} = n$

$$ P(X_{1}=x_{1}, X_{2}=x_{2}, ..., X_{k}=x_{k}) = \frac{n!}{x_{1}!x_{2}!...x_{k}!} \cdot p_{1}^{x_{1}}p_{2}^{x_{2}}...p_{k}^{x_{k}}$$

| Mean       | Variance                               |    Covariance                      |
| :--------: | :------------------------------------: | :--------------------------------: |
| $E[X_{i}] = np_{i}$ | $Var[X_{i}] = np_{i}(1-p_{i})$| $Cov(X_{i}, X_{j}) = -np_{i}p_{j}$ |

#### 1.4. Geometric Distribution

<div id='geometric'></div>

#### 1.5. Poisson Distribution

<div id='poisson'></div>

### 2. Continous

#### 2.1. Uniform

<div id='uniform'></div>

#### 2.2. Exponential

<div id='exponential'></div>

#### 2.3. Gamma

<div id='gamma'></div>

#### 2.4. Beta

<div id='beta'></div>

#### 2.5. Normal

<div id='normal'></div>

#### 2.6. t

<div id='t-dist'></div>

