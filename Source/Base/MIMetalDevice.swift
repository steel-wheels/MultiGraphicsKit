/*
 * @file MIMetalDevice.swift
 * @description Define MIMetalDevice class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import MetalKit
import Foundation

public class MIMetalDevice
{
        private var mDevice:            MTLDevice
        private var mCommandQueue:      MTL4CommandQueue
        private var mCommandBuffer:     MTL4CommandBuffer

        public static func doesSupportMetal4(device dev: MTLDevice) -> Bool {
                return dev.supportsFamily(.apple8)
        }

        public init(device dev: MTLDevice){
                mDevice = dev
                if let cmdq = mDevice.makeMTL4CommandQueue() {
                        mCommandQueue = cmdq
                } else {
                        fatalError("[Error] Failed to allocate command queue")
                }
                if let cmdbuf = mDevice.makeCommandBuffer() {
                        mCommandBuffer = cmdbuf
                } else {
                        fatalError("[Error] Failed to allocate command buffer")
                }
        }

        public func makeBuffer(length len: Int, options opts: MTLResourceOptions, placementSparsePageSize psize: MTLSparsePageSize) -> MTLBuffer {
                if let buf = mDevice.makeBuffer(length: len, options: opts, placementSparsePageSize: psize) {
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

        public func makeCommandAllocator() -> MTL4CommandAllocator {
                if let result = mDevice.makeCommandAllocator() {
                        return result
                } else {
                        fatalError("[Error] Failed to allocate command allocator")
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
