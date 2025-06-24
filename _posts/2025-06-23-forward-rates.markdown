---
layout: post
title:  "Forward Rates"
date:   2025-06-23 12:30:48 -0500
categories: [option_pricing]
hidden: true
# published: false
---
We look at trading opportunities when we identify mispriced products in the bond market. These are under deterministic payoff conditions (we are certain that a product has a known and fixed interest rate *r%*)

### Law of one price

Following no-arbitrage conditions, if we have two cash flows from two products that pay the same final value at time *T* they should be priced equally.
* Product 1: Pays 1 installment of \\$120 every year for 5 years
* Product 2: Pays 12 installments of \\$10 every year for 5 years

$$ \Rightarrow PV(Product\ 1) = PV(Product\ 2)$$


### Future Value

If we have an interest rate *r%*, *PV* present value of  a financial instrument compounding *n* times per year and holding it for *m* years the future value *F* is given by
<a style="text-align:right;" name="eq-fv">Equation (1)</a>,

$$F = PV \cdot \left(1 + \frac{r\%}{n} \right)^m$$

### Forward rate

If we invest in a 1-year (*m = 1*) bond and expect a single coupon per year *n=1* paying *F = 100* after 12-months from [Eq-1](#eq-fv) the fair value of bond should be PV

We have <a style="text-align:right;" name="eq-df">Equation (2)</a>,

$$ PV = \frac{100}{1 + r} $$

If we have a product with maturity 2-years with r% interest payment once a year and an initial investment of \\$1 then we can expect a payoff of $(1+r\\%)\cdot(1+r\\%)$ or $(1+r\\%)^2$ compounded twice till maturity.

We define forward rate $f_{i,j}$ as follows:

We have two products a *j*-year bond and a *i*-year bond ($j > i$) with interest rates $r_{j}$, $r_{i}$ compounding $n_{j}$, $n_{i}$ times a year respectively

We have <a style="text-align:right;" name="eq-fr">Equation (3)</a>,

$$ \left( 1+\frac{r_{j}}{n_{j}}\right) ^ {j} = \left( 1+\frac{r_{i}}{n_{i}}\right) ^ {i} \cdot \left( 1+\frac{f_{i,j}}{n}\right) ^ {j-1} $$

For example we have a 2-year & 1-year zero coupon bond, trading at \\$96 and \\$95 respectively, each compounding once a year. From [Eq(2)](#eq-dc)
* $B1 \rightarrow 96 = \frac{100}{(1 + r_{2})^2} \Rightarrow r_{j} = 2.0621\\%$
* $B2 \rightarrow 95 = \frac{100}{1 + r_{1}} \Rightarrow r_{i} = 5.2632\\%$

From [Eq(3)](#eq-fr),

$$ \left( 1+ 0.020621\right) ^ {2} = \left( 1+ 0.052632\right)\cdot \left( 1+f_{1,2}\right) $$

$$ \Rightarrow f_{1,2} = -1.04\% $$

This implies that the 2-year bond will change by *5.3%* in the first year and *-1.0%* in the second year i.e. a significant change in the 1-year bond rate at $T=1$.

### How to trade if our estimates show $f_{1,2}$ is low?

Let's design a product with a combination of the above two bonds (assuming we can trade fractional quantities)

$$
B3 =
    \begin{cases}
      B1 \times -\frac{100}{96} \text{at T = 0}\\
      B2 \times +\frac{50}{95} \text{at T = 0}\\
      B2 \times +\frac{50}{95} \text{at T = 1 if r2 > $f_{1,2}$}
    \end{cases} 
$$

B3 also has a maturity of 2-years because of B1. 
At T =0, if we are 
* long(Buy) on B3 we sell \\$100 worth 2-year bond B1 and buy \\$50 worth 1-year bond B2
* short(Sell) on B3 we buy \\$100 worth 2-year bond B1 and sell \\$50 worth 1-year bond B2

the entry price for the long position is $< 0$. 

We believe $f_{1,2}$ is low i.e. $PV(B1)$ is high since $yield \propto \frac{1}{price}$. We also believe $PV(B2)$ is at its fair value. According to this, B1 is overpriced, this allows us sell B1 at high price before it goes back to it's fair value - at which point we are looking to buy back and make profit. We can exploit market conditions with the following trade.

1. We enter a long position on B3.
2. After 1-year T = 1, we will receieve $\frac{50}{95}\cdot 100 = \\$52.631$  as B2 expires with P&L $ = -50 + 52.631 = 2.631$. 
2. After a year $T=1$, since we still hold the 2-year bond (equivalent to selling a 1-year bond at $\Rightarrow r2 = -1.04\%$ or $PV(B2) = $101.05 ). After 1-year, let's say spot rate of B2 is $r2 = 4.0\%$ which $ > -1.04\\%$ i.e. 1-year bond B2 is priced ($PV(B2) = \\$96.1538$) low than the 1-year position we hold on 2-year bond B1. Then we can buy another \\$50 worth of 1-year bond B2 $\frac{50}{96.15}$ at $T=1$. This brings our total cost of investment to 0. This would require a margin account but we can see that it is possible to make profits using 0 initial cost. 
4. At time $T=2$ we receive $\frac{50}{96.15}\cdot 100 = \\$52.00$ with P&L on B2 $ = -50 + 52.00 = 2.00$. We have to pay $\frac{100}{96}\cdot 100 = \\$104.166$ with P&L on B1 $ = 100 - 104.166 = -4.166$
5. Due to mispriced products in the bond market we were able to make $ 2.631 + 2.00 - 4.166 = 0.465$ arbitrage profit with \$0 initial cost.


Here is some basic python code to find forward rate.

```python 
def forward_rate(pv1, pv2, m1, m2, n1=1, n2=1, n3=1):
    assert m2 > m1
    # spot rate of the shorter bond
    r1 = math.pow((100/pv1), 1/m1) - 1
    r1 *= n1
    # spot rate of the longer bond
    r2 = math.pow((100/pv2), 1/m2) - 1
    r2 *= n2
    
    # forward rate
    m12 = m2-m1
    f12 = math.pow(1+r2/n2, m2)/math.pow(1+r1/n1, m1)
    f12 = math.pow(f12, (1/m12)) - 1
    f12 *= n3
    
    return r1, r2, f12

r1, r2, f12 = forward_rate(pv1, pv2, m1, m2, n1, n2)

print(f"r1: {r1*100:.4f}%\nr2: {r2*100:.4f}%\nf12: {f12*100:.4f}%")
```

Output:
```
r1: 5.2632%
r2: 5.9998%
f12: 6.7416%
```