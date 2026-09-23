/*
 * @file MIVertex.swift
 * @description Define MIVertex data structure
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import MetalKit
import MultiUIKit
import Foundation

public extension CGPoint
{
        func toVector() -> simd_float2 {
                return [Float(self.x), Float(self.y)]
        }

        static func fromVector(points pts: simd_float2) -> CGPoint {
                return CGPoint(x: CGFloat(pts[0]), y: CGFloat(pts[1]))
        }
}

public extension CGColor
{
        func toVector() -> simd_float4 {
                let (r, g, b, a) = self.grbComponents
                return [Float(r), Float(g), Float(b), Float(a)]
        }

        static func fromVector(components comps: simd_float4) -> CGColor {
                return CGColor(red:  CGFloat(comps[0]), green: CGFloat(comps[1]),
                               blue: CGFloat(comps[2]), alpha: CGFloat(comps[3]))
        }
}

public struct MIVertex
{
        var position:           simd_float2
        var color:              simd_float4

        public init(position: CGPoint, color: CGColor) {
                self.position = position.toVector()
                self.color    = color.toVector()
        }
}
