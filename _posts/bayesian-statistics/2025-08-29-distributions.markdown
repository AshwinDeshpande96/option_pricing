---
layout: post
title:  "Probability Distributions"
date:   2025-06-29 12:30:48 -0500
categories: [bayesian]
hidden: true
# published: false
---

### 1. Discrete

#### 1.1. Bernoulli Distribution

<div id='bernoulli'></div>

This distribution is used to model a single event that has a binary outcome. The two outcomes can be any binary process (Coin flip: Head/Tail, Win a game: Yes/No, Direction to take: Left/Right) one of which is assigned a value 1 and the other 0 depending on the application. The value 1 occurs with a probability $p$ and value 0 occurs with probability $q=1-p$. If $X$ follows a Bernoulli distribution we write $X \sim \text{Bern}(p)$.

The bernoulli probability mass function is given by:

$$f(x | p) = p^x \cdot (1-p)^{1-x}, \text{where } x \in \{0, 1\}$$

| Mean       | Variance            |    
| :--------: | :-----------------: |
| $E[X] = p$ | $Var[X] = p(1-p)$|

```R
# --- Bernoulli Distribution ---

# Parameters
p_bernoulli <- 0.7 # Probability of success

# 1. Generate Random Samples
n_samples <- 1000
samples_bernoulli <- rbinom(n_samples, size = 1, prob = p_bernoulli)

# 2. Plot PMF
# Bernoulli has only two outcomes: 0 and 1
bernoulli_pmf <- data.frame(
  x = c(0, 1),
  prob = c(dbinom(0, size = 1, prob = p_bernoulli), dbinom(1, size = 1, prob = p_bernoulli))
)

barplot(height = bernoulli_pmf$prob, 
        names.arg = bernoulli_pmf$x,
        main = paste("Bernoulli PMF (p =", p_bernoulli, ")"),
        xlab = "Outcome", ylab = "Probability",
        ylim = c(0, 1), col = c("skyblue", "lightcoral"))
text(x = bernoulli_pmf$x + 0.7, y = bernoulli_pmf$prob,
     labels = round(bernoulli_pmf$prob, 2), pos = 3)


# 3. Plot Histogram of Sampled Data
hist(samples_bernoulli, breaks = c(-0.5, 0.5, 1.5), freq = FALSE,
     main = paste("Histogram of Bernoulli Samples (n=", n_samples, ")"),
     xlab = "Outcome", ylab = "Relative Frequency",
     col = c("skyblue", "lightcoral"), xaxt = 'n') # Turn off x-axis ticks for custom labels
axis(side = 1, at = c(0, 1), labels = c("0", "1"))
```
<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/bernoulli.svg" width="70%" style="margin:17px;"> </div>

#### 1.2. Binomial Distribution

<div id='binomial'></div>

This distribution is used to model multiple events that have a binary outcome. The two outcomes can be any binary process (Multiple coin flips: Head/Tail, Numbers of wins in a tournament: Yes/No). One of the outcomes is assigned a value 1 and the other 0 depending on the application. The value 1 occurs with a probability $p$ and value 0 occurs with probability $q=1-p$. If $X$ follows a binomial distribution we write $X \sim B(n, p)$.

The binomial Probability mass function gives us the probability of $k$ successes in $n$ independent  Bernoulli trials. The independence indicates that the probability of success $p$ remains the same for each trial. The *pmf* is given by:

$$f(x|n,p) = \binom{n}{x} \cdot p^x \cdot (1-p)^{n-x}, \text{for } x \in \{0, 1, 2, ..., n\}$$

| Mean       | Variance            |    
| :--------: | :-----------------: |
| $E[X] = np$ | $Var[X] = np(1-p)$ |

