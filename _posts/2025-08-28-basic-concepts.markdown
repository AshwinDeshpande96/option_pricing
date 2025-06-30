---
layout: post
title: "Basic Concepts"
date:   2025-06-25 12:30:48 -0500
categories: [option_pricing]
hidden: true
# published: false
---


### Present Value

<div id="pv"></div>

If we a cash flow $X(0), X(1), ..., X(m)$ and a risk-free interest rate $r$, the present value of that cash flow is given by:

$$PV = X(0) + \frac{X(1)}{(1+\frac{r}{n})} + \frac{X(2)}{(1+\frac{r}{n})^2} + ... +\frac{X(m)}{(1+\frac{r}{n})^m}$$