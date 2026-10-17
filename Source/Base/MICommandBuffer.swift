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
                if let cmdbuf = self.makeComputeCommandEncoder() {
                        return cmdbuf
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate command encoder")
                }
        }
}