```R
# --- Binomial Distribution ---

# Parameters
n_trials_binom <- 10 # Number of trials
p_binom <- 0.3      # Probability of success on each trial

# 1. Generate Random Samples
n_samples <- 1000
samples_binomial <- rbinom(n_samples, size = n_trials_binom, prob = p_binom)

# 2. Plot PMF
x_binom <- 0:n_trials_binom
pmf_binomial <- dbinom(x_binom, size = n_trials_binom, prob = p_binom)

barplot(height = pmf_binomial, names.arg = x_binom,
        main = paste("Binomial PMF (n=", n_trials_binom, ", p=", p_binom, ")"),
        xlab = "Number of Successes", ylab = "Probability",
        col = "skyblue")

# 3. Plot Histogram of Sampled Data
hist(samples_binomial, breaks = seq(-0.5, n_trials_binom + 0.5, by = 1), freq = FALSE,
     main = paste("Histogram of Binomial Samples (n=", n_samples, ")"),
     xlab = "Number of Successes", ylab = "Relative Frequency",
     col = "lightgreen", border = "white")
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/binom.svg" width="70%" style="margin:17px;"> </div>

#### 1.3. Multinomial Distribution

<div id='multinomial'></div>

The multinomial distribution extends the binomial distribution to $n$ trials of $k$ outcomes. This can modeled as $n$ throws of k sided dice. Each of the k outcomes is assigned a probability $p_{i}$ where $\sum_{i}^{k} p_{i} = 1$. If $X$ follows a multinomial distribution we write $X \sim \text{Multinomial}(n, p_{1}, p_{2}, ..., p_{k})$.

The probability mass function for a multinomial distribition gives the proability of getting $x_{1}$ occurences of outcome 1, $x_{2}$ occurences of outcome 2 till $x_{k}$ occurences of outcome $k$, given $\sum_{i=1}^{k} x_{i} = n$

$$ f(X_{1}=x_{1}, X_{2}=x_{2}, ..., X_{k}=x_{k}|n,p_{1},...,p_{k}) = \frac{n!}{x_{1}!x_{2}!...x_{k}!} \cdot p_{1}^{x_{1}}p_{2}^{x_{2}}...p_{k}^{x_{k}}$$

| Mean       | Variance                               |    Covariance                      |
| :--------: | :------------------------------------: | :--------------------------------: |
| $E[X_{i}] = np_{i}$ | $Var[X_{i}] = np_{i}(1-p_{i})$| $Cov(X_{i}, X_{j}) = -np_{i}p_{j}$ |

Given that $n$ remains fixed, covariance will always be negative or 0 since an increase in share of occurence of outcome i out of $n$ occurences corresponds to decrease in the share of another outcome. This stems from the property: $\sum_{i=1}^{k} x_{i} = n$.

```R
# --- Multinomial Distribution ---

# Parameters
n_trials_multi <- 20 # Number of trials
probs_multi <- c(0.2, 0.3, 0.5) # Probabilities for 3 categories (sum to 1)
names(probs_multi) <- c("Category A", "Category B", "Category C")

# 1. Generate Random Samples (each column is a sample of counts)
n_samples <- 1000
samples_multinomial <- t(rmultinom(n_samples, size = n_trials_multi, prob = probs_multi))

# 2. Plot PMF (Conceptual - hard to plot full PMF for >2 outcomes)
# Instead, we'll plot the distribution of counts for one category or a pairwise scatter.
# Let's visualize the distribution of counts for each category independently
par(mfrow = c(1, length(probs_multi))) # Arrange plots in a row

for (i in 1:length(probs_multi)) {
  hist(samples_multinomial[, i], breaks = seq(-0.5, n_trials_multi + 0.5, by = 1), freq = FALSE,
       main = paste("Counts for", names(probs_multi)[i], "\n(n=", n_trials_multi, ", p=", probs_multi[i], ")"),
       xlab = paste("Count of", names(probs_multi)[i]), ylab = "Relative Frequency",
       col = rainbow(length(probs_multi))[i], border = "white",
       xlim = c(0, n_trials_multi), ylim = c(0, 0.3)) # Consistent y-limit
}
par(mfrow = c(1, 1)) # Reset plot layout

