#include <metal_stdlib>
#include "definitions.h"

using namespace metal;

struct VertexPayload {
    float4 position [[position]];
    half3 color;
    float pointSize [[point_size]];
};

vertex VertexPayload vertexMain(const device Vertex* vertices [[buffer(0)]],
                                constant float& time [[buffer(1)]],
                                uint vertexID [[vertex_id]]) {
    Vertex v = vertices[vertexID];
    VertexPayload payload;
    
    // Animation logic: Each point moves slightly differently based on its index
    float xOffset = sin(time + float(vertexID)) * 0.2;
    float yOffset = cos(time * 0.5 + float(vertexID)) * 0.1;
    
    payload.position = v.position;
    payload.position.x += xOffset;
    payload.position.y += yOffset;
    
    payload.color = half3(v.color);
    payload.pointSize = 30.0; // Larger size to see the smoothness
    
    return payload;
}

half4 fragment fragmentMain(VertexPayload frag [[stage_in]],
                            float2 pointCoord [[point_coord]]) {
    float dist = length(pointCoord - float2(0.5));
    float edgeSoftness = fwidth(dist);
    float alpha = 1.0 - smoothstep(0.5 - edgeSoftness, 0.5, dist);
    
    if (alpha <= 0.0) { discard_fragment(); }
    
    return half4(frag.color, alpha);
}

