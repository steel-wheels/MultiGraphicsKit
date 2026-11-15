/*
 * @file MIBuffer.swift
 * @description Define MIBuffer class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import MultiUIKit
import Metal
import MetalKit
#if os(OSX)
import AppKit
#else
import UIKit
#endif

public class MIImageBuffer
{
        private var mDevice:            MTLDevice
        private var mBuffer:            MTLBuffer?
        private var mCurrentSize:       CGSize

        public init(device dev: MTLDevice) {
                self.mDevice            = dev
                self.mBuffer            = nil
                self.mCurrentSize       = CGSize.zero
        }

        public func buffer() throws -> MTLBuffer {
                if let buf = mBuffer {
                        return buf
                } else {
                        throw MIGraphicsError.nullObject
                }
        }

        public var vertexCount: Int { get {
                return QuadVertices2f.vertexCount
        }}

        public func resize(to newsize: CGSize) throws -> Bool {
                if mBuffer == nil || (mCurrentSize != newsize) {
                        mBuffer = try MIImageBuffer.allocateBuffer(device: mDevice, size: newsize)
                        return true
                } else {
                        return false
                }
        }

        private static func allocateBuffer(device dev: MTLDevice, size: CGSize) throws -> MTLBuffer {
                // Set up a simple MTLBuffer with vertices which include texture coordinates
                let quadVertices = QuadVertices2f.allocateFor2DImage(size: size)
                return try Vertex2f.makeBuffer(device: dev, vertexes: quadVertices)
        }
}

