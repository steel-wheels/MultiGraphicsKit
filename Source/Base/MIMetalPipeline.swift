/*
 * @file MIMetalPipeline.swift
 * @description Define MIMetalPipeline class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MetalKit
import Foundation

open class MIMetalPipeline
{
        private var mDevice:            MIMetalDevice

        public init(device dev: MIMetalDevice){
                mDevice         = dev
        }

        private func makePipeline() -> Bool {
                guard let library = mDevice.loadLibrary() else {
                        NSLog("[Error] Failed to allocate library")
                        return false
                }

                let inbufs = allocateInputBuffers(device: mDevice)
                if inbufs.count == 0 {
                        NSLog("[Error] Failed to allocate input buffer")
                        return false
                }

                guard let outbuf = allocateOutputBuffer(device: mDevice) else {
                        NSLog("[Error] Failed to allocate output buffer")
                        return false
                }

                guard let bfunc = allocateFunction(library: library) else {
                        NSLog("[Error] Failed to allocate function")
                        return false
                }

                let cmdbuf = mDevice.makeCommandBuffer()
                guard let compenc = cmdbuf.makeComputeCommandEncoder() else {
                        NSLog("[Error] Failed to allocate command encoder")
                        return false
                }

                let pstate = mDevice.makeComputePipelineState(function: bfunc)
                compenc.setComputePipelineState(pstate)
        }

        open func allocateInputBuffers(device: MIMetalDevice) -> Array<MTLBuffer> {
                NSLog("[Error] \(#function) Must be override")
                return []
        }

        open func allocateOutputBuffer(device: MIMetalDevice) -> MTLBuffer? {
                NSLog("[Error] \(#function) Must be override")
                return nil
        }

        open func allocateFunction(library lib: MTLLibrary) -> MTLFunction? {
                NSLog("[Error] \(#function) Must be override")
                return nil
        }
}

