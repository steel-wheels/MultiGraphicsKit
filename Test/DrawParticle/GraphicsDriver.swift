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

public func graphicsDriver(device dev: MIMetalDevice) -> NSError?
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
                return MIError.fileError(message: "[Error] Failed to load library")
        }

        // allocate pipeline state with vector-add function
        let addfunc = lib.makeFunction(builtIn: .addVector2f)
        let pstate  = dev.makeComputePipelineState(function: addfunc)

        // allocate buffers
        let inbuf0  = Vector2f.makeBuffer(device: dev, points: src0)
        let inbuf1  = Vector2f.makeBuffer(device: dev, points: src1)
        let outbuf  = Vector2f.makeUninitializedBuffer(device: dev, count: POINT_NUM)

        switch dev.makeCommandAllocator(label: "AddVectors") {
        case .success(let alloc):
                let cmdbuf: MTL4CommandBuffer = dev.makeCommandBuffer()
                cmdbuf.beginCommandBuffer(allocator: alloc)

                NSLog("- make command encoder")
                guard let cmdenc: MTL4ComputeCommandEncoder = cmdbuf.makeComputeCommandEncoder() else {
                        return MIError.fileError(message: "[Error] Failed to allocate command encoder")
                }

                NSLog("- allocate set pipeline state")
                cmdenc.setComputePipelineState(pstate)

                NSLog("- allocate argument table")
                let argdesc = MTL4ArgumentTableDescriptor()
                argdesc.maxBufferBindCount = 3
                let argtable = dev.makeArgumentTable(descriptor: argdesc)
                argtable.setAddress(outbuf.gpuAddress, index: 0)
                argtable.setAddress(inbuf0.gpuAddress, index: 1)
                argtable.setAddress(inbuf1.gpuAddress, index: 2)
                cmdenc.setArgumentTable(argtable)

                let threadsPerGrid        = MTLSize(width: POINT_NUM, height: 1, depth: 1)
                let threadsPerThreadgroup = MTLSize(width: 1, height: 1, depth: 1)
                cmdenc.dispatchThreads(threadsPerGrid: threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
                cmdenc.endEncoding()
                cmdbuf.endCommandBuffer()

                NSLog("- exec comand buffer")
                switch dev.makeSharedEvent(signaledValue: 1) {
                case .success(let evt):
                        let cmdq = dev.commandQueue
                        cmdq.signalEvent(evt, value: 1)
                        cmdq.commit([cmdbuf])

                        NSLog("- wait event")
                        cmdq.waitForEvent(evt, value: 1)
                        NSLog("- done wait event")

                        NSLog("- print result")
                        putBuffer(name: "inbuf0", buffer: inbuf0)
                        putBuffer(name: "inbuf1", buffer: inbuf1)
                        putBuffer(name: "outbuf", buffer: outbuf)
                case .failure(let err):
                        return err
                }

                return nil
        case .failure(let err):
                return err
        }
}

private func putBuffer(name nm: String, buffer buf: MTLBuffer) {
        let pts = Vector2f.toPoints(buffer: buf)
        NSLog("-- \(nm).count = \(pts.count)")
        for pt in pts {
                NSLog("    -> \(pt.x), \(pt.y)")
        }
}

