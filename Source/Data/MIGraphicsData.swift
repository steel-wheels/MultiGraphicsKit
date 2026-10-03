/*
 * @file MIGraphicsData.swift
 * @description Define MIGraphicsType data structure
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MetalKit
import Foundation

public extension Vector4f
{
        static func make(point pt: CGPoint) -> Vector4f {
                return Vector4f(elements: SIMD4<Float>(Float(pt.x), Float(pt.y), 0.0, 0.0))
        }

        static func size() -> Int {
                return MemoryLayout<Vector4f>.size
        }

        static func stride() -> Int {
                return MemoryLayout<Vector4f>.stride
        }

        static func makeBuffer(device dev: MIMetalDevice, vectors vecs: Array<Vector4f>) -> MTLBuffer {
                let len = Vector4f.stride() * vecs.count
                return dev.makeBuffer(bytes: vecs, length: len, options: .storageModeShared)
        }

        static func makeUninitializedBuffer(device dev: MIMetalDevice, count cnt: Int) -> MTLBuffer {
                let len = Vector4f.stride() * cnt
                return dev.makeUninitializedBuffer(length: len, options: .storageModeShared)
        }

        func toPoint() -> CGPoint {
                return CGPoint(x: CGFloat(self.elements[0]), y: CGFloat(self.elements[1]))
        }
}