# To show one specific PMF calculation (e.g., probability of getting 4, 6, 10)
specific_counts <- c(4, 6, 10)
if (sum(specific_counts) == n_trials_multi) {
  prob_specific_counts <- dmultinom(specific_counts, size = n_trials_multi, prob = probs_multi)
  cat("\nProbability of getting counts (4, 6, 10) for categories A, B, C:", prob_specific_counts, "\n")
}
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/multinom.svg" width="70%" style="margin:17px;"> </div>

#### 1.4. Geometric Distribution

<div id='geometric'></div>

Geometric distribution is used to model the number of trials until the first success. For example the number of Bernoulli trials with probability $p$ until the first heads is observed. If $X$ follows a geometric distribution we write $X \sim \text{Geo}(p)$.

The probability mass function for a geometric distribition gives the proability it takes $x$ trials to see first success.

$$
f(X=x|p) = p(1-p)^{x-1} \text{ for } x = 1,2,...
$$

| Mean                 | Variance                   |    
| :------------------: | :------------------------: |
| $E[X] = \frac{1}{p}$ | $Var[X] = \frac{1-p}{p^2}$ |

```R
# --- Geometric Distribution ---

# Parameters
p_geom <- 0.2 # Probability of success on each trial

# 1. Generate Random Samples
n_samples <- 1000
samples_geometric <- rgeom(n_samples, prob = p_geom)

# 2. Plot PMF
# Max x value for plotting - 99.9% of probability
x_geom <- 0:qgeom(0.999, prob = p_geom)
pmf_geometric <- dgeom(x_geom, prob = p_geom)

barplot(height = pmf_geometric, names.arg = x_geom,
        main = paste("Geometric PMF (p =", p_geom, ")"),
        xlab = "Number of Failures Before First Success", ylab = "Probability",
        col = "orchid")

# 3. Plot Histogram of Sampled Data
hist(samples_geometric, breaks = seq(-0.5, max(samples_geometric) + 0.5, by = 1), freq = FALSE,
     main = paste("Histogram of Geometric Samples (n=", n_samples, ")"),
     xlab = "Number of Failures Before First Success", ylab = "Relative Frequency",
     col = "lightgray", border = "white")
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/geo.svg" width="70%" style="margin:17px;"> </div>

#### 1.5. Poisson Distribution

<div id='poisson'></div>

The poisson distribution is used to model rates i.e. the count of an event per unit time. The poisson process is applicable when we know the average rate of occurence $\lambda$. For example, we can use poisson to model the rate of production of boxes of cereal per hour in a factory, the count of accidents per week on the roads of L.A.. If $X$ follows a poisson distribution we write $X \sim \text{Pois}(\lambda)$.

The poisson probability mass function defines the probability of seeing $x$ events in the next minute, hour or week. 

$$f(x|\lambda) = \frac{\lambda^{x} e^{-\lambda}}{x!}$$

| Mean             | Variance           |    
| :--------------: | :----------------: |
| $E[X] = \lambda$ | $Var[X] = \lambda$ |

```R
# --- Poisson Distribution ---

# Parameters
lambda_poisson <- 3 # Average rate of events

# 1. Generate Random Samples
n_samples <- 1000
samples_poisson <- rpois(n_samples, lambda = lambda_poisson)

# 2. Plot PMF
# Determine a reasonable upper limit for x based on lambda
x_poisson <- 0:(lambda_poisson + 4 * sqrt(lambda_poisson)) # Up to ~4 std deviations
pmf_poisson <- dpois(x_poisson, lambda = lambda_poisson)

barplot(height = pmf_poisson, names.arg = x_poisson,
        main = paste("Poisson PMF (lambda =", lambda_poisson, ")"),
        xlab = "Number of Events", ylab = "Probability",
        col = "gold")

# 3. Plot Histogram of Sampled Data
hist(samples_poisson, breaks = seq(-0.5, max(samples_poisson) + 0.5, by = 1), freq = FALSE,
     main = paste("Histogram of Poisson Samples (n=", n_samples, ")"),
     xlab = "Number of Events", ylab = "Relative Frequency",
     col = "salmon", border = "white")
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/poisson.svg" width="70%" style="margin:17px;"> </div>

