setwd("~/Documents/Coursera/UCSC-Bayesian-Statistics/Course-2/Code/module_5_project")
library(dplyr)
df <- read.csv('us_survival_long.csv')
df <- df[,c('race_gender', 'age', 'survival')]
df$category = as.numeric(as.factor(df$race_gender))
head(df)

df$pmf <- NA

df <- df %>%
  arrange(race_gender, age) %>%  # Ensure correct order within each group
  group_by(race_gender) %>%
  mutate(
    pmf = lag(survival) - survival  # S(t-1) - S(t)
  ) %>%
  ungroup()

df$lambda = df$pmf/df$survival

df = na.omit(df)

df_grouped_fsum <- df %>%
  group_by(category) %>%
  summarise(total_value = sum(f))

df_grouped_age_max <- df %>%
  group_by(category) %>%
  summarise(max_age = max(age))
df_grouped_age_max

# View a sample
head(df, 10)

unique(df[,c('race_gender','category')])

white_male_df = df[df$category == 4,]
white_female_df = df[df$category == 3,]
black_male_df = df[df$category == 2,]
black_female_df = df[df$category == 1,]

white_male_df$pmf2 = white_male_df$pmf/sum(white_male_df$pmf)
white_female_df$pmf2 = white_female_df$pmf/sum(white_female_df$pmf)
black_male_df$pmf2 = black_male_df$pmf/sum(black_male_df$pmf)
black_female_df$pmf2 = black_female_df$pmf/sum(black_female_df$pmf)
###################### Survival plot
opar <- par(no.readonly = TRUE)

# Adjust margins to create space on the right and allow plotting outside the region
par(mar = c(5, 4, 4, 10), xpd = TRUE)

# Create the plot
plot(white_male_df$age, white_male_df$survival, type = "l", lty = 1, ylab='survival', xlab='age', col='blue', ylim=c(0,1.0))
points(white_female_df$age, white_female_df$survival, type = "l", lty = 2, col='blue')
points(black_male_df$age, black_male_df$survival, type = "l", lty = 1, col='red')
points(black_female_df$age, black_female_df$survival, type = "l", lty = 2, col='red')

