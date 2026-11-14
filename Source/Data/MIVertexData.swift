/*
 * @file MIVertexData.swift
 * @description Define data types for vertex
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import Foundation

public extension Vertex2f
{
        func make(position pos: CGPoint, coodinate cood: CGPoint) -> Vertex2f {
                let vpos:  vector_float2 = SIMD2(Float(pos.x ), Float(pos.y ))
                let vcood: vector_float2 = SIMD2(Float(cood.x), Float(cood.y))
                return Vertex2f(position: vpos, textureCoordinate: vcood)
        }

        static func size() -> Int {
                return MemoryLayout<Vertex2f>.size
        }

        static func stride() -> Int {
                return MemoryLayout<Vertex2f>.stride
        }

        static func makeBuffer(device dev: MTLDevice, vertexes vecs: Array<Vertex2f>) throws -> MTLBuffer {
            let len = Vertex2f.stride() * vecs.count
            if let buf = dev.makeBuffer(bytes: vecs, length: len, options: .storageModeShared) {
                    return buf
            } else {
                    throw MIGraphicsError.objectAllocationFailure("MTLBuffer")
            }
        }
}

public class QuadVertices2f
{
        public static func allocateFor2DImage(size: CGSize) -> Array<Vertex2f> {
                let hwidth   = Float(size.width  / 2.0)
                let hheight  = Float(size.height / 2.0)
                let quadVertices: Array<Vertex2f> = [
                        // Pixel positions, Texture coordinates
                        Vertex2f(position: SIMD2(+hwidth, -hheight), textureCoordinate: SIMD2(1.0, 1.0)),
                        Vertex2f(position: SIMD2(-hwidth, -hheight), textureCoordinate: SIMD2(0.0, 1.0)),
                        Vertex2f(position: SIMD2(-hwidth, +hheight), textureCoordinate: SIMD2(0.0, 0.0)),
                        Vertex2f(position: SIMD2(+hwidth, -hheight), textureCoordinate: SIMD2(1.0, 1.0)),
                        Vertex2f(position: SIMD2(-hwidth, +hheight), textureCoordinate: SIMD2(0.0, 0.0)),
                        Vertex2f(position: SIMD2(+hwidth, +hheight), textureCoordinate: SIMD2(1.0, 0.0)),
                ]
                return quadVertices
        }
}

