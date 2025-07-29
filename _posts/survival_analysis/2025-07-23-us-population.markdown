---
layout: post
title:  "US Population Survival Analysis"
date:   2025-07-23 12:30:48 -0500
categories: [survival]
hidden: true
# published: false
---


The U.S. Department of Health and Human Services publishes yearly survival curves [data]({{ "data/survival/us_population/surival_curve.csv" | relative_url }}) for all causes of mortality by race and sex.

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

The [survival curve]({{ "/survival/2025/07/23/background#survival_function" | relative_url }}) give by the U.S. Department of Health and Human Services is shown in [fig(1)]({{ "/survival/2025/07/23/us_population#fig1" | relative_url }})

<div id="fig1" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us_population/survival_curve.svg" width="100%" style="margin:17px;"> </div>
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

We are interested in modeling the underlying the *pdf* of survival. We are able obtain the discrete *pmf* by simply taking the difference of consecutive survival function values: $S(t-1) - S(t)$. [fig(2)]({{ "/survival/2025/07/23/us_population#fig2" | relative_url }}) represents the underlying discrete pmf of survival.

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

<div id="fig1" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us_population/pmf_curve.svg" width="100%" style="margin:17px;"> </div>
*Figure 2: pmf with time $t$ by race and gender.*

Since it is not necessary that deaths occur at finite intervals, we are looking to find the underlying distribution that represents the pdf of survival. 