/*
 * @file MIGraphicsData.swift
 * @description Define MIGraphicsType data structure
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
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

        public static func makeBuffer(device dev: MTLDevice, vectors vecs: Array<SIMD2<Float>>) throws -> MTLBuffer {
                let len = Vector2f.stride() * vecs.count
                if let buf = dev.makeBuffer(bytes: vecs, length: len, options: .storageModeShared) {
                        return buf
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate buffer")
                }
        }

        public static func makeBuffer(device dev: MTLDevice, points pts: Array<CGPoint>) throws -> MTLBuffer {
                var vecs: Array<SIMD2<Float>> = []
                for pt in pts {
                        vecs.append(make(point: pt))
                }
                return try makeBuffer(device: dev, vectors: vecs)
        }

        public static func makeUninitializedBuffer(device dev: MTLDevice, count cnt: Int) throws -> MTLBuffer {
                let len = Vector2f.stride() * cnt
                if let buf = dev.makeBuffer(length: len, options: .storageModeShared) {
                        return buf
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate buffer")
                }
        }

        public static func toPoint(source src: SIMD2<Float>) -> CGPoint {
                return CGPoint(x: CGFloat(src.x), y: CGFloat(src.y))
        }

        public static func toPoints(buffer buf: MTLBuffer) -> Array<CGPoint> {
                let len = buf.length / Vector2f.stride()
                let ptr = buf.contents().bindMemory(to: SIMD2<Float>.self, capacity: len)
                var result: Array<CGPoint> = []
                for i in 0..<len {
                        let x = CGFloat(ptr[i].x)
                        let y = CGFloat(ptr[i].y)
                        result.append(CGPoint(x: x, y: y))
                }
                return result
        }
}



