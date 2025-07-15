---
layout: post
title:  "Conjugates"
date:   2025-06-29 12:30:48 -0500
categories: [bayesian]
hidden: true
# published: false
---

### Frequentist Inference



### Normalizing Constants

The bayes expression for posterior given some data $y$ and parameter random variable $\theta$ is: 

$$f(\theta | y) = \frac{f(y | \theta) \cdot f(\theta)}{f(y)}$$

$$f(\theta | y) = \frac{f(y | \theta) \cdot f(\theta)}{\int \theta  f(y | \theta) d\theta}$$

The denominator $f(y) = \int \theta  f(y \| \theta) d\theta$ integrates over all possible values of $\theta$, which means it is a normalizing constant that is used to ensure the posterior integrates to 1. However it does not depend on the $\theta$ in the posterior $f(\theta \| y)$. The parameter estimation (mean, median, mode) remains unchanged whether we include the normalizing constant in the denominator or not i.e. a constant multiplication doesn't change the location of these parameters only the scale of probabilities. Further, a constant multiplication is a monotonically increasing opertion, therefore the relative ordering of $\theta$s remains unchanged:

$$f(\theta_{1} | y) < f(\theta_{2} | y) \Rightarrow C\cdot f(\theta_{1} | y) < C\cdot f(\theta_{2} | y) \text{ where } C > 0$$ 

Hence, computing $f(y)$ is not necessary to estimate the posterior. Estimating $f(y)$ involves comples high-dimensional integrals that are intractable for most models. We will further see how omitting this is useful in concepts such as conjugate priors and MCMC methods. Then, we shall only consider the following proportionality:

$$f(\theta | y) \propto f(y | \theta) \cdot f(\theta)$$
