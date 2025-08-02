---
layout: post
title:  "US Population Survival Analysis"
date:   2025-07-23 12:30:48 -0500
categories: [survival]
hidden: true
# published: false
---

The U.S. Department of Health and Human Services publishes yearly survival curves [data]({{ "data/survival/us-population/surival_curve.csv" | relative_url }}) for all causes of mortality by race and sex. Download full R code [here]({{ "data/survival/us-population/us_pop_normal.R" | relative_url }}).

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
<div  align='center'><i> Figure 1: a survival curve with time $t$ by race and gender. </i></div>

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
<div  align='center'><i> Figure 2: pmf with time $t$ by race and gender.</i></div>

pmf is non-zero for each value in it's discrete set of value $\{x_1, x_2, ..., x_n\}$ and 0 otherwise. However, it is not necessary that deaths occur at finite intervals. Therefore, we are looking to find the continuous distribution that represents the pdf of survival. We will do this by fitting a parametric mixture model using bayesian MCMC process. From [fig(2)]({{ "/survival/2025/07/23/us-population#fig2" | relative_url }}) we see that the probability distribution is bath-tub shaped. Bath-tub shaped curves are common when we follow the survival rate from birth. This is also typical in applications such as modeling survival of manufacturing equipments. This shows the higher chance of deaths in population in the early stages due to infant mortality, followed by a constant rate until eventual increase in hazard rate due to natural aging process.

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
<div  align='center'><i> Figure 3: hazard with time $t$ by race and gender. </i></div>

## Data sampling

Using the pmf we can sample data that represents deaths at different ages weighted by their pmf. We sample n data points for each of the categories and join in a dataframe *sample_df*. It's preferable to keep sample size during experimentation. The sample size starts with 500 during modeling and increased to 2000 for final training.

```R
n = 2000
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
```R
> head(sample_df)
  age race_gender category
1  40  White Male        4
2  82  White Male        4
3  72  White Male        4
4  81  White Male        4
5  84  White Male        4
6  58  White Male        4
```

[fig(4)]({{ "/survival/2025/07/23/us-population#fig4" | relative_url }}) shows the density plot of the sampled data.

<div id="fig4" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/pdf_density.svg" width="100%" style="margin:17px;"> </div>
<div  align='center'><i> Figure 4: density plot with time $t$ by race and gender. </i></div>

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
<div  align='center'><i> Figure 5: (a) histogram with time $t$ by race and gender. (b) histogram in log scale with time $t$ by race and gender.</i></div>

## Mixture model

We will now define a mixture model for each category in rjags. We have $N=n*J$ observations, $J=4$ race & gender categories and a mixture of $K=3$ normal distributions. We choose 3 distributions since we have 3 different phases in the survival pdf i.e. infant mortality, mortality during youth, mortality due to aging. This is a hierarchical model defined as

$$
\begin{array}{ll}
  y_i | g_i, \omega_{g_i,k}, \mu_{g_i, k}, \sigma_{g_i, k} \sim \sum_{k} \omega_{g_i,k} \cdot \mathcal{N}(\mu_{g_i, k}, \sigma_{g_i, k}) 
  &  
  i = 1, ..., N \rightarrow \text{ for each obseration}
  \\
  &
  g_i \in \{1, ..., J\} \rightarrow \text{ each observation lies in one race & gender group}
  \\
  &
  k = 1, ..., K \rightarrow \text{ for each mixture component}
  \\
  &
  \sum \omega_k = 1
  \\

  \mu_{g, k}| m_{k}, s_{k} \sim \mathcal{N}(m_{k}, s_{k})
  & g = 1, ..., J \rightarrow \text{ for each race & gender group}\\

  \sigma_{g, k} \sim \text{Inverse-Gamma}(2, 2)
  &\\

  m_{k} \sim \mathcal{N}(45, 200)
  &\\

  s_{k} \sim \text{Inverse-Gamma}(2, 0.5)
  &\\

  \boldsymbol{\omega}_{g,k} \sim \text{Dirichlet}(\alpha_1, \alpha_2, \alpha_3)
  & \rightarrow \text{ dirichlet returns a vector}
  \\

\end{array}
$$

<div id="defn1" align='center'><i> Definition 1: Hierarchical representation of the mixture model. </i></div>

Following is some of the prior beliefs of our model:

* **$\mu$s share priors for an age group**: The survival of an age group share the same priors - $m_k$ & $s_k$ across race and gender categories.
    * The expect normal peak(mean) for 
        * infant $\approx$ 0
        * youth $\approx$ betwen 15 and 85
        * aging $\approx$ 85
    * The peaks for race & gender categories will diverge from these approximate measures but the ordering remains same.
        * $\mu_{k=1}$ < $\mu_{k=2}$ < $\mu_{k=3}$
        * $\mu_{infant}$ < $\mu_{youth}$ < $\mu_{aging}$
    * Additionally, the means do not diverge so far as to mistake survival of age group $k$ to that of $k+1$

* **independent priors for $\sigma$s**: the shape of pdfs are different for each category, hence the volatility spread is given a vague prior
    * The expected volatility spread for 
        * infant is moderate
        * youth is large: normal $\rightarrow$ uniform as $\sigma \rightarrow \infty$
        * aging is lowest: we need a sharp peak corresponding to increasing hazard within aging population.
* **Non-informative prior for mixture weighting $\omega$**: The total survival pdf is then the weighted combination of the infant, youth and aging survival pdfs.
    * Since $\boldsymbol{\omega} \sim Dirichlet(\alpha_1, \alpha_2, \alpha_3)$, the dirichlet prior ensures $\sum \omega_k = 1$
        * Dirichlet distribution is called the distribution over distributions. It used to measure the likelihood of cutting a probability weight (worth 1.0) into K slices.
        * $\alpha$ in a Dirichlet distribution controls the granularity of cuts of a distribution. 
            * If we intialize $\alpha=1.0$ the number of cuts are limited and the slices are going to be "jaggedy".
            * If we intialize $\alpha=10.0$ the number of cuts are increased and the slices are going to be smoother.
        * We set $\alpha_1 = \alpha_2 = \alpha_3 = 1.0 $, thus not giving prior preference to any age group.
        * We further initialize $\omega_1 = \omega_2 = \omega_3 = \frac{1}{K} = \frac{1}{3} $ to signify no prior information.

[fig(6)]({{ "/survival/2025/07/23/us-population#fig6" | relative_url }}) shows how mixture component $k$ of each group $j=1,..,4$  share same priors $m_k$ & $s_k$

<div id="fig6" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/us-survival-hierarchical-model3.svg" width="100%" style="margin:17px;"> </div>
<div  align='center'><i> Figure 6: Graphical representation of the hierarchical model. </i></div>

### RJAGS model definition

```R
library("rjags")

