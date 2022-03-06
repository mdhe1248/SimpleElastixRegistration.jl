module SimpleElastixRegistration

using PyCall, DelimitedFiles
export prepare_elastix_registration, prepare_elastix_transformix, load_points

# Write your package code here.
function prepare_elastix_registration(outputdir, fixed, moving, param_affine, param_bspline)
  ## Set moving (autofluorescence image) and fixed  
  elastixImageFilter = sitk.ElastixImageFilter()
  elastixImageFilter.SetFixedImage(fixed)
  elastixImageFilter.SetMovingImage(moving)
  
  ## Parameters
  parameterMapVector = sitk.VectorOfParameterMap()
  parameterMapVector.append(sitk.ReadParameterFile(param_affine))
  parameterMapVector.append(sitk.ReadParameterFile(param_bspline))
  elastixImageFilter.SetParameterMap(parameterMapVector)
  isdir(outputdir) ? nothing : mkdir(outputdir); elastixImageFilter.SetOutputDirectory(outputdir)
  return(elastixImageFilter)
  ## Run registration
end

function prepare_elastix_transformix(outputdir, moving, tformfn1, tformfn2)
  transformixImageFilter = sitk.TransformixImageFilter()
  #transformixImageFilter.SetTransformParameterMap(elastixImageFilter.GetTransformParameterMap())
  parameterMap0 = sitk.ReadParameterFile(tformfn1)
  parameterMap1 = sitk.ReadParameterFile(tformfn2)
  transformixImageFilter.SetTransformParameterMap(parameterMap0)
  transformixImageFilter.AddTransformParameterMap(parameterMap1)
  transformixImageFilter.SetMovingImage(moving)
  isdir(outputdir) ? nothing : mkdir(outputdir); transformixImageFilter.SetOutputDirectory(outputdir)
  return(transformixImageFilter)
end

""" load points from elastix outputpoint file"""
function load_points(fn)
  outputpts = readdlm(fn, '\t')
  strs = split.(outputpts[:,5])
  pts  = [(parse(Int, pt[5]), parse(Int, pt[6]), parse(Int, pt[7])) for pt in strs]
  return(pts)
end

end
