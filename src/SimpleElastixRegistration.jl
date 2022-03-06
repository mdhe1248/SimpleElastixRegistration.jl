module SimpleElastixRegistration

using PyCall, DelimitedFiles
export prepare_elastix_registration, prepare_elastix_transformix, load_points

# Write your package code here.
""" Prepare for elastix registration
`Params` is a tuple of parameters or of files that includes parameters.
"""
function prepare_elastix_registration(outputdir, fixed, moving, params::Tuple)
  elastixImageFilter = sitk.ElastixImageFilter()
  elastixImageFilter.SetFixedImage(fixed)
  elastixImageFilter.SetMovingImage(moving)
  parameterMapVector = sitk.VectorOfParameterMap()
  for param in params
    if isfile(param)
      parameterMapVector.append(sitk.ReadParameterFile(param))
    else
      parameterMapVector.append(sitk.GetDefaultParameterMap(param))
    end
  end
  elastixImageFilter.SetParameterMap(parameterMapVector)
  isdir(outputdir) ? nothing : mkdir(outputdir); elastixImageFilter.SetOutputDirectory(outputdir)
  return(elastixImageFilter)
end
prepare_elastix_registration(outputdir, fixed, moving, param::String) = prepare_elastix_registration(outputdir, fixed, moving, (param,))

""" Add manual points to help registration
'fixedpts_fn' and 'mvpts_fn' follow the point format of Simpleelastix.
"""
function prepare_elastix_registration(outputdir, fixed, moving, params::Tuple, fixedpts_fn::String, mvpts_fn::String)
  elastixImageFilter = sitk.ElastixImageFilter()
  elastixImageFilter.SetFixedImage(fixed)
  elastixImageFilter.SetMovingImage(moving)
  parameterMapVector = sitk.VectorOfParameterMap()
  for param in params
    if isfile(param)
      parameterMapVector.append(sitk.ReadParameterFile(param))
    else
      parameterMapVector.append(sitk.GetDefaultParameterMap(param))
    end
  end
  elastixImageFilter.SetParameterMap(parameterMapVector)
  elastixImageFilter.AddParameter("Metric", ("NormalizedMutualInformation", "CorrespondingPointsEuclideanDistanceMetric" ))
  elastixImageFilter.SetParameter("Metric0Weight", "0.8")
  elastixImageFilter.SetParameter("Metric1Weight", "0.2")
  elastixImageFilter.SetFixedPointSetFileName(fixedpts_fn)
  elastixImageFilter.SetMovingPointSetFileName(mvpts_fn)
  isdir(outputdir) ? nothing : mkdir(outputdir); elastixImageFilter.SetOutputDirectory(outputdir)
  return(elastixImageFilter)
end


""" Prepare for elastix transformix: This is useful when transformation has been acquired by elastix registration.
`tformfns` is a tuple of files that includes parameters.
"""
function prepare_elastix_transformix(outputdir, moving, tformfns::Tuple)
  transformixImageFilter = sitk.TransformixImageFilter()
  for (i, tformfn) in enumerate(tformfns)
    parameterMap = sitk.ReadParameterFile(tformfn)
    if i == 1
      transformixImageFilter.SetTransformParameterMap(parameterMap)
    else
      transformixImageFilter.AddTransformParameterMap(parameterMap)
    end
  end
  transformixImageFilter.SetMovingImage(moving)
  isdir(outputdir) ? nothing : mkdir(outputdir); transformixImageFilter.SetOutputDirectory(outputdir)
  return(transformixImageFilter)
end
prepare_elastix_transformix(outputdir, moving, tformfns::String) = prepare_elastix_transformix(outputdir, moving, (tformfn,))


end
