/*
 * @file MIMetalLibrary.swift
 * @description Extend MTLLibrary class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import Metal
import Foundation

public enum MIMetalFunctionName: String {
        case addVector2f        = "addVector2f"
}

public extension MTLLibrary
{
        func makeFunction(builtIn funcname: MIMetalFunctionName) -> MTLFunction {
                if let result = self.makeFunction(name: funcname.rawValue) {
                        return result
                } else {
                        fatalError("[Error] \(#file) No function definition")
                }
        }
}