### 2. Continous

#### 2.1. Uniform

<div id='uniform'></div>

A uniform distribution is used for random variable whose outcomes are equally likely. We have an interval with the range of all possible values/outcomes $(a,b)$. This interval has a constant probability and 0 outisde the interval. If $X$ follows a uniform distribution we write $X \sim \text{Uniform}(a, b)$.

A probability density function gives the relative likelihood of the random variable will have a value *near* to $x$. i.e. $P(X=x) \neq f(x)$. For the uniform distribution the pdf is:

$$
f(x | a,b) = \frac{1}{b-a} \cdot I_{\{a \leq x \leq b\}} (x)
$$

| Mean             | Variance                            |    
| :--------------: | :---------------------------------: |
| $E[X] = \frac{a+b}{2}$ | $Var[X] = \frac{(b-a)^2}{12}$ |

```R
# --- Uniform Distribution ---

# Parameters
a_unif <- 0  # Minimum value
b_unif <- 10 # Maximum value

# 1. Generate Random Samples
n_samples <- 10000 # More samples for continuous distributions to see density
samples_uniform <- runif(n_samples, min = a_unif, max = b_unif)

# 2. Plot PDF
x_unif <- seq(a_unif - 1, b_unif + 1, length.out = 500) # Extend a bit for visual clarity
pdf_uniform <- dunif(x_unif, min = a_unif, max = b_unif)

plot(x_unif, pdf_uniform, type = "l", lwd = 2, col = "darkblue",
     main = paste("Uniform PDF (a=", a_unif, ", b=", b_unif, ")"),
     xlab = "x", ylab = "Probability Density",
     ylim = c(0, 1 / (b_unif - a_unif) + 0.05)) # Adjust y-lim for flat top
grid()

# 3. Plot Histogram of Sampled Data
hist(samples_uniform, breaks = 30, freq = FALSE,
     main = paste("Histogram of Uniform Samples (n=", n_samples, ")"),
     xlab = "Value", ylab = "Density",
     col = "lightblue", border = "white", xlim = c(a_unif, b_unif))
lines(density(samples_uniform), col = "red", lwd = 2) # Overlay density estimate
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/uni.svg" width="70%" style="margin:17px;"> </div>

#### 2.2. Exponential

<div id='exponential'></div>

The exponential distribution is used to model time until next event in a poisson process. A poisson process is where events occur continuously and independently at a constant average rate. For example, consider a scenario where you own a coffee shop and customer arrive every 5 minutes. We can use exponential distribution with average rate $\frac{1}{5} = 0.2 $ customers per minute $\Rightarrow X \sim \text{Exp}(0.2)$ and answer questions like what is the probability we would have to wait for another 3 minutes for a customer to arrive. This distribution has a memoryless property, which means if you waited for 2 minutes the probability of waiting another 3 minutes for a customer is the same if you hadn't waited. Instead, if we wanted to answer questions like what is the probability of seeing 30 customers per hour($t=60$), we would define a Poisson distribution with $Y \sim \text{Pois}(t\cdot \lambda) = \text{Pois}(60*0.2) = \text{Pois}(12)$. If $X$ follows a exponential distribution we write $X \sim \text{Exp}(\lambda)$. 

The exponential probability density function can be used to find probability of seeing an event in the next $t$ period.

$$
f(x | \lambda) = \lambda e^{-\lambda x}I_{\{x \geq 0\}}(x)
$$

| Mean                       | Variance                       |    
| :------------------------: | :----------------------------: |
| $E[X] = \frac{1}{\lambda}$ | $Var[X] = \frac{1}{\lambda^2}$ |

```R
# --- Exponential Distribution ---

# Parameters
rate_exp <- 0.5 # Rate parameter (lambda)

# 1. Generate Random Samples
n_samples <- 10000
samples_exponential <- rexp(n_samples, rate = rate_exp)

# 2. Plot PDF
x_exp <- seq(0, qexp(0.999, rate = rate_exp) + 1, length.out = 500) # Up to 99.9th percentile
pdf_exponential <- dexp(x_exp, rate = rate_exp)

