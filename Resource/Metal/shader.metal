//
//  shader.metal
//  MultiGraphicsKit
//
//  Created by Tomoo Hamada on 2026/09/18.
//

#include <metal_stdlib>
#include "MultiGraphicsKit/MIGraphicsType.h"

using namespace metal;

[[kernel]] void
addVector2f(
            device float2 *             out [[buffer(0)]],
            const device float2 *       inA [[buffer(1)]],
            const device float2 *       inB [[buffer(2)]],
            uint id [[thread_position_in_grid]])
{
        out[id] = inA[id] + inB[id];
}
