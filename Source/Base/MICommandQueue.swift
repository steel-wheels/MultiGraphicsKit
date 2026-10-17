/*
 * @file MICommandQueue.swift
 * @description Extend MTLCommandQueue class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import Foundation

public extension MTLCommandQueue
{
        func makingCommandBuffer() throws -> MTLCommandBuffer {
                if let buf = self.makeCommandBuffer() {
                        return buf
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate command buffer")
                }
        }
}
