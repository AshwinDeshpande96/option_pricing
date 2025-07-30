---
layout: post
title:  "US Population Survival Analysis"
date:   2025-07-23 12:30:48 -0500
categories: [survival]
hidden: true
# published: false
---


The U.S. Department of Health and Human Services publishes yearly survival curves [data]({{ "data/survival/us-population/surival_curve.csv" | relative_url }}) for all causes of mortality by race and sex.

```R
library(dplyr)
df <- read.csv('surival_curve.csv')
df <- df[,c('race_gender', 'age', 'survival')]
df$category = as.numeric(as.factor(df$race_gender))
head(df)
```

| race_gender    | age | survival | category |
|----------------|-----|----------|----------|
| white_male     | 0   | 1.00000  | 4        |
| white_female   | 0   | 1.00000  | 3        |
| black_male     | 0   | 1.00000  | 2        |
| black_female   | 0   | 1.00000  | 1        |
| white_male     | 1   | 0.99092  | 4        |
| white_female   | 1   | 0.99285  | 3        |

## Survival Curve

The [survival curve]({{ "/survival/2025/07/23/background#survival_function" | relative_url }}) give by the U.S. Department of Health and Human Services is shown in [fig(1)]({{ "/survival/2025/07/23/us-population#fig1" | relative_url }})

<div id="fig1" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/survival_curve.svg" width="100%" style="margin:17px;"> </div>
*Figure 1: a survival curve with time $t$ by race and gender.*

Similar to [example(1)]({{ "/survival/2025/07/23/background#example1" | relative_url }}) the data provided here is discrete. It is defined for finite quantum of time i.e. for each year.

*df\$category* is ordinal conversion of the categorical variable *race_gender*. The mapping is as follows:

| race_gender  | category |
|--------------|----------|
| black_female | 1        |
| black_male   | 2        |
| white_female | 3        |
| white_male   | 4        |

## pdf

We are interested in modeling the underlying the *pdf* of survival. We are able obtain the discrete *pmf* by simply taking the difference of consecutive survival function values: $S(t-1) - S(t)$. [fig(2)]({{ "/survival/2025/07/23/us-population#fig2" | relative_url }}) represents the underlying discrete pmf of survival.

```R
df$f <- NA

df <- df %>%
  arrange(race_gender, age) %>%  # Ensure correct order within each group
  group_by(race_gender) %>%
  mutate(
    f = lag(survival) - survival  # S(t-1) - S(t)
  ) %>%
  ungroup()
```

<div id="fig2" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/pmf_curve.svg" width="100%" style="margin:17px;"> </div>
*Figure 2: pmf with time $t$ by race and gender.*

pmf is non-zero for each value in it's discrete set of value $\{x_1, x_2, ..., x_n\}$ and 0 otherwise. However, it is not necessary that deaths occur at finite intervals. Therefore, we are looking to find the continuous distribution that represents the pdf of survival. We will do this by fitting a parametric mixture model using bayesian MCMC process. From [fig(2)]({{ "/survival/2025/07/23/us-population#fig2" | relative_url }}) we see that the probability distribution is bath-rub shaped. Bathtub-shaped curves are common when we follow the survival rate from birth. This is also typical in applications such as modeling survival of manufacturing equipments. This shows the higher chance of deaths in population in the early stages due to infant mortality, followed by a constant rate until eventual increase in hazard rate due to natural aging process.

Let's divide the data among different race and gender categories since each group has their own pmfs.

```R
white_male_df = df[df$category == 4,]
white_female_df = df[df$category == 3,]
black_male_df = df[df$category == 2,]
black_female_df = df[df$category == 1,]
```

## Hazard

Hazard is defined as ratio between pdf and the surival i.e. $\lambda(x) = \frac{f(x)}{S(x)}$. [fig(3)]({{ "/survival/2025/07/23/us-population#fig3" | relative_url }}) shows that males have higher hazard during infancy, followed by a hazard that constant and similar to all categories until age 15. Thereafter, the hazard diverge with males seeing higher hazard, especially in black males. Black female and white males have comparable hazard rate until age 65. White females have the least hazard throughout their lifetime.

```R
df$lambda = df$f/df$survival
```
<div id="fig3" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/hazard_curve.svg" width="100%" style="margin:17px;"> </div>
*Figure 3: hazard with time $t$ by race and gender.*

## Data sampling

Using the pmf we can sample data that represents deaths at different ages weighted by their pmf. We sample 5000 data points for each of the categories and join in a dataframe *sample_df*.

