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

```R
par(mar = c(5, 4, 4, 10), xpd = TRUE)

# Create the plot
plot(white_male_df$age, white_male_df$survival, type = "s", lty = 1, ylab='survival', xlab='t', col='blue', ylim=c(0,1.0))
points(white_female_df$age, white_female_df$survival, type = "s", lty = 2, col='blue')
points(black_male_df$age, black_male_df$survival, type = "s", lty = 1, col='red')
points(black_female_df$age, black_female_df$survival, type = "s", lty = 2, col='red')

# Add the legend to the right, outside the plot area
legend("topright",
       inset = c(-0.3, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)
```
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

```R
par(mar = c(5, 4, 4, 12), xpd = TRUE)

# Create the plot

plot(white_male_df$age, white_male_df$f2, type = "l", lty = 1, 
     ylab='f', xlab='age', ylim = c(min_y_padded, max_y_padded), col='blue')
# points(white_male_df$age, white_male_df$f2, type = "l", lty = 1)

# points(white_female_df$age, white_female_df$f, type = "l", lty = 2)
points(white_female_df$age, white_female_df$f2, type = "l", lty = 2, col='blue')

# points(black_male_df$age, black_male_df$f, type = "l", lty = 1, col='red')
points(black_male_df$age, black_male_df$f2, type = "l", lty = 1, col='red')

# points(black_female_df$age, black_female_df$f, type = "l", lty = 2, col='red')
points(black_female_df$age, black_female_df$f2, type = "l", lty = 2, col='red')

# Add the legend to the right, outside the plot area
legend("topright",
       inset = c(-0.5, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)
```
<div id="fig1" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/pmf_curve.svg" width="100%" style="margin:17px;"> </div>
*Figure 2: pmf with time $t$ by race and gender.*

It is not necessary that deaths occur at finite intervals. Therefore, we are looking to find the continuous distribution that represents the pdf of survival. We will do this by fitting a parametric mixture model. From [fig(2)]({{ "/survival/2025/07/23/us-population#fig2" | relative_url }}) we see that the probability distribution is bath-rub shaped. Bathtub-shaped curves are common when we follow the survival rate from birth. This is also typical in applications such as modeling survival of manufacturing equipments. This shows the higher chance of deaths in population in the early stages due to infant mortality, followed by a constant rate until eventual increase in hazard rate due to natural aging process.

First we divide the data among different race and gender categories since each group has their own pmfs.

```R
white_male_df = df[df$category == 4,]
white_female_df = df[df$category == 3,]
black_male_df = df[df$category == 2,]
black_female_df = df[df$category == 1,]
```

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

[fig(3)]({{ "/survival/2025/07/23/us-population#fig3" | relative_url }}) shows the density plot of the sampled data.

```R
plot(density(white_female_samples), type='l', lty=2, 
     ylab='density', xlab='age', , col='blue' )
points(density(white_male_samples), type='l', lty=1, col='blue')
points(density(black_male_samples), type='l', lty=1, col='red')
points(density(black_female_samples), type='l', lty=2, col='red')

legend("topright",
       inset = c(-0.5, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)
```

<div id="fig3" style="text-align:center"> <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/pdf_density.svg" width="100%" style="margin:17px;"> </div>
*Figure 3: pdf with time $t$ by race and gender.*

[fig(4)]({{ "/survival/2025/07/23/us-population#fig3" | relative_url }}) shows the historgram plot of the sampled data.

```R
min_age <- floor(min(sample_df$age))
max_age <- ceiling(max(sample_df$age))
x_axis_breaks <- seq(from = min_age, to = max_age + 10, by = 10)

ggplot(sample_df, aes(x = age, fill = race_gender)) +
  geom_histogram(
    binwidth = 5,
    color = "black", # Adds a black border to each bar for visual separation
    position = position_dodge(width = 4) # KEY: Adjust width here.
    # binwidth is 2. Setting width to 1.8 (slightly less than 2)
    # creates a small gap between each set of 4 dodged bars.
    # Experiment with values like 1.5, 1.9, etc.
  ) +
  scale_x_continuous(
    breaks = x_axis_breaks, # Adds space between numbers/labels on the x-axis
    name = "Age"
  ) +
  # scale_y_continuous(
  #   trans = "log10", # Displays the y-axis in a log scale
  #   labels = scales::label_comma(), # Formats y-axis labels nicely
  #   name = "Count (Log Scale)"
  # ) +
  labs(
    title = "Histogram: num deaths per age",
    x = "Age",
    y = "Count"
  ) +
  theme_minimal()
```

<div style="display: flex; gap: 10px; justify-content: space-between;">
  <div style="flex: 1; text-align: center;">
    <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/histogram.svg" alt="Image 1" style="width: 100%;">
    <p style="margin-top: 5px;">(a)</p>
  </div>
  <div style="flex: 1; text-align: center;">
    <img src="https://raw.githubusercontent.com/AshwinDeshpande96/personal_webpage/refs/heads/op_course/data/survival/us-population/log_histogram.svg" alt="Image 2" style="width: 100%;">
    <p style="margin-top: 5px;">(b)</p>
  </div>
</div>
*Figure 4: (a) histogram with time $t$ by race and gender. (b) histogram in log scale with time $t$ by race and gender.*