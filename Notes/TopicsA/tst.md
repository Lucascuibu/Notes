### Reading Summary

##### Paper:

Mathematics of the Faraday Cage 

##### Author :

S. Jonathan Chapman†
##### Summary:

Faraday Cage is an enclosure used to block some electromagnetic field.^1^ The conductive material in the specific pattern help create a reverse electromagnetic field against outside thus protect the interior area. Involving lapalace function we are familiar with, the text construct an analysis of mathematical model of Faraday Cage.

##### A concrete algorithmic or mathematical concept:

In the text we have many empricial formula, such as the strength of the screening effect:

$$
|\nabla \phi(0)| \approx \frac{-2 \log r}{n\left|z_s\right|} .
$$

And another bound:

$$
|\nabla \phi(0)| \leq \frac{4|\log r|}{n \log R}
$$

I am trying to understand as much as possible. Thus the content is a liitle bit discountinued from previous. For a cage subject to a point charge  as homogenized model, we have following formula:为什么呢

$$
\begin{aligned}
\nabla^2 \phi & =0 \text { in } \mathbb{R}^2 \backslash\left\{\Gamma \cup z_s\right\} \\
{[\phi] } & =0 \text { on } \Gamma \\
{\left[\frac{\partial \phi}{\partial \mathbf{n}}\right] } & =\alpha\left(\phi-\phi_0\right) \text { on } \Gamma \\
\phi(z) & =\log \left(\left|z-z_s\right|\right)+O(1) \text { as } z \rightarrow z_s \\
\phi(z) & =\log (|z|)+o(1) \text { as } z \rightarrow \infty
\end{aligned}
$$

Line 1 indicates that the in the area plane expcept $\Gamma$ and $z_s$, the field is conservative field, which means charge distributions within the field.

Line 2 simply means the pontenial on $\Gamma$ is continous, thus no jump change exits on $\Gamma$.

In Line 3, we take partial derivative on $\phi$ with respect to its normal and observe the jump. The value indicates that the  partial derivative of $\phi$ can be discontinous and proportional to difference between $\phi$  and boundary $\phi_0$.

The following two lines describe the behaviour of charge source. Where $O(1)$ means the correction is bounded in the limit, and $o(1)$ means the correction converges to 0 in the limit.

##### A well-thought-out discussion question.

1. Why do we consider 2d plane as complex plane ?
2. Which component are we trying to discreteize? the wire?
