---
layout: post
title: "Arbitrage Using Forward Contracts"
date:   2025-06-25 12:30:48 -0500
categories: [option_pricing]
hidden: true
# published: false
---

See definition of [arbitrage]({{ "/option_pricing/2025/06/23/forward-rates#arbitrage" | relative_url }}).

### Forward contracts
<div id='forward_contracts'></div>

A forward contract is an agreement you enter today $t_{0}$ to buy(long) or sell(short) an underlying asset at future 
maturity date $T$ at a predetermined price $F(t_{0})$. The delivery of the asset takes place at time $T$ 
and consequently are required to buy/sell at the predetermined price $F(t_{0})$.

### Synthetic Forward Price

Synthetic forward price is the theoretical price of the forward contract that can be derived 
using the spot price of the **underlying asset** $S(t_{0})$ and **risk-free interest rate** $r$.

$$ F_{theoretical}(t_{0}) = B(t_{0}, T).S(t_{0}) $$

If we consider continuously compounded interest rate the interest applied between $t_{0}$ and $T$ is given by
$B(t_{0}, T) = e^{r \cdot (T - t_0)}$ and $B(t_{0}, T) = (1+\frac{r}{m})^{T}$ in 
the discrete case, where m is the number of payments per year. 

If the spot price of the forward contract is the same as the synthetic forward price there is 
no arbitrage.
<div id="fc_arbitrage">Equation 1</div>

$$ F(t_{0}) = F_{theoretical}(t_{0}) $$

Let's consider the following two cases, when [Eq-1](#fc_arbitrage) doesn't hold true
<div id='arbitrage-forward-contract'></div>
#### Case 1: $ F(t_{0}) < F_{theoretical}(t_{0}) $

This implies the current spot price of the forward contract is underpriced than the theoretical fair price. 
We assume we can borrow underlying asset at zero-interest for simplicity. We can make arbitrage profit by the 
following steps

* At $t_{0}$
    * buy(long) the underpriced forward contract
        * Current Account = 0
        * Liability = 0, since no money is exchanged when entering forward contract
    * sell(short) 1 share of underlying asset by borrowing from market (at zero-interest)
        * Current Account = $+S(t_{0})$
        * Liability = 1 share of underlying asset
    * invest $S(t_{0})$ in risk free asset till $T$
        * Current Account = 1 risk-free asset of price $S(t_{0})$
        * Liability = 1 share of underlying asset
* At maturity $T$
    * Liquidate position from risk-free asset (risk-free asset more or less guarantees appreciation in asset)
        * Current Account = $+F_{theoretical}(t_{0}) = +B(t_{0}, T) \cdot S(t_{0})$
        * Liability = 1 share of underlying asset
    * Make whole the forward contract by paying $F(t_{0})$ from appreciated asset $F_{theoretical}(t_{0})$
        * Current Account = $F_{theoretical}(t_{0})-F(t_{0})$ + 1 share underlying asset
        * Liability = 1 share of underlying asset
    * Close short position by returning 1 share of underlying asset received from forward contract to market
        * Current Account = $\left[F_{theoretical}(t_{0})-F(t_{0})\right] \rightarrow$ profit
        * Liability = 0

#### Case 2: $ F(t_{0}) > F_{theoretical}(t_{0}) $

This implies that the current spot price of the forward contract is overpriced than the theoretical fair price. Arbitrage is achieved through following steps:

* At $t_{0}$
    * short(sell) the overpriced forward contract
        * Current Account = 0
        * Liability = 0, again no money is exchanged when entering forward contract 
    * buy(long) one share of the underlying price by borrowing cash $S(t_{0})$ from bank at risk-free interest rate
        * Current Account = 1 share of underlying asset
        * Liability = $-S(t_{0})$
* At maturity $T$
    * Fulfill obligation to deliver 1 share of underlying asset and receive agreed forward price $F(t_{0})$
        * Current Account = $F(t_{0})$
        * Liability = $-S(t_{0})$
    * Borrowed $S(t_{0})$ has incurred interest r
        * Current Account = $F(t_{0})$
        * Liability = $-F_{theoretical}(t_{0}) = -B(t_{0}, T) \cdot S(t_{0})$
    * Pay back the cash received from bank with interest
        * Current Account = $\left[F(t_{0}) - F_{theoretical}(t_{0})\right] \rightarrow$ profit
        * Liability = 0

*In both cases since we required $\leq 0$ initial investment to trade, there is no future state with a possible loss and there is atleast one state where 
we make a profit - this is an arbitrage profit.*

### Dividends
<div id='dividends'></div>
Dividend is a sum of money that is paid by the company to a shareholder out of it's profits. These dividends commonly are paid as cash, additional shares or any other special arrangement if agreed upon. Not all stocks pay dividends.

### Forward contracts and dividends

Buying a stock outright at time $t_{0}$ optionally come with dividends. Buying a forward contract at $t_{0}$ with maturity $T$ on the same 
stock doesn't come with any such obligation i.e. you miss out on the dividends between $t_{0}$ and $T$. Since you miss out on the dividends, 
the present value $D(t_{0})$ at $t_{0}$ of those dividends paid between $t_{0}$ and $T$ is discounted from the forward price. Dividends are usually not 
deterministic since it depends on company's future profits. However, if we assume we know either $D(t_{0})$ or a continuous rate $q$ at which dividends will
be paid, the forward contract estimation is adjusted as follows

