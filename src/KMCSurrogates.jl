module KMCSurrogates

include("NN_FF_Flux/Trainer.jl")
include("NN_FF_Flux/Predictor.jl")

function train(data, x̂, ŷ; kwargs...)
    NN_FF_Flux_Trainer.train(data, x̂, ŷ; kwargs...)
end

function initializeModel(path)
    NN_FF_Flux_Predictor.initializeModel(path)
end

function predict(input)
    return NN_FF_Flux_Predictor.predict(input)
end

end