```R
n = 5000
white_male_samples <- sample(x = white_male_df$age, 
                             size = n, 
                             replace = TRUE, 
                             prob = white_male_df$f)
white_female_samples <- sample(x = white_female_df$age, 
                               size = n, 
                               replace = TRUE, 
                               prob = white_female_df$f)
black_male_samples <- sample(x = black_male_df$age, 
                             size = n, 
                             replace = TRUE, 
                             prob = black_male_df$f)
black_female_samples <- sample(x = black_female_df$age, 
                               size = n, 
                               replace = TRUE, 
                               prob = black_female_df$f)

sample_df  <- data.frame(
  age = c(white_male_samples, white_female_samples,
          black_male_samples, black_female_samples),
  race_gender = factor(rep(c('White Male','White Female',
                             'Black Male','Black Female'), each = n)),
  category = rep(c(4,3,2,1), each = n)
)
```

[fig(4)]({{ "/survival/2025/07/23/us-population#fig4" | relative_url }}) shows the density plot of the sampled data.

<div id="fig4" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/pdf_density.svg" width="100%" style="margin:17px;"> </div>
*Figure 4: density plot with time $t$ by race and gender.*

[fig(5)]({{ "/survival/2025/07/23/us-population#fig5" | relative_url }}) shows the histogram plot of the sampled data.

<div id="fig5" style="display: flex; gap: 10px; justify-content: space-between;">
  <div style="flex: 1; text-align: center;">
    <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/histogram.svg" alt="Image 1" style="width: 100%;">
    <p style="margin-top: 5px;">(a)</p>
  </div>
  <div style="flex: 1; text-align: center;">
    <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/log_histogram.svg" alt="Image 2" style="width: 100%;">
    <p style="margin-top: 5px;">(b)</p>
  </div>
</div>
*Figure 5: (a) histogram with time $t$ by race and gender. (b) histogram in log scale with time $t$ by race and gender.*

## Mixture model

We will now define a mixture model for each category in rjags. We have $N=5000*J$ observations, $J=4$ race & gender categories and a mixture of $K=3$ normal distributions. We choose 3 distributions since we have 3 different phases in the survival pdf i.e. infant mortality, mortality during youth, mortality due to aging. This is a hierarchical model defined as

$$
\begin{array}{ll}
  y_i | g_i, \omega_k, \mu_{g_i, k}, \sigma_{g_i, k} \sim \sum_{k} \omega_k \cdot \mathcal{N}(\mu_{g_i, k}, \sigma_{g_i, k}) 
  &  
  i = 1, ..., N \rightarrow \text{ for each obseration}
  \\
  &
  g_i \in \{1, ..., J\} \rightarrow \text{ for each race & gender group}
  \\
  &
  k = 1, ..., K \rightarrow \text{ for each mixture component}
  \\
  &
  \sum \omega_k = 1
  \\

  \mu_{g, k}| m_{k}, s_{k} \sim \mathcal{N}(m_{k}, s_{k})
  & g = 1, ..., J\\

  \sigma_{g, k} \sim \text{Inverse-Gamma}(2, 10)
  &\\

  m_{k} \sim \mathcal{N}(2, 200)
  &\\

  s_{k} \sim \text{Inverse-Gamma}(2, 10)
  &\\

  \boldsymbol{\omega} \sim \text{Dirichlet}(\alpha_1, \alpha_2, \alpha_3)
  & \rightarrow \text{ dirichlet returns a vector}
  \\

\end{array}
$$

<div align='center'><i> Eq 1: Hierarchical representation of the mixture model. </i></div>

Following is some of the prior beliefs of our model:

* **$\mu$s share priors for an age group**: The survival of an age group share the same prior distribution across race and gender categories.
    * The normal peak(mean) for 
        * infant $\approx$ 0
        * youth $\approx$ betwen 15 and 85
        * aging $\approx$ 85
    * The peaks for race & gender categories will diverge from these approximate measures but the ordering remains same.
        * $f_{k=1}(x)$ < $f_{k=2}(x)$ < $f_{k=3}(x)$
        * $f_{infant}(x)$ < $f_{youth}(x)$ < $f_{aging}(x)$
    * Additionally, the means do not diverge so far as to mistake survival of age group $k$ to that of $k+1$