# Add the legend to the right, outside the plot area
legend("topright",
       inset = c(-0.4, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)

# Restore original graphical parameters
on.exit(par(opar))

###################### hazard plot

min_y <- min(white_male_df$lambda, white_female_df$lambda, black_male_df$lambda, black_female_df$lambda)
max_y <- max(white_male_df$lambda, white_female_df$lambda, black_male_df$lambda, black_female_df$lambda)
max_y_padded <- max_y * 1.05 # Increase by 5%
min_y_padded <- min_y * 0.95 # Decrease by 5% (be careful if min_y is 0 or negative)
# A safer way to pad:
padding <- (max_y - min_y) * 0.1 # 10% of the range
max_y_padded <- max_y + padding
min_y_padded <- min_y - padding

opar <- par(no.readonly = TRUE)

# Adjust margins to create space on the right and allow plotting outside the region
par(mar = c(5, 4, 4, 10), xpd = TRUE)

# Create the plot
plot(white_male_df$age, white_male_df$lambda, type = "l", lty = 1, ylab='hazard', xlab='t', col='blue', ylim = c(min_y_padded, max_y_padded),)
points(white_female_df$age, white_female_df$lambda, type = "l", lty = 2, col='blue')
points(black_male_df$age, black_male_df$lambda, type = "l", lty = 1, col='red')
points(black_female_df$age, black_female_df$lambda, type = "l", lty = 2, col='red')

# Add the legend to the right, outside the plot area
legend("topright",
       inset = c(-0.4, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)

# Restore original graphical parameters
on.exit(par(opar))

############################### pmf plot

min_y <- min(white_male_df$pmf2, white_female_df$pmf2, black_male_df$pmf2, black_female_df$pmf2)
max_y <- max(white_male_df$pmf2, white_female_df$pmf2, black_male_df$pmf2, black_female_df$pmf2)
max_y_padded <- max_y * 1.05 # Increase by 5%
min_y_padded <- min_y * 0.95 # Decrease by 5% (be careful if min_y is 0 or negative)
# A safer way to pad:
padding <- (max_y - min_y) * 0.1 # 10% of the range
max_y_padded <- max_y + padding
min_y_padded <- min_y - padding

opar <- par(no.readonly = TRUE)

# Adjust margins to create space on the right and allow plotting outside the region
par(mar = c(5, 4, 4, 9), xpd = TRUE)

# Create the plot

plot(white_male_df$age, white_male_df$pmf2, type = "l", lty = 1, 
     ylab='f', xlab='age', ylim = c(min_y_padded, max_y_padded), col='blue')
# points(white_male_df$age, white_male_df$pmf2, type = "l", lty = 1)

# points(white_female_df$age, white_female_df$pmf, type = "l", lty = 2)
points(white_female_df$age, white_female_df$pmf2, type = "l", lty = 2, col='blue')

# points(black_male_df$age, black_male_df$pmf, type = "l", lty = 1, col='red')
points(black_male_df$age, black_male_df$pmf2, type = "l", lty = 1, col='red')

# points(black_female_df$age, black_female_df$pmf, type = "l", lty = 2, col='red')
points(black_female_df$age, black_female_df$pmf2, type = "l", lty = 2, col='red')

# Add the legend to the right, outside the plot area
legend("topright",
       inset = c(-0.4, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)

# Restore original graphical parameters
on.exit(par(opar))


################################# Data sampling

n = 2000
white_male_samples <- sample(x = white_male_df$age, 
                             size = n, 
                             replace = TRUE, 
                             prob = white_male_df$pmf)
white_female_samples <- sample(x = white_female_df$age, 
                               size = n, 
                               replace = TRUE, 
                               prob = white_female_df$pmf)
black_male_samples <- sample(x = black_male_df$age, 
                             size = n, 
                             replace = TRUE, 
                             prob = black_male_df$pmf)
black_female_samples <- sample(x = black_female_df$age, 
                               size = n, 
                               replace = TRUE, 
                               prob = black_female_df$pmf)

sample_df  <- data.frame(
  age = c(white_male_samples, white_female_samples,
          black_male_samples, black_female_samples),
  race_gender = factor(rep(c('White Male','White Female',
                             'Black Male','Black Female'), each = n)),
  category = rep(c(4,3,2,1), each = n)
)

head(sample_df)

################################# Data model

library("rjags")

mod1_string = "
model {
    for (i in 1:N) {
      y[i] ~ dnorm(mu[category[i], z[i]], prec[category[i], z[i]]) 
      z[i] ~ dcat(omega[category[i], ])
    }

    for (j in 1:J) {
      omega[j, 1:K] ~ ddirich(rep(1.0, K))

      for (k in 1:K){
        raw_mu[j, k] ~ dnorm(mu0[k], prec0[k])
        # prec[j, k] ~ dgamma(alpha[k], beta[k])
        prec[j, k] ~ dgamma(2.0, 2.0)
        sd[j, k] <- sqrt(1/prec[j, k])
      }

      mu[j, 1] <- raw_mu[j,1]
      
      for (k in 2:K){
        mu[j, k] <- mu[j, k-1] + raw_mu[j, k]
      }
    }

    for (k in 1:K) {
      # alpha[k] ~ dgamma(2.0, 2.0)
      # beta[k]  ~ dgamma(2.0, 2.0)
      mu0[k] ~ dnorm(45, 0.01)
      prec0[k] ~ dgamma(2.0, 2.0)
      sd0[k] = sqrt(1.0/prec0[k])
    }
}
"

set.seed(11)

N = length(sample_df$age)
J = max(sample_df$category)
K = 3
L = min(sample_df$age)
R = max(sample_df$age)


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
                 N=N, J=J, K=K, L=L, R=R)

params = c("mu", 'sd', 'omega')
# 'alpha', 'beta')

print(min(sample_df$age)) # 1
print(any(sample_df$age <= 0)) # FALSE
print(which(sample_df$age <= 0)) # integer(0)


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

summary(mod1_csim)
head(mod1_csim)
# plot(mod1_csim)

colMeans(mod1_csim)
autocorr.diag(mod1_sim)
effectiveSize(mod1_sim)

sim_df = as.data.frame(mod1_csim)

write.csv(sim_df, "jags_normal_sim.csv", row.names = FALSE)

# dic.samples(mod1, n.iter = 5e3)

################################################################ inferring params
samples_matrix <- as.matrix(mod1_sim)


pos_mu <- colMeans(samples_matrix[, grep("^mu\\[", colnames(samples_matrix))])
pos_mu <- pos_mu[order(names(pos_mu))]

pos_sd <- colMeans(samples_matrix[, grep("^sd\\[", colnames(samples_matrix))])
pos_sd <- pos_sd[order(names(pos_sd))]

pos_omega <- colMeans(samples_matrix[, grep("^omega\\[", colnames(samples_matrix))])
pos_omega <- pos_omega[order(names(pos_omega))]

mu_matrix <- matrix(data = pos_mu, ncol = K, byrow = TRUE)
sd_matrix <- matrix(data = pos_sd, ncol = K, byrow = TRUE)
omega_matrix <- matrix(data = pos_omega, ncol = K, byrow = TRUE)

omega_matrix

################################################################ Plotting pdf

dnorm_mixture <- function(x, mu, sd, w) {
  sum(w * dnorm(x, mean = mu, sd = sd))
}

opar <- par(no.readonly = TRUE)

x_vals <- seq(L, R, length.out = 1000)

par(mar = c(5, 4, 4, 10), xpd = TRUE)

# Set up plot
plot(x_vals, rep(0, length(x_vals)), type = "n",
     ylim = c(0, 0.06), xlab = "x", ylab = "Density",
     main = "Posterior pdf")

# Colors for mixtures
# Colors for mixtures
colors <- c("red", "red", "blue", "blue")
line_types <- c(2, 1, 2, 1)

# Loop over each mixture row
for (i in 1:J) {
  pdf_values <- sapply(x_vals, dnorm_mixture, mu = mu_matrix[i,], sd = sd_matrix[i,], w = omega_matrix[i,])
  lines(x_vals, pdf_values, col = colors[i], lty=line_types[i], lwd = 2)
}

# Add the legend to the right, outside the plot area
legend("topright",
       inset = c(-0.4, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)

# Restore original graphical parameters
on.exit(par(opar))

################################################################ Plotting survival

pnorm_mixture <- function(x, mu, sd, w) {
  sum(w * pnorm(x, mean = mu, sd = sd, lower.tail = FALSE))
}


opar <- par(no.readonly = TRUE)

par(mar = c(5, 4, 4, 10), xpd = TRUE)


# Set up plot
plot(x_vals, rep(0, length(x_vals)), type = "n",
     ylim = c(0, 1), xlab = "x", ylab = "S(x)",
     main = "Posterior Survival")

# Loop over each mixture row
for (i in 1:J) {
  survival_values <- sapply(x_vals, pnorm_mixture, mu = mu_matrix[i,], sd = sd_matrix[i,], w = omega_matrix[i,])
  lines(x_vals, survival_values, col = colors[i], lty=line_types[i], lwd = 2)
}

# Add the legend to the right, outside the plot area
legend("topright",
       inset = c(-0.4, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)

# Restore original graphical parameters
on.exit(par(opar))

################################################################ Plotting hazard

opar <- par(no.readonly = TRUE)

par(mar = c(5, 4, 4, 10), xpd = TRUE)

# Set up plot
plot(x_vals, rep(0, length(x_vals)), type = "n",
     ylim = c(0, 0.2),
     xlim = c(L, R),
     xlab = "x", ylab = "Density",
     main = "Posterior hazard")

# Loop over each mixture row
for (i in 1:J) {
  survival_values <- sapply(x_vals, pnorm_mixture, mu = mu_matrix[i,], sd = sd_matrix[i,], w = omega_matrix[i,])
  pdf_values <- sapply(x_vals, dnorm_mixture, mu = mu_matrix[i,], sd = sd_matrix[i,], w = omega_matrix[i,])
  hazard = pdf_values/survival_values
  lines(x_vals, hazard, col = colors[i], lty=line_types[i], lwd = 2)
}

# Add the legend to the right, outside the plot area
legend("topright",
       inset = c(-0.4, 0), # Adjust horizontal inset as needed
       legend = c("white male", "black male", "white female", "black female"),
       col = c("blue", "red", "blue", "red"),
       lty = c(1,1,2,2),
       lwd = 2)

# Restore original graphical parameters
on.exit(par(opar))

################################################################ Integrated square error

row_wise_pdf <- function(x, mu, sd, w) {
  rowSums(w * dnorm(x, mean = mu, sd = sd))
}

df$pdf <- row_wise_pdf(x=df$age, 
                 mu = mu_matrix[df$category,], 
                 sd = sd_matrix[df$category,], 
                 w = omega_matrix[df$category,])

dx= 1 # bin_width

ise = sum(((df$pdf - df$pmf)^2)*dx)
ise

################################################################ kl divergence

kld = sum(df$pmf*log(df$pmf/df$pdf))
kld


################################################################ total variation distance

tvd = sum(abs(df$pdf - df$pmf)*dx)/2
tvd


################################################################  visual diagnostics

################################################################  bar pmf vs line pdf

wm_df = df[df$category == 4,]
wf_df = df[df$category == 3,]
bm_df = df[df$category == 2,]
bf_df = df[df$category == 1,]

par(mar = c(5, 4, 4, 10), xpd = TRUE)
######## white male
plot(wm_df$age, wm_df$pmf, type="h", col="blue", lwd=2, ylim=c(0,0.06), lty=1,
     ylab='pmf vs pdf', xlab='age', main = "White Male")
lines(wm_df$age, wm_df$pdf, type='l', col="blue", lwd=2, lty=1)
legend("topright", 
       inset = c(-0.4, 0),
       legend=c("True PMF", "Estimated PDF"), 
       col=c("blue", "blue"), 
       lty=c(1,1))

######## white female
plot(wf_df$age, wf_df$pmf, type="h", col="blue", lwd=2, ylim=c(0,0.06), lty=1,
     ylab='pmf vs pdf', xlab='age', main = "White Female")
lines(wf_df$age, wf_df$pdf, type='l', col="blue", lwd=2, lty=2)
legend("topright", 
       inset = c(-0.4, 0),
       legend=c("True PMF", "Estimated PDF"), 
       col=c("blue", "blue"), 
       lty=c(1,2))

######## black male
plot(bm_df$age, bm_df$pmf, type="h", col="red", lwd=2, ylim=c(0,0.06), lty=1,
     ylab='pmf vs pdf', xlab='age', main = "Black Male")
lines(bm_df$age, bm_df$pdf, type='l', col="red", lwd=2, lty=1)
legend("topright", 
       inset = c(-0.4, 0),
       legend=c("True PMF", "Estimated PDF"), 
       col=c("red", "red"), 
       lty=c(1,1))

######## black female
plot(bf_df$age, bf_df$pmf, type="h", col="red", lwd=2, ylim=c(0,0.06), lty=1,
     ylab='pmf vs pdf', xlab='age', main = "Black Female")
lines(bf_df$age, bf_df$pdf, type='l', col="red", lwd=2, lty=2)
legend("topright", 
       inset = c(-0.4, 0),
       legend=c("True PMF", "Estimated PDF"), 
       col=c("red", "red"), 
       lty=c(1,2))

################################################################  
plot(df$age, df$pmf, type="h", col="blue", lwd=2)
lines(df$age, df$pdf, col="red", lwd=2)



legend("topright", legend=c("True PMF", "Estimated PDF"), col=c("blue", "red"), lty=1)
