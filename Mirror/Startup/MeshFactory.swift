import Metal

class MeshFactory {
    let device: MTLDevice

    init(device: MTLDevice) { self.device = device }

    func make_vortex() -> MTLBuffer {

        var particles: [Particle] = []

        while particles.count < 500 {

            let randomX = Float.random(in: -1.0...1.0)
            let randomY = Float.random(in: -1.0...1.0)
            let size = Float.random(in: 2.0...10.0)

            let xTerm = (randomX * randomX) / (0.9 * 0.9)
            let yTerm = (randomY * randomY) / (0.5 * 0.5)

            if xTerm + yTerm < 1.0 {
                particles.append(
                    Particle(position: [randomX, randomY], size: size)
                )
            }

        }

        return device.makeBuffer(
            bytes: particles,
            length: particles.count * MemoryLayout<Particle>.stride,
            options: []
        )!
    }
}