mod_string = "
model {
    for (i in 1:N) {
      y[i] ~ dnorm(mu[category[i], z[i]], prec[category[i], z[i]]) 
      z[i] ~ dcat(omega[category[i], ])
    }

    for (j in 1:J) {
      omega[j, 1:K] ~ ddirich(rep(1.0, K))

      for (k in 1:K){
        raw_mu[j, k] ~ dnorm(mu0[k], prec0[k])
        prec[j, k] ~ dgamma(2.0, 2.0)
        sd[j, k] <- sqrt(1/prec[j, k])
      }

      mu[j, 1] <- raw_mu[j,1]
      
      for (k in 2:K){
        mu[j, k] <- mu[j, k-1] + raw_mu[j, k]
      }
    }

    for (k in 1:K) {
      mu0[k] ~ dnorm(45, 0.01)
      prec0[k] ~ dgamma(2.0, 2.0)
      sd0[k] = sqrt(1.0/prec0[k])
    }
}
"
```

* z[i] is determined with a Categorical distribution that chooses highest probability group among $K$ age groups.
    * for example:
        * $ \boldsymbol{\omega} =  [0.5, 0.25, 0.25] \rightarrow$ 1
        * $ \boldsymbol{\omega} =  [0.25, 0.5, 0.25] \rightarrow$ 2
    * omega through sampling in MCMC process changes the weightage of age groups
* the ordering $\mu_{k=1}$ < $\mu_{k=2}$ < $\mu_{k=3}$ is maintained through *raw_mu* (as long as $\mu_{raw, k>1}$ remain positive - this property is inferred from data)
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
    omega = matrix(1/K, nrow=J, ncol=K),
    raw_mu = matrix(runif(J*K, 1.0, 20.0), ncol=K),
    prec = matrix(runif(J*K, 0.01, 0.5), ncol=K),
    mu0 = runif(K, 1.0, 20.0),
    prec0 = runif(K, 0.01, 0.1)
  )
}

data_jags = list(y=sample_df$age, 
                 category=sample_df$category, 
                 N=N, J=J, K=K)

params = c("mu", 'sd', 'omega')


mod1 = jags.model(textConnection(mod1_string), 
                  data=data_jags, 
                  inits=init_fun,
                  n.chains=3)
update(mod1, 1e3)

mod1_sim = coda.samples(model=mod1,
                        variable.names=params,
                        n.iter=5e3,
                        thin=5)

mod1_csim = as.mcmc(do.call(rbind, mod1_sim))
```
## Results
### Mean - $\mu$

|   category   | $\mu_{infant}$ | $\mu_{youth}$ | $\mu_{aging}$ | 
|:------------:|:--------------:|:-------------:|:-------------:|
| Black Female |   1.082024     |  57.88787     |  77.03880     |
|  Black Male  |  13.459897     |  56.42420     |  75.79710     |
| White Female |  10.605434     |  64.41357     |  79.75966     |
|  White Male  |   1.049828     |  55.88415     |  75.82470     |

<div id="table1" align='center'><i> Table 1: Estimated posterior means of the mixture models.</i></div>

### Standard Deviation - $\sigma$

