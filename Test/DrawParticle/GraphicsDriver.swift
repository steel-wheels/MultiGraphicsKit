/*
 * @file GraphicsDriver.h
 * @description Define graphics driver function
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiGraphicsKit
import Metal
import Foundation

public func graphicsDriver(device dev: MIMetalDevice) -> Bool
{
        // make source data
        let POINT_NUM            = 8
        var src0: Array<CGPoint> = []
        var src1: Array<CGPoint> = []
        for i in 0..<POINT_NUM {
                let x: CGFloat = CGFloat(i) * 2.0
                let y: CGFloat = x + 1.0
                src0.append(CGPoint(x: x,   y: y))
                src1.append(CGPoint(x: 1.0, y: 1.0))
        }

        // load library
        guard let lib = dev.loadLibrary() else {
                NSLog("[Error] Failed to load library")
                return false
        }

        // allocate pipeline state with vector-add function
        let addfunc = lib.makeFunction(builtIn: .addVector2f)
        let pstate  = dev.makeComputePipelineState(function: addfunc)

        // allocate buffers
        let inbuf0  = Vector2f.makeBuffer(device: dev, points: src0)
        let inbuf1  = Vector2f.makeBuffer(device: dev, points: src1)
        let outbuf  = Vector2f.makeUninitializedBuffer(device: dev, count: POINT_NUM)

        // make command encoder
        let cmdbuf = dev.makeCommandBuffer()
        guard let cmdenc: MTL4ComputeCommandEncoder = cmdbuf.makeComputeCommandEncoder() else {
                NSLog("[Error] Failed to allocate command encoder")
                return false
        }
        cmdenc.setComputePipelineState(pstate)
        cmdenc.setBuffer(outbuf, offset: 0, index: 0)
        cmdenc.setBuffer(inbuf0, offset: 0, index: 1)
        cmdenc.setBuffer(inbuf1, offset: 0, index: 2)

        return true
}
