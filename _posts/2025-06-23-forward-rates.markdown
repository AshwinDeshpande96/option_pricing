---
layout: post
title:  "Forward Rates"
date:   2025-06-23 12:30:48 -0500
categories: [intro]
hidden: true
# published: false
---

### Law of one price

Given a no-arbitrage setting, if we have two cash flows from two products that pay the same final value at time *T* they should be priced equally.
* Product 1: Pays 1 installment of \\$120 every year for 5 years
* Product 2: Pays 12 installments of \\$10 every year for 5 years

$$ \Rightarrow PV(Product 1) = PV(Product 2)$$


### Future Value

If we have interest rate *r%*, *PV* present value of  a financial instrument compounding *n* times per year and holding it for *m* years the future value *F* is given by
<a style="text-align:right;" name="eq-fv">Equation (1)</a>,

$$F = PV \cdot \left(1 + \frac{r\%}{n} \right)^m$$

### Forward rate

If we invest in a 1-year (*m = 1*) bond trading at PV and expect a single coupon per year *n=1* paying *F = 100* after 12-months from [Eq-1](#eq-fv) 

We have <a style="text-align:right;" name="eq-df">Equation (2)</a>,

$$ PV = \frac{100}{1 + r} $$

Under deterministic payoff assumptions (we are certain that a product has a known and fixed interest rate *r%*). If we have a product with maturity 2-years with r% interest payment once a year and an initial investment of \\$1 then we can expect a payoff of $(1+r\\%)\cdot(1+r\\%)$ or $(1+r\\%)^2$ compounded twice till maturity.

We define forward rate $f_{i,j}$ as follows:

We have two products a *j*-year bond and a *i*-year bond ($j > i$) with interest rates $r_{j}$, $r_{i}$ compounding $n_{j}$, $n_{i}$ times a year respectively

We have <a style="text-align:right;" name="eq-fr">Equation (3)</a>,

$$ \left( 1+\frac{r_{j}}{n_{j}}\right) ^ {j} = \left( 1+\frac{r_{i}}{n_{i}}\right) ^ {i} \cdot \left( 1+\frac{f_{i,j}}{n}\right) ^ {j-1} $$

For example we have a 2-year & 1-year bond, trading at \\$89 and \\$95 respectively, each compounding once a year. From [Eq(2)](#eq-dc)
* $89 = \frac{100}{(1 + r_{j})^2} \Rightarrow r_{j} = 5.9998\\%$
* $95 = \frac{100}{1 + r_{i}} \Rightarrow r_{i} = 5.2632\\%$

From [Eq(3)](#eq-fr),

$$ \left( 1+ 0.059998\right) ^ {2} = \left( 1+ 0.052632\right)\cdot \left( 1+f_{i,j}\right) $$
$$ \Rightarrow f_{i,j} = 6.7416\\% $$

This implies that the 2-year bond will appreciate by *5.99%* in the first year and *6.7%* in the second year.