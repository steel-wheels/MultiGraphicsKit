/*
 * @file MIMetalDevice.swift
 * @description Define MIMetalDevice class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import Foundation

public class MIMetalDevice
{
        private var mDevice:            MTLDevice
        private var mCommandQueue:      MTL4CommandQueue

        public static func doesSupportMetal4(device dev: MTLDevice) -> Bool {
                return dev.supportsFamily(.apple8)
        }

        public init(device dev: MTLDevice){
                mDevice       = dev
                if let cmdq = dev.makeMTL4CommandQueue() {
                        mCommandQueue = cmdq
                } else {
                        fatalError("[Error] Fatal to allocate command queue")
                }
        }

        public var commandQueue: MTL4CommandQueue { get {
                return mCommandQueue
        }}

        public func makeBuffer(bytes ptr: UnsafeRawPointer, length len: Int, options opts: MTLResourceOptions) -> MTLBuffer {
                if let buf = mDevice.makeBuffer(bytes: ptr, length: len, options: opts) {
                        return buf
                } else {
                        fatalError("[Error] Failed to allocate buffer")
                }
        }

        public func makeUninitializedBuffer(length len: Int, options opts: MTLResourceOptions) -> MTLBuffer {
                if let buf = mDevice.makeBuffer(length: len, options: opts) {
                        return buf
                } else {
                        fatalError("[Error] Failed to allocate buffer")
                }
        }

        public func makeArgumentTable(descriptor desc: MTL4ArgumentTableDescriptor) -> MTL4ArgumentTable {
                do {
                        return try mDevice.makeArgumentTable(descriptor: desc)
                } catch {
                        fatalError("[Error] Failed to allocate argument table")
                }
        }

        public func makeResidencySet(descriptor desc: MTLResidencySetDescriptor) -> MTLResidencySet {
                do {
                        return try mDevice.makeResidencySet(descriptor: desc)
                } catch {
                        fatalError("[Error] Failed to allocate residency set")
                }
        }

        public func makeCommandBuffer() -> MTL4CommandBuffer {
                if let result = mDevice.makeCommandBuffer() {
                        return result
                } else {
                        fatalError("[Error] Failed to allocate command buffer")
                }
        }

        public func makeCommandAllocator() -> MTL4CommandAllocator {
                if let result = mDevice.makeCommandAllocator() {
                        return result
                } else {
                        fatalError("[Error] Failed to allocate command allocator")
                }
        }

        public func makeComputePipelineState(function cfunc: MTLFunction) -> MTLComputePipelineState {
                do {
                        return try mDevice.makeComputePipelineState(function: cfunc)
                } catch {
                        fatalError("[Error] Failed to make compute pipeline state")
                }
        }

        public func loadLibrary() -> MTLLibrary? {
                guard let resdir  = FileManager.default.resourceDirectory(forClass: MIMetalDevice.self) else {
                        return nil
                }
                let libfile = resdir.appendingPathComponent("default.metallib")
                do {
                        return try mDevice.makeLibrary(URL: libfile)
                } catch {
                        NSLog("[Error] Failed to make library")
                        return nil
                }
        }
}
