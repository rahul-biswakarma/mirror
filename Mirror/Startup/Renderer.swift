import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipeline: MTLRenderPipelineState!
    var particleBuffer: MTLBuffer!
    var particleCount: Int = 0
    var time: Float = 0.0
    let trailLength: Int = 50

    init(_ parent: StartupView) {
        super.init()
        self.device = MTLCreateSystemDefaultDevice()
        self.commandQueue = device.makeCommandQueue()
        self.pipeline = build_pipeline(device: device)
        self.particleBuffer = MeshFactory(device: device).make_vortex()
        self.particleCount =
            particleBuffer.length / MemoryLayout<Particle>.stride
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        time += 1.0 / 60.0

        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
        else { return }

        descriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 1
        )
        descriptor.colorAttachments[0].loadAction = .clear

        guard let commandBuffer = commandQueue.makeCommandBuffer(),
            let encoder = commandBuffer.makeRenderCommandEncoder(
                descriptor: descriptor
            )
        else { return }

        encoder.setRenderPipelineState(pipeline)
        encoder.setVertexBuffer(particleBuffer, offset: 0, index: 0)
        encoder.setVertexBytes(
            &time,
            length: MemoryLayout<Float>.size,
            index: 1
        )
        encoder.drawPrimitives(
            type: .point,
            vertexStart: 0,
            vertexCount: 500,
            instanceCount: particleCount
        )
        encoder.endEncoding()

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
