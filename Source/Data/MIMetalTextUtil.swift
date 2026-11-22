/*
 * @file MIMetalTextUtil.swift
 * @description Extend MIMetalText class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import Foundation
import simd

public extension MIMetalText
{
        static func makeUniforms(x: Float, y: Float, width: Float, height: Float, rotation: Float) -> Uniforms {
                let c = cos(rotation)
                let s = sin(rotation)

                let scale = simd_float4x4(
                    SIMD4<Float>(width, 0, 0, 0),
                    SIMD4<Float>(0, height, 0, 0),
                    SIMD4<Float>(0, 0, 1, 0),
                    SIMD4<Float>(0, 0, 0, 1)
                )

                let rotate = simd_float4x4(
                    SIMD4<Float>( c, s, 0, 0),
                    SIMD4<Float>(-s, c, 0, 0),
                    SIMD4<Float>( 0, 0, 1, 0),
                    SIMD4<Float>( 0, 0, 0, 1)
                )

                let translate = simd_float4x4(
                    SIMD4<Float>(1, 0, 0, 0),
                    SIMD4<Float>(0, 1, 0, 0),
                    SIMD4<Float>(0, 0, 1, 0),
                    SIMD4<Float>(x, y, 0, 1)
                )

                let modelMatrix =
                    translate * rotate * scale

                return Uniforms(
                    mvpMatrix: modelMatrix
                )
        }
}
