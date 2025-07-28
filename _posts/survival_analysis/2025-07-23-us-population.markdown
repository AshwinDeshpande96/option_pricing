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
| 6 white_female | 1   | 0.99285  | 3        |

## Survival Curve

The [survival curve]({{ "/survival/2025/07/23/background#survival_function" | relative_url }}) give by the U.S. Department of Health and Human Services is shown in fig(1)

<div style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us_population/survival_curve.svg" width="70%" style="margin:17px;"> </div>
*Figure 1: a survival curve with time $t$ by race and gender.*