import Metal

func build_pipeline(device: MTLDevice) -> MTLRenderPipelineState {
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    let library = device.makeDefaultLibrary()

    pipelineDescriptor.vertexFunction = library?.makeFunction(
        name: "vertexMain"
    )
    pipelineDescriptor.fragmentFunction = library?.makeFunction(
        name: "fragmentMain"
    )
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

    let attachment = pipelineDescriptor.colorAttachments[0]
    attachment?.isBlendingEnabled = true
    attachment?.rgbBlendOperation = .add
    attachment?.sourceRGBBlendFactor = .one
    attachment?.destinationRGBBlendFactor = .one
    attachment?.alphaBlendOperation = .add
    attachment?.sourceAlphaBlendFactor = .one
    attachment?.destinationAlphaBlendFactor = .one

    do {
        return try device.makeRenderPipelineState(
            descriptor: pipelineDescriptor
        )
    } catch {
        fatalError("Could not create pipeline: \(error)")
    }
}
