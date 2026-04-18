#include <metal_stdlib>
#include "definitions.h"

using namespace metal;

struct VertexPayload {
    float4 position [[position]];
    float pointSize [[point_size]];
    float brightness;
};

vertex VertexPayload vertexMain(const device Particle* particles [[buffer(0)]],
                                constant float& time [[buffer(1)]],
                                uint vertexID [[vertex_id]],
                                uint instanceID [[instance_id]]) {
    Particle p = particles[vertexID];
    
    VertexPayload payload;
    
    float dist = length(p.position);
    float angle = atan2(p.position.y, p.position.x);

    float speed = 1.0 / (dist + 0.1); // Closer stars move faster
    float animatedAngle = angle + (time * speed);

    float x = cos(animatedAngle) * dist;
    float y = sin(animatedAngle) * dist;

    // 4. Assign to payload
    payload.position = float4(x, y, 0.0, 1.0);
    payload.pointSize = p.size;
    payload.brightness = 1.0 - (dist * 0.5);
    
    
    return payload;
}

half4 fragment fragmentMain(VertexPayload frag [[stage_in]],
                            float2 pointCoord [[point_coord]]) {
    float dist = length(pointCoord - float2(0.5));
    float alpha = 1.0 - smoothstep(0.3, 0.5, dist);

    if (alpha <= 0.0) { discard_fragment(); }

    float b = frag.brightness * alpha;
    return half4(half3(b), b);
}
