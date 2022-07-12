module NN_FF_Flux_Trainer
using Flux
using DataFrames
using FluxTraining
using Plots
using Flux.Data: DataLoader

function defaultModels(inputSize, outputSize)
    return [
        Dict(
            "name" => "JL_32_32_Relu",
            "model" => Chain(
                Dense(inputSize, 32, relu),
                Dense(32, 32, relu),
                Dense(32, outputSize))),
        Dict(
            "name" => "JL_32_16_Relu",
            "model" => Chain(
                Dense(inputSize, 32, relu),
                Dense(32, 16, relu),
                Dense(16, outputSize)))
    ]
end

function prepareModels(models, inputSize, outputSize)
    if models === nothing
        return defaultModels(inputSize, outputSize)
    else
        return models
    end
end

function prepareDir(path)
    if !isdir(path)
        mkdir(path)
        return path
    else
        return path
    end
end

function train(
    data,
    x̂,
    ŷ;
    models=nothing,
    outputDir,
    datapoints=9:15,
    batchSize = 16)

    X = Matrix(data[:, x̂])'
    Y = Matrix(data[:, ŷ])'

    xTest = X[:, 2^15:end]
    yTest = Y[:, 2^15:end]

    outputDir = prepareDir(outputDir)

    modelsToTrain = prepareModels(models, size(X)[1], size(Y)[1])

    for modelDict in modelsToTrain
        history = []
        ps = []
        modelOutputDir = prepareDir(joinpath(outputDir, modelDict["name"]))
        for p in datapoints
            dataPoints = 2^p
            xTrain = X[:, 1:dataPoints]
            yTrain = Y[:, 1:dataPoints]

            trainLoader = DataLoader((xTrain, yTrain), batchsize=batchSize, shuffle=false)
            testLoader = DataLoader((xTest, yTest), batchsize=batchSize)
            trainOutputDir = prepareDir(joinpath(modelOutputDir, string(p)))

            opt = RADAM()
            lossfn = Flux.Losses.mse
            checkPointer = Checkpointer(prepareDir(joinpath(trainOutputDir, "trainedModels")))
            learner = Learner(modelDict["model"], lossfn; usedefaultcallbacks=true, callbacks=[checkPointer], optimizer=opt, data=(trainLoader, testLoader))
            fit!(learner, 50)

            trainingLoss = learner.cbstate[:metricsstep][TrainingPhase()][:Loss]
            testLoss = learner.cbstate[:metricsstep][ValidationPhase()][:Loss]
            plot(trainingLoss)
            plot!(testLoss)
            xlabel!("epoches")
            ylabel!("RMSE")
            title!(string("Network: ", modelDict["name"], " p: ", p))
            png(joinpath(trainOutputDir, "rmseHistory_$p.png"))

        end
    end


end

end