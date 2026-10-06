/*
 * @file MIGraphicsData.swift
 * @description Define MIGraphicsType data structure
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MetalKit
import Foundation

public class Vector2f
{
        public static func make(point pt: CGPoint) -> SIMD2<Float> {
                return  SIMD2<Float>(Float(pt.x), Float(pt.y))
        }

        public static func size() -> Int {
                return MemoryLayout<SIMD2<Float>>.size
        }

        public static func stride() -> Int {
                return MemoryLayout<SIMD2<Float>>.stride
        }

        public static func makeBuffer(device dev: MIMetalDevice, vectors vecs: Array<SIMD2<Float>>) -> MTLBuffer {
                let len = Vector2f.stride() * vecs.count
                return dev.makeBuffer(bytes: vecs, length: len, options: .storageModeShared)
        }

        public static func makeBuffer(device dev: MIMetalDevice, points pts: Array<CGPoint>) -> MTLBuffer {
                var vecs: Array<SIMD2<Float>> = []
                for pt in pts {
                        vecs.append(make(point: pt))
                }
                return makeBuffer(device: dev, vectors: vecs)
        }

        public static func makeUninitializedBuffer(device dev: MIMetalDevice, count cnt: Int) -> MTLBuffer {
                let len = Vector2f.stride() * cnt
                return dev.makeUninitializedBuffer(length: len, options: .storageModeShared)
        }

        public static func toPoint(source src: SIMD2<Float>) -> CGPoint {
                return CGPoint(x: CGFloat(src[0]), y: CGFloat(src[1]))
        }
}



