# 5. Smoothing

### 傅立叶变换

在上节课中我们集中讨论了如何提升网格质量。但请注意，提升网格质量并不代表改变曲面或流型，因为网格是曲面/流型的下采样。今天我们会讨论如何如何将曲面变光滑/平滑。表面光滑可以分为两大类：降噪和整流。如今你可以用手机摄像头lidar进行简单的3维采样重建，但这种采样一般质量很低。其中一个原因是在采样过程中会有大量的高频噪音和物体信息混杂在一起。降噪就是去除这些噪音。整流这意味着我们希望生成尽可能光滑的曲面。一些时候这两种的效果都差不多。

如果你对信号有一些基础，那么你应该了解，提取高频信息的方法正是傅立叶变换。傅立叶变换把空域的函数和频域的函数相互转换
$$
\begin{aligned}
F(\omega) & =\int_{-\infty}^{\infty} f(x) \mathrm{e}^{-2 \pi \mathrm{i} \omega x} \mathrm{~d} x \\
f(x) & =\int_{-\infty}^{\infty} F(\omega) \mathrm{e}^{2 \pi \mathrm{i} \omega x} \mathrm{~d} \omega 
\end{aligned}
$$
类似的相关的资源有很多，但我们这里提供一种几何上的解释。$f(x)$可以被看作是一个一个可积的复空间，内积形如：
$$
\langle f, g\rangle=\int_{-\infty}^{\infty} f(x) \overline{g(x)} \mathrm{d} x
$$
$\overline{(a+\mathrm{i} b)}=(a-\mathrm{i} b)$ \bar代表共轭。以e为底的部分可以看作关于x的方程，这个方程把频率为$\omega$的复平面上的波看作正交基。多个正交基张成了整个频域。
$$
e_\omega(x):=\mathrm{e}^{2 \pi \mathrm{i} \omega x}=\cos (2 \pi \omega x)-\mathrm{i} \sin (2 \pi \omega x)
$$
由此离散的来说我们可以把公式重写为
$$
f(x)=\sum_{\omega=-\infty}^{\infty}\left\langle f, e_\omega\right\rangle e_\omega
$$
意为把f这个方程正交投影到以$e_\omega$张成的空间上。$\left\langle f, e_\omega\right\rangle$ 就是上面提到的 $F(x)$, 描述了单个正交基是在f中的权重。我真是一点没看懂反正可以施加一个阈值当作低切。
$$
\tilde{f}(x)=\int_{-\omega_{\max }}^{\omega_{\max }}\left\langle f, e_\omega\right\rangle e_\omega \mathrm{d} \omega
$$

### 流型上的傅立叶变换

刚才的傅立叶变换都是在平面上的，所以我们需要想办法把她们一直到现在2-流型上。让我们对之前定义的 $e_\omega$ 施加拉普拉斯算子。
$$
\Delta\left(e^{2 \pi \mathrm{i} \omega x}\right)=\frac{\mathrm{d}^2}{\mathrm{~d} x^2} e^{2 \pi \mathrm{i} \omega x}=-(2 \pi \omega)^2 e^{2 \pi \mathrm{i} \omega x} 
$$
对于离散三角网格，函数大概可以这样定义
$$
f: \mathcal{S} \rightarrow \mathbb{R} \quad \longrightarrow \quad\left(f\left(v_1\right), \ldots, f\left(v_n\right)\right)^T
$$
离散的拉普拉斯算子可以用矩阵重写
$$
\left(\begin{array}{c}
\Delta f\left(v_1\right) \\
\vdots \\
\Delta f\left(v_n\right)
\end{array}\right)=\mathbf{L}\left(\begin{array}{c}
f\left(v_1\right) \\
\vdots \\
f\left(v_n\right)
\end{array}\right)
$$
这里的L就是拉普拉斯矩阵，我们后面会讨论关于这个矩阵的事情。在连续的时候我们讨论过 $e_\omega$的特征方程，现在离散之后变成了拉普拉斯矩阵的特征值。

### Diffusion Flow

扩散流是一种基于时域的平滑模型。如何刻画f根据时间的推移发生的变化？很自然的你会联想到pde，
$$
\frac{\partial f(\mathbf{x}, t)}{\partial t}=\lambda \Delta f(\mathbf{x}, t)
$$
注意到这里天生的带有拉普拉斯算子，所以我们要讨论离散情况的时候就可以借助之前的讨论。根据(7)我们已经有了离散化了的f，也就是f对每个点的作用。
$$
\frac{\partial}{\partial t} f\left(v_i, t\right)=\lambda \Delta f\left(v_i, t\right), \quad i=1, \ldots, n
$$