* Discrete payments: $F(t_{0}) = B(t_{0}, T) \cdot (S(t_{0}) - D(t_{0}))$
* Continuous payments: $F(t_{0}) = B(t_{0}, T) \cdot e^{-q \cdot (T - t_{0})} \cdot S(t_{0})$


### Forward contracts on foreign currency

Let underlying asset be the foreign currency. If we were to buy a foreign currency it would be 
equivalent to buying a stock that is worth $S(t_{0})$ amount in local currency at the spot 
exchange rate. Additionally, the synthetic forward price of the forward contract on a foreign currency is equal to 
taking the foreign currency (or its local currency equivalent $S(t_{0})$) and investing the amount 
in a local risk-free $r$ rate asset:

$$ F_{theoretical}(t_{0}) = B(t_{0}, T).S(t_{0}) $$

$$ F_{theoretical}(t_{0}) = e^{r \cdot (T - t_{0})} \cdot S(t_{0}) $$

If we were to hold the foreign currency we would get the benefits of the foreign risk-free 
interest rate $r_{f}$ (if we buy foreign risk-free asset). This foreign risk-free interest rate 
$r_{f}$ can be compared to the aforementioned continuously paid dividend rate $q$. That is, when 
we buy a forward contract to acquire a foreign currency at a later maturity we forego the 
risk-free interest rate $r_{f}$ between the period $t_{0}$ and $T$. This is discounted into 
the formula for the value for the forward contract as follows:

$$ F_{theoretical}(t_{0}) = e^{r \cdot (T - t_{0})} \cdot S(t_{0}) \cdot e^{-r_{f} \cdot (T - t_{0})}$$

$$ F_{theoretical}(t_{0}) = e^{(r - r_{f}) \cdot (T - t_{0})} \cdot S(t_{0}) $$

Similar to examples in [previous section](#arbitrage-forward-contract) there would be arbitrage if the current spot 
price of the forward contract $ F(t_{0}) \neq F_{theoretical}(t_{0}) $. Let's see an example

Let's say the spot price of the forward contract of one foreign currency (Euro) $F(t_{0})$ is less than the 
theoretical price $F_{theoretical}(t_{0})$ of that foreign currency. We consider the risk-free rate in local currency (U.S. Dollar) $r$

#### $$ F(t_{0}) < F_{theoretical}(t_{0}) $$

This implies that the spot price of forward contract is underpriced. This is an opportunity to buy cheap 
and sell expensive. This means we buy(long) the forward contract and sell(short) the underlying Euro. If we 
borrow 1 Euro at $t_{0}$ from the market we would owe $e^{r_{f} \cdot (T - t_{0})}$ Euro at $T$
but we would only receive 1 Euro from the forward contract. That is, we wouldn't be able to close the short position. 
To equate this we would only borrow $e^{-r_{f} \cdot (T - t_{0})}$ at $t_{0}$ and invest into the local risk-free
asset. At maturity we would now owe 1 Euro $\rightarrow$

$$e^{-r_{f} \cdot (T - t_{0})} \cdot e^{r_{f} \cdot (T - t_{0})}$$

$$ e^{(r_{f}-r_{f}) \cdot (T - t_{0})}  = e^{0} = 1 \text{ Euro}$$

Here are the steps to make arbitrage profit from mispriced forward contract:

* At $t_{0}$
    * Buy forward contract on 1 Euro
        * Current Account = 0
        * Liability = 0
    * Borrow $e^{-r_{f} \cdot (T - t_{0})}$ Euro (or it's dollar equivalent $S(t_{0})$)
        * Current Account = $e^{-r_{f} \cdot (T - t_{0})} \cdot S(t_{0})$
        * Liability = -$e^{-r_{f} \cdot (T - t_{0})} \cdot S(t_{0})$
    * Invest the borrowed amount in local risk-free asset
        * Current Account = $e^{-r_{f} \cdot (T - t_{0})} \cdot S(t_{0})$ worth of U.S. treasury bond 
        * Liability = -$e^{-r_{f} \cdot (T - t_{0})} \cdot S(t_{0})$
* At maturity $T$
    * Liquidate U.S. treasury bond
        * Current Account = $F_{theoretical}(t_{0}) = e^{(r-r_{f}) \cdot (T - t_{0})} \cdot S(t_{0})$
        * Liability = -$S(t_{0})$
    * Receive the 1 Euro (equivalent dollar amount $S(t_{0})$) from forward contract and pay the agreed upon forward price $F(t_{0})$
        * Current Account = $F_{theoretical}(t_{0}) - F(t_{0}) + S(t_{0})$
        * Liability = -$S(t_{0})$
    * Close the short position and pay back $S(t_{0})$ amount to market
        * Current Account = $F_{theoretical}(t_{0}) - F(t_{0}) \rightarrow$ profit
        * Liability = 0

*This is again an arbitrage profit according to the 3 conditions of arbitrage.*