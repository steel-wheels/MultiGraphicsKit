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

#if os(OSX)
public extension MIMetalText
{
        typealias FontAtlas = MIAtlasTable.FontAtlas

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

        func allocateUniforms(fontAtlas atlas: FontAtlas) -> (Array<Uniforms>, Array<GlyphParams>) {
                var result0: Array<Uniforms> = []
                var result1: Array<GlyphParams> = []
                let width  = Float(atlas.cellSize.width)
                let height = Float(atlas.cellSize.height)
                var ypos: Float = 0.0
                for v in 0..<self.text.count {
                        var xpos: Float = 0.0
                        let line = self.text[v]
                        for h in 0..<line.count {
                                let char = line[h]
                                if !char.isNull {
                                        /* Uniforms */
                                        let uniform = MIMetalText.makeUniforms(x: xpos, y: ypos,
                                                                               width: width, height: height,
                                                                               rotation: 0.0)
                                        result0.append(uniform)
                                        let gparams = MIAtlasTable.glyphParam(for: char.asciiCode)
                                        result1.append(gparams)
                                }
                                xpos += width
                        }
                        ypos += height
                }
                return (result0, result1)
        }
}
#endif // os(OSX)

