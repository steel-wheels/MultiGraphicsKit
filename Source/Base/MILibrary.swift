/*
 * @file MILibrary.swift
 * @description Extend MTLLibrary class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import Foundation

public enum MIMetalFunctionName: String {
        case addVector2f        = "addVector2f"
        case vertex_main        = "vertex_main"
        case fragment_main      = "fragment_main"
}

public extension MTLLibrary
{
        func makeFunction(builtIn funcname: MIMetalFunctionName) throws -> MTLFunction {
                if let result = self.makeFunction(name: funcname.rawValue) {
                        return result
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate function")
                }
        }
}