|   category   | $\sigma_{infant}$ | $\sigma_{youth}$ | $\sigma_{aging}$ | 
|:------------:|:-----------------:|:----------------:|:----------------:|
| Black Female |  0.4418947        | 15.01128         | 5.727624         |
|  Black Male  | 6.3943120         | 13.80961         | 5.908027         |
| White Female |  7.4050833        | 11.64323         | 4.093821         |
|  White Male  | 0.4697202         | 15.45382         | 6.277101         |

<div id="table2" align='center'><i> Table 2: Estimated posterior standard deviations of the mixture models.</i></div>

### Mixture weightage - $\omega$

|   category   | $\omega_{infant}$ | $\omega_{youth}$ | $\omega_{aging}$ | 
|:------------:|:-----------------:|:----------------:|:----------------:|
| Black Female |   0.01923064      |   0.4467875      |   0.5339818      |
|  Black Male  |   0.09759298      |   0.4965808      |   0.4058262      |
| White Female |   0.03284666      |   0.4499149      |   0.5172384      |
|  White Male  |   0.01088987      |   0.3276500      |   0.6614601      |

<div id="table2" align='center'><i> Table 2: Estimated posterior weights of the mixture models.</i></div>

<div id="fig7" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/posterior_pdf.svg" width="100%" style="margin:17px;"> </div>
<div  align='center'><i> Figure 7: Estimated posterior pdf of the mixture model. </i></div>

<div id="fig8" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/posterior_survival.svg" width="100%" style="margin:17px;"> </div>
<div  align='center'><i> Figure 8: Estimated posterior survival of the mixture model. </i></div>

<div id="fig9" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/posterior_hazard.svg" width="100%" style="margin:17px;"> </div>
<div  align='center'><i> Figure 9: Estimated posterior hazard of the mixture model. </i></div>

From [fig(7)]({{ "/survival/2025/07/23/us-population#fig7" | relative_url }}) we can see that estimates are consistent with our original pmfs. [fig(8)]({{ "/survival/2025/07/23/us-population#fig7" | relative_url }}) & [fig(9)]({{ "/survival/2025/07/23/us-population#fig7" | relative_url }}) shows highest hazard associated with black male, comparable hazard for white male and black female and least hazard with white female.

### Performance

1. **Integrated Squared Error (ISE)**
    * Discretize the estimated PDF at the support of the PMF, and compute:
    * Where $p(x)$ is the ground-truth PMF, $\hat{f}(x)$ is the estimated PDF evaluated at $x$, and $\Delta x$ is the bin width.
    * Smaller is better.

    $$ISE = \sum_{x \in support} \left[\hat{f}(x) - p(x)\right]^2 \cdot \Delta x$$

2. **KL Divergence**

    $$KL(p || \hat{f}) = \sum_{x} p(x) \cdot log\left(\frac{p(x)}{\hat{f}(x)}\right)$$

3. **Total Variation Distance**

    $$TVD = \frac{1}{2} \sum_{x} \left|\hat{f}(x) - p(x)\right| \cdot \Delta x$$

|             metric             |    total   | White Male  | White Female | Black Male  | Black Female |
|:------------------------------:|:----------:|-------------|--------------|-------------|--------------|
| Integrated Squared Error (ISE) | 0.01350756 | 0.003014261 | 0.005785105  | 0.001594068 | 0.003114122  |
|          KL Divergence         | -0.4706846 | -0.10930204 | -0.22468737  | 0.01436478  | -0.15105993  |
|    Total Variation Distance    |  0.6290053 | 0.1463835   | 0.1991339    | 0.1291691   | 0.1543188    |

### Visual Diagnostics

* **Bar plot pmf vs Line plot pdf**

<div id="fig10" style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: space-between;">
  <div style="flex: 1 1 calc(50% - 10px); text-align: center;">
    <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/white_male_pmf_vs_pdf.svg" alt="Image 1" style="width: 100%;">
    <p style="margin-top: 5px;">(a)</p>
  </div>
  <div style="flex: 1 1 calc(50% - 10px); text-align: center;">
    <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/white_male_pmf_vs_pdf.svg" alt="Image 2" style="width: 100%;">
    <p style="margin-top: 5px;">(b)</p>
  </div>
  <div style="flex: 1 1 calc(50% - 10px); text-align: center;">
    <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/black_male_pmf_vs_pdf.svg" alt="Image 2" style="width: 100%;">
    <p style="margin-top: 5px;">(c)</p>
  </div>
  <div style="flex: 1 1 calc(50% - 10px); text-align: center;">
    <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/black_female_pmf_vs_pdf.svg" alt="Image 2" style="width: 100%;">
    <p style="margin-top: 5px;">(d)</p>
  </div>
</div>

<div align="center">
  <i>Figure 5: (a) White Male pmf vs pdf
  (b) White Female pmf vs pdf
  (c) Black Male pmf vs pdf
  (d) Black Female pmf vs pdf</i>

</div>