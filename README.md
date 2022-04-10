# SimpleElastixRegistration

Simpleelastix webpage:

https://simpleelastix.readthedocs.io/index.html

Point-based Simpleelastix registration QnA:

https://github.com/SuperElastix/SimpleElastix/issues/70

https://github.com/SuperElastix/SimpleElastix/issues/176


Well,using Super Elastix seems much simpler in this way:
```
run(`elastix -f $fixed -m $moving -p $param_affine -p $param_bspline -out $outdir`)

# fixed : fixed file name. e.g.) fixed.tif or fixed.nrrd
# moving : moving file name. e.g) moving.tif or moving.nrrd
# param_affine : parameter file name.
# param_bspline : parameter file name.
# outdir : output dir name. This should pre-exist.
```
For more details, please see 
https://elastix.lumc.nl/
https://elastix.lumc.nl/doxygen/commandlinearg.html



