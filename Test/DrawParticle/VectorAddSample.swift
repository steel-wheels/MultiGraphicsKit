/*
 * @file GraphicsDriver.h
 * @description Define graphics driver function
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiGraphicsKit
import MultiDataKit
import Metal
import Foundation

public func vectorAddSample(device dev: MTLDevice) -> Bool
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

        do {
                let lib     = try dev.loadLibrary()
                let addfunc = try lib.makeFunction(builtIn: .addVector2f)
                let pstate  = try dev.makeComputePipelineState(function: addfunc)

                let cmdq   = try dev.makingCommandQueue()
                let cmdbuf = try cmdq.makingCommandBuffer()
                let cmdenc = try cmdbuf.makingComputeCommandEncoder()

                // allocate buffers
                let inbuf0  = try Vector2f.makeBuffer(device: dev, points: src0)
                let inbuf1  = try Vector2f.makeBuffer(device: dev, points: src1)
                let outbuf  = try Vector2f.makeUninitializedBuffer(device: dev, count: POINT_NUM)

                NSLog("inbuf0: \(String(inbuf0.gpuAddress, radix: 16))")
                NSLog("inbuf1: \(String(inbuf1.gpuAddress, radix: 16))")
                NSLog("outbuf: \(String(outbuf.gpuAddress, radix: 16))")

                cmdenc.setBuffer(outbuf, offset: 0, index: 0)
                cmdenc.setBuffer(inbuf0, offset: 0, index: 1)
                cmdenc.setBuffer(inbuf1, offset: 0, index: 2)
                cmdenc.setComputePipelineState(pstate)

                let threadsPerGrid        = MTLSize(width: POINT_NUM, height: 1, depth: 1)
                let threadsPerThreadgroup = MTLSize(width: 1, height: 1, depth: 1)
                cmdenc.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
                cmdenc.endEncoding()

                cmdbuf.commit()
                cmdbuf.waitUntilCompleted()

                NSLog("- print result")
                putBuffer(name: "inbuf0", buffer: inbuf0)
                putBuffer(name: "inbuf1", buffer: inbuf1)
                putBuffer(name: "outbuf", buffer: outbuf)

                return true
        } catch {
                NSLog("Failed to execute")
                return false
        }
}

private func putBuffer(name nm: String, buffer buf: MTLBuffer) {
        let pts = Vector2f.toPoints(buffer: buf)
        NSLog("-- \(nm).count = \(pts.count)")
        for pt in pts {
                NSLog("    -> \(pt.x), \(pt.y)")
        }
}

