//
//  atlasFunctions.metal
//  MultiGraphicsKit
//
//  Created by Tomoo Hamada on 2026/11/21.
//

#include <metal_stdlib>
#include "MultiGraphicsKit/MIGraphicsType.h"

using namespace metal;

struct RasterizerData
{
    float4 position [[position]];
    float2 texCoord;
};

vertex RasterizerData atlasVertexMain(
    uint vertexID [[vertex_id]],
    constant Vertex2f *         vertices [[buffer(0)]],
    constant Uniforms &         uniforms [[buffer(1)]],
    constant GlyphParams&       glyph    [[buffer(2)]]
)
{
    RasterizerData out;

    uint index = glyph.asciiCode ;
    uint col   = index % glyph.atlasColumns;
    uint row   = index / glyph.atlasColumns;

    float cellWidth  = 1.0f / float(glyph.atlasColumns) ;
    float cellHeight = 1.0f / float(glyph.atlasRows) ;

    float u0 = float(col) * cellWidth;
    float v0 = float(row) * cellHeight;
    float u1 = u0 + cellWidth;
    float v1 = v0 + cellHeight;

    float2 uv[6] =
    {
        float2(u0,v1),
        float2(u1,v1),
        float2(u0,v0),

        float2(u1,v1),
        float2(u1,v0),
        float2(u0,v0)
    };

    out.position = uniforms.mvpMatrix[vertexID] * float4(vertices[vertexID].position, 0.0, 1.0);
    out.texCoord = uv[vertexID];

    return out;
}

fragment float4 atlasFragmentMain(
    RasterizerData in [[stage_in]],
    texture2d<float> atlasTexture [[texture(0)]]
)
{
    constexpr sampler s(
        min_filter::linear,
        mag_filter::linear
    );

    float4 color =
        atlasTexture.sample(
            s,
            in.texCoord);

    return color;
}

