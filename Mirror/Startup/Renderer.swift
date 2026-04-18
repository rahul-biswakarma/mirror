import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipeline: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var time: Float = 0.0

    init(_ parent: StartupView) {
        super.init()
        self.device = MTLCreateSystemDefaultDevice()
        self.commandQueue = device.makeCommandQueue()
        self.pipeline = build_pipeline(device: device)
        self.vertexBuffer = MeshFactory(device: device).make_points()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

    func draw(in view: MTKView) {
        time += 1.0 / 60.0  // Increment time

        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
        else { return }

        descriptor.colorAttachments[0].clearColor = MTLClearColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0
        )
        descriptor.colorAttachments[0].loadAction = .clear

        let encoder = commandQueue.makeCommandBuffer()?
            .makeRenderCommandEncoder(descriptor: descriptor)
        encoder?.setRenderPipelineState(pipeline)

        // Pass Mesh (Index 0) and Time (Index 1)
        encoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder?.setVertexBytes(
            &time,
            length: MemoryLayout<Float>.size,
            index: 1
        )

        encoder?.drawPrimitives(type: .point, vertexStart: 0, vertexCount: 5)

        encoder?.endEncoding()
        commandQueue.makeCommandBuffer()?.present(drawable)
        commandQueue.makeCommandBuffer()?.commit()
    }
}
