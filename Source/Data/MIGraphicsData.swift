/*
 * @file MIGraphicsData.swift
 * @description Define MIGraphicsType data structure
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MetalKit
import Foundation

public extension GPoint2f
{
        static func make(point pt: CGPoint) -> GPoint2f {
                return GPoint2f(position: SIMD2<Float>(Float(pt.x), Float(pt.y)))
        }

        static func size() -> Int {
                return MemoryLayout<GPoint2f>.size
        }

        func toPoint() -> CGPoint {
                return CGPoint(x: CGFloat(self.position[0]), y: CGFloat(self.position[1]))
        }
}