* **Independent priors for volatility $\sigma$**: the shape of pdfs are different for each category, hence the volatility of $y_i$ is allowed to change independently during the MCMC process.
* The total survival pdf is then the weighted combination of the infant, youth and aging survival pdfs.
    * Since $\boldsymbol{\omega} \sim Dirichlet(\alpha_1, \alpha_2, \alpha_3)$, the dirichlet prior ensures $\sum \omega_k = 1$
        * Dirichlet distribution is called the distribution over distributions. It used to measure the likelihood of cutting a probability weight (worth 1.0) into K slices.
        * $\alpha$ in a Dirichlet distribution controls the granularity of cuts of a distribution. 
            * If we intialize $\alpha=1.0$ the number of cuts are limited and the slices are going to be "jaggedy".
            * If we intialize $\alpha=10.0$ the number of cuts are increased and the slices are going to be smoother.
        * We set $\alpha_1 = \alpha_2 = \alpha_3 = 10.0 $, thus not giving any prior preference to each age group.
        * We further initialize $\omega_1 = \omega_2 = \omega_3 = \frac{1}{K} = \frac{1}{3} $ to signify no prior information.

[fig(6)]({{ "/survival/2025/07/23/us-population#fig6" | relative_url }}) shows how mixture component $k$ of each group $j=1,..,4$  share same priors $m_k$ & $s_k$

<div id="fig6" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/us-survival-hierarchical-model.svg" width="100%" style="margin:17px;"> </div>
*Figure 6: Graphical representation of the hierarchical model in eq(1).*

### RJAGS model definition

```R
library("rjags")

mod_string = "
model {
    for (i in 1:N) {
      y[i] ~ dnorm(mu_param[category[i], z[i]], prec_param[category[i], z[i]])
      z[i] ~ dcat(omega)
    }
    omega ~ ddirich(rep(10.0, K))
    for (j in 1:J) {

      for (k in 1:K){
        raw_mu_param[j, k] ~ dnorm(mu0_param[k], prec0_param[k]) 
        prec_param[j, k] ~ dgamma(2.0, 0.1)
        sd_param[j, k] <- sqrt(1/prec_param[j, k])
      }

      mu_param[j, 1] <- raw_mu_param[j,1]
      
      for (k in 2:K){
        mu_param[j, k] <- mu_param[j, k-1] + raw_mu_param[j, k]
      }
    }

    for (k in 1:K) {
      
      mu0_param[k] ~ dnorm(2.0, 0.01)
      prec0_param[k] ~ dgamma(2.0, 0.1)
      sd0_param[k] = sqrt(1.0/prec0_param[k])
    }
}
"
```

* z[i] through Categorical distribution chooses highest probability group among $K$ age groups.
    * for example:
        * $ \boldsymbol{\omega} =  [0.5, 0.25, 0.25] \rightarrow$ 1
        * $ \boldsymbol{\omega} =  [0.25, 0.5, 0.25] \rightarrow$ 2
    * omega through sampling in MCMC process changes the weightage of age groups
* the ordering $f_{k=1}(x)$ < $f_{k=2}(x)$ < $f_{k=3}(x)$ is maintained through *raw_mu_param* (as long as $\mu_{raw, k>1}$ remain positive)
    * $\mu_1 = \mu_{raw, 1}$
    * $\mu_2 = \mu_1 + \mu_{raw, 2}$
    * $\mu_3 = \mu_2 + \mu_{raw, 3}$
* Normal prior for $\mu$ with large variance ensure no prior beliefs about the means of age groups. We could instead use a Gamma distribution or truncation T(0, ) to ensure $\mu_{raw}$ remain positive.
* Similarly, variances follow inverse gamma, which ensures a non-negative support and a likelihood for moderate variance.

```R
set.seed(11)

N = length(sample_df$age)
J = max(sample_df$category)
K = 3

init_fun <- function() {
  list(
    # Initialize these based on their new dgamma priors
    # omega = matrix(1/M, nrow=J, ncol=M),
    omega = rep(1/K, K),
    raw_mu_param = matrix(runif(J*K, 10.0, 20.0), ncol=M),
    prec_param = matrix(runif(J*K, 0.01, 0.5), ncol=M),
    mu0_param = runif(K, 10.0, 20.0),
    prec0_param = runif(K, 0.01, 0.1)
  )
}

data_jags = list(y=sample_df$age, 
                 category=sample_df$category, 
                 N = N, J = J, K = K)

params = c("mu_param", 'sd_param', 
           'mu0_param', 'sd0_param',
           'omega')


mod = jags.model(textConnection(mod_string), 
                  data=data_jags, 
                  inits=init_fun,
                  n.chains=3)
update(mod, 1e4)

mod_sim = coda.samples(model=mod,
                        variable.names=params,
                        n.iter=5e4,
                        thin=10
                        )
mod_csim = as.mcmc(do.call(rbind, mod_sim))
summary(mod_csim)
head(mod_csim)
plot(mod_csim)

colMeans(mod_csim)
autocorr.diag(mod_sim)
effectiveSize(mod_sim)

dic.samples(mod, n.iter = 5e3)
```