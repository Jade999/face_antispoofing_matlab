%%-------------------------------------------------------------
%% Software release accompanying paper submission
%% `Dense Scale-Invariant Descriptors for Images and Surfaces'
%% by Iasonas Kokkinos, Michael Bronstein and Alan Yuille
%% 
%% Copyright (C) 2012 Iasonas Kokkinos 
%% iasonas.kokkinos@ecp.fr
%% The code is distributed under the GNU GPL license.
%% 
%% Part of the code is based on software releases for the following publications:
%%
%% 1) E. Tola, V. Lepetit, and P. Fua. A fast local descriptor for dense matching. In Proc. CVPR, 2008
%% 2) J. M. Geusebroek, A. W. M. Smeulders, and J. van de Weijer.
%% Fast anisotropic gauss filtering. IEEE Trans. Image Processing, vol. 12, no. 8, pp. 938-943, 2003.
%% 
%% The code for 1) is distributed under the BSD license, for 2) under the University of Amsterdam license
%% Both license files are included in this distribution. 
%% 
%% 
%%-------------------------------------------------------------

Description:
Our code is a matlab/c hybrid used to extract scale-invariant descriptors
without relying on scale selection & adaptation. Instead we use a combination
of log-polar sampling with the Fourier Transform Modulus technique. Details
can be found in these publications:

1) `Dense Scale-Invariant Descriptors for Images and Surfaces', Iasonas Kokkinos, Michael Bronstein and Alan Yuille, submitted.
(available upon request)

2) `Scale Invariance without Scale Selection', Iasonas Kokkinos and Alan Yuille, CVPR 2008. (same principle, different implementation)

We request that you cite at least one of those works when using our code in your research.

We provide demo files for sparse and dense descriptor extraction. 
You will need to first run makefile.m to compile the mex files. 



