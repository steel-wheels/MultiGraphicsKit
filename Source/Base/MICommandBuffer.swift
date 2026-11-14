/*
 * @file MICommandBuffer.swift
 * @description Extend MTLCommandBuffer class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import Foundation

public extension MTLCommandBuffer
{
        func makingComputeCommandEncoder() throws -> MTLComputeCommandEncoder {
                if let cmdenc = self.makeComputeCommandEncoder() {
                        return cmdenc
                } else {
                        throw MIGraphicsError.objectAllocationFailure("MTLComputeCommandEncoder")
                }
        }

        func makingRenderCommandEncoder(descriptor desc: MTLRenderPassDescriptor) throws -> MTLRenderCommandEncoder {
                if let cmdenc = self.makeRenderCommandEncoder(descriptor: desc) {
                        return cmdenc
                } else {
                        throw MIGraphicsError.objectAllocationFailure("MTLRenderCommandEncoder")

                }
        }
}