plot(x_exp, pdf_exponential, type = "l", lwd = 2, col = "darkgreen",
     main = paste("Exponential PDF (lambda =", rate_exp, ")"),
     xlab = "x", ylab = "Probability Density",
     ylim = c(0, rate_exp + 0.1)) # Ensure starting point is visible
grid()

# 3. Plot Histogram of Sampled Data
hist(samples_exponential, breaks = 50, freq = FALSE,
     main = paste("Histogram of Exponential Samples (n=", n_samples, ")"),
     xlab = "Value", ylab = "Density",
     col = "palegreen", border = "white")
lines(density(samples_exponential), col = "purple", lwd = 2) # Overlay density estimate
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/expo.svg" width="70%" style="margin:17px;"> </div>

#### 2.3. Gamma

<div id='gamma'></div>

Gamma is a generalization of the the exponential distribution for *multiple* events in a poisson process or the sum of independent exponential random variables. For example, gamma can be used to model the amount time before n customers to arrive $Y = \sum_{i=1}^{n} X_{i}$ or the amount of rainfall in a reservoir during a rain-storm, if you think of rainfall as a series of independent events. There are two parameters to a Gamma distribution shape $\alpha = n$ and scale $\beta = \lambda$. A smaller $\alpha$ corresponds to a more right-skewed distribution, this is suitable for an application such as measuring rainfall in a reservoir since small amounts of rainfall are more common and heavy storms rare. As $\alpha$ increases the gamma distribution resembles a normal distribution. If $Y$ follows a gamma distribution we write $Y \sim \text{Gamma}(\alpha, \beta)$. 

The gamma probability density function answers questions such what is the probability of seeing large rare events. Example: the probability of seeing a heavy storm. The pdf for gamma is given by:

$$
f(y | \alpha, \beta) = \frac{\beta^{\alpha}}{\Gamma(\alpha)}y^{\alpha - 1}e^{-\beta y} I_{\{ y \geq 0\}} (x)
$$

The gamma function:$\Gamma(.)$ is a generalization of the factorial function which can accept a non-integer arguments. If $n$ is a positive integer we have $\Gamma(n) = (n-1)!$.

| Mean                          | Variance                       |    
| :---------------------------: | :----------------------------: |
| $E[X] = \frac{\alpha}{\beta}$ | $Var[X] = \frac{\alpha}{\beta^2}$ |

```R
# --- Gamma Distribution ---

# Parameters
shape_gamma <- 2 # Shape parameter (alpha or k)
rate_gamma <- 0.5 # Rate parameter (beta or 1/theta) OR scale = 1/rate = 2

# 1. Generate Random Samples
n_samples <- 10000
samples_gamma <- rgamma(n_samples, shape = shape_gamma, rate = rate_gamma)

# 2. Plot PDF
x_gamma <- seq(0, qgamma(0.999, shape = shape_gamma, rate = rate_gamma) + 1, length.out = 500)
pdf_gamma <- dgamma(x_gamma, shape = shape_gamma, rate = rate_gamma)

plot(x_gamma, pdf_gamma, type = "l", lwd = 2, col = "darkorange",
     main = paste("Gamma PDF (shape=", shape_gamma, ", rate=", rate_gamma, ")"),
     xlab = "x", ylab = "Probability Density")
grid()

# 3. Plot Histogram of Sampled Data
hist(samples_gamma, breaks = 50, freq = FALSE,
     main = paste("Histogram of Gamma Samples (n=", n_samples, ")"),
     xlab = "Value", ylab = "Density",
     col = "peachpuff", border = "white")
lines(density(samples_gamma), col = "darkmagenta", lwd = 2) # Overlay density estimate
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/gamma.svg" width="70%" style="margin:17px;"> </div>

#### 2.4. Beta

<div id='beta'></div>

Beta distributions are used to model probabilities themselves. Beta takes on a value between $[0, 1]$. Due to the flexibility of beta distribution it is used as a prior. A standard uniform distribution is beta with its parameters $\alpha$ and $\beta$ set to 1. If $X$ follows a beta distribution we write $X \sim \text{Beta}(\alpha, \beta)$.

The pdf for beta distribution is as follows:

$$
f(x| \alpha, \beta) = \frac{\Gamma(\alpha + \beta)}{\Gamma(\alpha)\cdot \Gamma(\beta)}x^{\alpha - 1}(1-x)^{\beta - 1} I_{\{0 \leq x \leq 1\}} (x)
$$
```R
# --- Beta Distribution ---

