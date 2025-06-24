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

If we invest in a 1-year (*m = 1*) bond and expect a single coupon per year *n=1* paying *F = 100* after 12-months from [Eq-1](#eq-fv) the fair value of bond should be PV

We have <a style="text-align:right;" name="eq-df">Equation (2)</a>,

$$ PV = \frac{100}{1 + r} $$

Under deterministic payoff assumptions (we are certain that a product has a known and fixed interest rate *r%*). If we have a product with maturity 2-years with r% interest payment once a year and an initial investment of \\$1 then we can expect a payoff of $(1+r\\%)\cdot(1+r\\%)$ or $(1+r\\%)^2$ compounded twice till maturity.

We define forward rate $f_{i,j}$ as follows:

We have two products a *j*-year bond and a *i*-year bond ($j > i$) with interest rates $r_{j}$, $r_{i}$ compounding $n_{j}$, $n_{i}$ times a year respectively

We have <a style="text-align:right;" name="eq-fr">Equation (3)</a>,

$$ \left( 1+\frac{r_{j}}{n_{j}}\right) ^ {j} = \left( 1+\frac{r_{i}}{n_{i}}\right) ^ {i} \cdot \left( 1+\frac{f_{i,j}}{n}\right) ^ {j-1} $$

For example we have a 2-year & 1-year zero coupon bond, trading at \\$89 and \\$95 respectively, each compounding once a year. From [Eq(2)](#eq-dc)
* $B1 \rightarrow 89 = \frac{100}{(1 + r_{j})^2} \Rightarrow r_{j} = 5.9998\\%$
* $B2 \rightarrow 95 = \frac{100}{1 + r_{i}} \Rightarrow r_{i} = 5.2632\\%$

From [Eq(3)](#eq-fr),

$$ \left( 1+ 0.059998\right) ^ {2} = \left( 1+ 0.052632\right)\cdot \left( 1+f_{i,j}\right) $$

$$ \Rightarrow f_{i,j} = 6.7416\% $$

This implies that the 2-year bond will appreciate by *~5.3%* in the first year(Since $r2 = 5.2632\\%$) and *~6.7%* in the second year.

### How to trade if our estimates show $f_{i,j}$ is high?

Let's design a product with a combination of the above two bonds (assuming we can trade fractional quantities)

$$
B3 =
    \begin{cases}
      B1 \times +\frac{100}{89}\\
      B2 \times -\frac{100}{95}\\
    \end{cases} 
$$

If we are 
* long(Buy) on B3 we buy \\$100 worth 2-year bond B1 and sell \\$100 worth 1-year bond B2
* short(Sell) on B3 we sell \\$100 worth 2-year bond B1 and buy \\$100 worth 1-year bond B2

either way the Total Initial Cost $ = \\pm(100 - 100) = 0$. This position is held for 2-year total because of B1. We are required to pay $\frac{100}{95}\cdot 100 = \\$105.263$ after 1-year as B2 expires with P&L on B2 $ = 100 - 105.263 = -5.263$. Additionally, we receive $\frac{100}{89}\cdot 100 = \\$112.36$ as B1 expires at T=2 with P&L on B2 $ = -100 + 112.36 = 12.36$. Total Closing P&L = $12.36 - 5.263 = 7.097$.

We believe $f_{i,j}$ is high i.e. $PV(B1)$ is low since $yield \propto \frac{1}{price}$. We also believe $PV(B2)$ is at its fair value. According to our belief that B2 is underpriced, this allows us buy B2 at low price before it goes back to it's fair value - at which point we are looking to sell and make profit. We can exploit market conditions with the following trade.

1. We enter a long position on B3.
2. After a year $T=1$, since we still hold the 2-year bond (equivalent to buying a 1-year bond at $\Rightarrow r2 = 6.7416$ or $PV(B2) = $93.68)
3. If the spot rate $ r2 < 6.7\\%$ at $T=1$ i.e. 1-year bond B2 is priced higher than the 1-year position we hold on 2-year bond B1. Then we sell \\$100 worth of 1-year bond B2 $\frac{100}{PV(B2)}$ at $T=1$. Let's assume the spot rate of B2 at $T=1$ is $r2 = 6.0\%$ or $PV(B2) = 94.33$
4. At time $T=2$ we have to pay $\frac{100}{94.33}\cdot 100 = \\$106.01$ with P&L on B2 $ = 100 - 106.01 = -6.01$
5. Due to mispriced products in the bond market we were able to make $ 7.097 - 6.01 = 1.087$ arbitrage profit.
