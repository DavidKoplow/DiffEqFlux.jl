using Interpolations
using Tracker
function destructure(m)
  xs = []
  mapleaves(m) do x
    x isa TrackedArray &&  push!(xs, x)
    push!(xs, x)
    return x
  end
  return vcat(vec.(xs)...)
end

function restructure(m, xs)
  i = 0
  mapleaves(m) do x
    x isa TrackedArray || return x
    x = reshape(xs[i.+(1:length(x))], size(x))
    i += length(x)
    return x
  end
end

function interp(out,in...)
  itp = interpolate(out,BSpline(Cubic(Line(OnGrid()))))
  itp = scale(itp, in...) 
  l = length(in)
  evalSteps =  [collect(in[d]) for d in range(1,stop=l)]
  num_in = size(evalSteps,1)
  dims = Tuple([size(i,1) for i in evalSteps])
  grad = zeros(dims...,num_in)
  for i in CartesianIndices(grad)
    tu=Tuple(i)
    if(tu[end]==1)
      t=tu[1 : end-1]
      cords = [evalSteps[d][t[d]] for d in range(1,stop=num_in)]
      g=Interpolations.gradient(itp, cords...)
      grad[t...,:]=g
    end
  end
  return itp, grad
end