# Parameters
alpha_beta <- 0.5 # Shape parameter 1
beta_beta <- 0.5  # Shape parameter 2 (a Beta(0.5, 0.5) is a Jeffreys prior for Bernoulli p)

# Or, for a more "bell-shaped" beta
# alpha_beta <- 2
# beta_beta <- 5

# 1. Generate Random Samples
n_samples <- 10000
samples_beta <- rbeta(n_samples, shape1 = alpha_beta, shape2 = beta_beta)

# 2. Plot PDF
x_beta <- seq(0, 1, length.out = 500) # Beta is defined on [0, 1]
pdf_beta <- dbeta(x_beta, shape1 = alpha_beta, shape2 = beta_beta)

plot(x_beta, pdf_beta, type = "l", lwd = 2, col = "darkviolet",
     main = paste("Beta PDF (alpha=", alpha_beta, ", beta=", beta_beta, ")"),
     xlab = "x", ylab = "Probability Density")
grid()

# 3. Plot Histogram of Sampled Data
hist(samples_beta, breaks = 40, freq = FALSE,
     main = paste("Histogram of Beta Samples (n=", n_samples, ")"),
     xlab = "Value (Probability)", ylab = "Density",
     col = "plum", border = "white", xlim = c(0,1))
lines(density(samples_beta), col = "brown", lwd = 2) # Overlay density estimate
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/beta.svg" width="70%" style="margin:17px;"> </div>

#### 2.5. Normal

Normal distributions are the widely used as they are most naturally occuring distribition. Over multiple random draws from an underlying distribution, the means of those samples follow a normal distribution around the underlying mean. Normal takes on a value between $[-\infty, \infty]$. A standard normal distribution is beta with its parameters $\sigma = 1$ and $\mu = 0$. If $X$ follows a normal distribution we write $X \sim \text{N}(\mu, \sigma)$.

The pdf for beta distribution is as follows:

<div id='normal'></div>

```R
# --- Normal (Gaussian) Distribution ---

# Parameters
mu_norm <- 0    # Mean
sigma_norm <- 1 # Standard Deviation

# 1. Generate Random Samples
n_samples <- 10000
samples_normal <- rnorm(n_samples, mean = mu_norm, sd = sigma_norm)

# 2. Plot PDF
x_norm <- seq(-4, 4, length.out = 500) # Range covering typical values
pdf_normal <- dnorm(x_norm, mean = mu_norm, sd = sigma_norm)

plot(x_norm, pdf_normal, type = "l", lwd = 2, col = "darkred",
     main = paste("Normal PDF (mu=", mu_norm, ", sigma=", sigma_norm, ")"),
     xlab = "x", ylab = "Probability Density")
grid()

# 3. Plot Histogram of Sampled Data
hist(samples_normal, breaks = 40, freq = FALSE,
     main = paste("Histogram of Normal Samples (n=", n_samples, ")"),
     xlab = "Value", ylab = "Density",
     col = "lightsalmon", border = "white")
lines(density(samples_normal), col = "blue", lwd = 2) # Overlay density estimate
```

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/bayesian/distributions/normal.svg" width="70%" style="margin:17px;"> </div>

#### 2.6. t

<div id='t-dist'></div>

#### 2.7. Dirichlet

#### 2.8. $\chi^2$

#### 2.9. Laplace (Double exponential)

#### 2.10. Inverse Gamma

#### 2.11. Normal Inverse Gamma

#### 2.12 Negative Binomial
