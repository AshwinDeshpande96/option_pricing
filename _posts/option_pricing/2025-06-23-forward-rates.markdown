---
layout: post
title:  "Forward Rates"
date:   2025-06-23 12:30:48 -0500
categories: [option_pricing]
hidden: true
# published: false
---
We look at trading opportunities when we identify mispriced products in the bond market. These are under deterministic payoff conditions (we are certain that a product has a known and fixed interest rate *r%*)

### Arbitrage
<div id='arbitrage'></div>
A trade can be called an arbitrage if it satisfies all 3 following conditions
1. Negative or zero investment: the investment doesn't require initial capital
2. No risk of loss: in all future states of the trade there is no possibility of loss
3. Positive payoff in atleast one future state

These conditions are rare and often short-lived. We shall see an example of what qualifies as an arbitrage using bonds.

### Law of one price

Following no-arbitrage conditions, if we have two cash flows from two products that pay the same amount on the same
schedule, their present value should be the same.

### Future Value

If we have an annual interest rate *r%*, *PV* present value of a financial instrument compounding *n* times per year and holding it for *m* periods the future value *F* is given by
<a style="text-align:right;" name="eq-fv"></a>,

$$
\begin{array}{ll}
    F = PV \cdot \left(1 + \frac{r\%}{n} \right)^m  && \hfill \rightarrow \text{eq(1)}
\end{array}
$$

### Forward rate

If we invest in a 1-year (*m = 1*) bond and expect a single coupon per year *n=1* paying *F = 100* after 12-months from [Eq-1](#eq-fv) the fair value of bond should be PV

We have <a style="text-align:right;" name="eq-df"></a>,

$$
\begin{array}{ll}
     PV = \frac{100}{1 + r}  && \hfill \rightarrow eq(2)
\end{array}
$$

If we have a product with maturity 2-years with r% interest payment once a year and an initial investment of \\$1 then we can expect a payoff of $(1+r\\%)\cdot(1+r\\%)$ or $(1+r\\%)^2$ compounded twice till maturity.

We define forward rate $f_{i,j}$ as follows:

We have two products a *j*-year bond and a *i*-year bond ($j > i$) with interest rates $r_{j}$, $r_{i}$ compounding $n_{j}$, $n_{i}$ times a year respectively

We have<a style="text-align:right;" name="eq-fr"></a>,

$$
\begin{array}{ll}
     \left( 1+\frac{r_{j}}{n_{j}}\right) ^ {j} = \left( 1+\frac{r_{i}}{n_{i}}\right) ^ {i} \cdot \left( 1+\frac{f_{i,j}}{n}\right) ^ {j-1}  && \hfill \rightarrow eq(3)
\end{array}
$$

For example we have a 2-year & 1-year zero coupon bond, trading at \\$89 and \\$95 respectively, each compounding once a year. These are priced such that it equates to 1 quantity resulting in a face value $100 by maturity.  From [Eq(2)](#eq-dc)
* $B1 \rightarrow 89 = \frac{100}{(1 + r_{2})^2} \Rightarrow r_{2} = 5.9998\\%$
* $B2 \rightarrow 95 = \frac{100}{1 + r_{1}} \Rightarrow r_{1} = 5.2632\\%$

From [Eq(3)](#eq-fr),

$$ \left( 1+ 0.059998\right) ^ {2} = \left( 1+ 0.052632\right)\cdot \left( 1+f_{1,2}\right) $$

$$ \Rightarrow f_{1,2} = 6.7416\% $$

This implies that the 2-year bond will change by *5.3%* in the first year and *6.7%* in the second year i.e. a significant change in the 1-year bond rate at $T=1$.

### How to trade if our estimates show $f_{1,2}$ is high?

We know $PV(B1)$ is underpriced $\left(yield \propto \frac{1}{price}\right)$. According to this, B1 is underpriced, this allows us to buy B1 at low price before it goes back to it's fair value - at which point we sell and make profit.
Let's design a product with a combination of the above two bonds (assuming we can trade fractional quantities)

$$
B3 =
    \begin{cases}
      B1 \times +\frac{100}{89} \text{qty} \\
      B2 \times -\frac{100}{95} \text{qty}
    \end{cases} 
$$

B3 also has a maturity of 2-years because of B1. 
At T = 0, if we are 
* long(Buy) on B3 we buy \\$100 worth 2-year bond B1 and sell \\$100 worth 1-year bond B2
* short(Sell) on B3 we sell \\$100 worth 2-year bond B1 and buy \\$50 worth 1-year bond B2

The entry price for the either long/short position is $0$. This is the first condition of our arbitrage profit. Let's list all possible future states after 1-year.
1. $r_{2} \geq 6.7416\%$ at T = 0
2. $r_{2} < 6.7416\%$ at T = 0

#### Future State 1: $r_{2} \geq 6.7416\%$

In this case there is no arbitrage profit, however there is no loss. This requires us to make no additional trade. FV $\rightarrow$ Face Value.

* We would have to pay $Qty_{B1} \cdot FV_{B1} = \frac{100}{95}\cdot 100 = \\$105.2632$ after 1-year. 
* Additionally, receive $Qty_{B2} \cdot FV_{B2} = \frac{100}{89}\cdot 100 = \\$112.3595$ after 2-years. 
* We then make $ 105.2632 - 112.3595 = 7.0964$ profit.

#### Future State 2: $r_{2} < 6.7416\%$

We can exploit market conditions with the following trade.

1. We enter a long position on B3.
2. After a year $T=1$, since we still hold the 2-year bond (equivalent to selling a 1-year bond at $\Rightarrow r_2 = 6.7416\% \text{ or } PV(B2) = \\$93.68$). After 1-year, let's say spot rate of B2 is $r_2 = 4.0\%$ i.e. 1-year bond B2 is priced ($PV(B2) = \\$96.15$) lower than the 1-year position we hold on 2-year bond B1. 
3. We buy another \\$100 worth of 1-year bond B2 at $T=1$. This brings our total cost of investment to -100. This keeps our initial cost at $\leq 0$. 
4. At time $T=2$ we have to pay $\frac{100}{96.15}\cdot 100 = \\$104.004$ with P&L on B2 $ = 100 - 104.004 = -4.004$. Total Profit = $ 7.0964 - 4.004 = 3.0924$. 
5. It would be possible to invest the \\$100 received in the beginning of year-1 on some other product and make $ \geq 4.004$ in profits or choose to not make additional trades to mitigate reduced P&L.

*We can conclude that above opportunity gives us a arbitrage profit since we make $\leq 0$ initial investment, there is no risk of loss in all future states, and there is a positive profit in atleast one future state.*


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