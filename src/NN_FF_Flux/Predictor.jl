module NN_FF_Flux_Predictor
using NNlib
using Flux
using BSON

model = nothing
function initializeModel(modelPath::String)
    global model
    model = BSON.load(modelPath, NN_FF_Flux_Predictor)[:model]
end

function predict(input::Array)
    return model(input)[1]
end

export initializeModel, predict

end  # module NN_FF_Flux_Predictor