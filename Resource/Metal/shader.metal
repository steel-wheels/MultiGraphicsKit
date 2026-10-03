//
//  shader.metal
//  MultiGraphicsKit
//
//  Created by Tomoo Hamada on 2026/09/18.
//

#include <metal_stdlib>
#include "MultiGraphicsKit/MIGraphicsType.h"

using namespace metal;

typedef struct {
    float4 elements [[position]];
} Vector4fOut ;

vertex Vector4fOut
add_vector4f(constant float4 *vector0 [[buffer(0)]],
             constant float4 *vector1 [[buffer(1)]],
             uint vid [[vertex_id]])
{
        Vector4fOut result ;
        result.elements = vector0[vid] + vector1[vid] ;
        return result;
}

