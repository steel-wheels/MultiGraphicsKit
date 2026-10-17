/*
 * @file MIDevice.swift
 * @description Extend MTLDevice class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import Foundation

public extension MTLDevice
{
        func loadLibrary() throws -> MTLLibrary {
                if let resdir  = FileManager.default.resourceDirectory(forClass: MIMetalCoreView.self) {
                        let libfile = resdir.appendingPathComponent("default.metallib")
                        return try self.makeLibrary(URL: libfile)
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate library")
                }
        }

        func makingCommandQueue() throws -> MTLCommandQueue {
                if let cmdq = self.makeCommandQueue() {
                        return cmdq
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate command queue")
                }
        }
}


