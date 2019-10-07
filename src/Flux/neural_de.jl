function neural_ode(model,x,tspan,
                    args...;kwargs...)
  dudt_(u,p,t) = model(u)
  prob = ODEProblem(dudt_,x,tspan)
  return diffeq_adjoint(prob,args...;u0=x,kwargs...)
end

function neural_ode_rd(model,x,tspan,
                       args...;kwargs...)
  dudt_(u,p,t) = model(u)
  prob = ODEProblem(dudt_,x,tspan)
  # TODO could probably use vcat rather than collect here
  solve(prob, args...; kwargs...)# |> Tracker.collect
end

function neural_dmsde(model,x,mp,tspan,
                      args...;kwargs...)
  dudt_(u,p,t) = model(u)
  g(u,p,t) = mp.*u
  prob = SDEProblem(dudt_,g,param(x),tspan,nothing)
  # TODO could probably use vcat rather than collect here
  solve(prob, args...; kwargs...) 
end
