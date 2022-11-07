# EWmF
Salt and Pepper Noise Removal Method

Citation: Enginoğlu, S., Erkan, U., Memiş, S. (2022). Exponentially Weighted Mean Filter for Salt-and-Pepper Noise Removal. In: Dang, N.H.T., Zhang, YD., Tavares, J.M.R.S., Chen, BH. (eds) Artificial Intelligence in Data and Big Data Processing. ICABDE 2021. Lecture Notes on Data Engineering and Communications Technologies, vol 124. Springer, Cham, pp. 435-446.


https://doi.org/10.1007/978-3-030-97610-1_34 

Abstract

This paper defines an exponentially weighted mean using an exponentially decreasing sequence of simple fractions based on distance. It then proposes a cutting-edge salt-and-pepper noise (SPN) removal filter—i.e., Exponentially Weighted Mean Filter (EWmF). The proposed method incorporates a pre-processing step that detects noisy pixels and calculates threshold values based on the possible noise density. Moreover, to denoise the images operationalizing the calculated threshold values, EWmF employs the exponentially weighted mean (ewmean) in 1-approximate Von Neumann neighbourhoods for low noise densities and k-approximate Moore neighbourhoods for middle or high noise densities. Furthermore, it ultimately removes the residual SPN in the processed images by relying on their SPN densities. The numerical and visual results obtained with MATLAB R2021a manifest that EWmF outperforms nine state-of-the-art SPN filters.
