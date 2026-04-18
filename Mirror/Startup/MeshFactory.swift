import Metal

class MeshFactory {
    let device: MTLDevice

    init(device: MTLDevice) { self.device = device }

    func make_points() -> MTLBuffer {
        let vertices: [Vertex] = [
            Vertex(position: [0.0, 0.0, 0.0, 1.0], color: [1, 0.2, 0.2]),
            Vertex(position: [-0.4, 0.4, 0.0, 1.0], color: [0.2, 1, 0.2]),
            Vertex(position: [0.4, 0.4, 0.0, 1.0], color: [0.2, 0.2, 1]),
            Vertex(position: [-0.4, -0.4, 0.0, 1.0], color: [1, 1, 0.2]),
            Vertex(position: [0.4, -0.4, 0.0, 1.0], color: [1, 0.2, 1]),
        ]

        return device.makeBuffer(
            bytes: vertices,
            length: vertices.count * MemoryLayout<Vertex>.stride,
            options: []
        )!
    }
}
