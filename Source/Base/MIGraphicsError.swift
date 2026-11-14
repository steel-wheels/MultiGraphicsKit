/*
 * @file MIGraphicsError.swift
 * @description Define MIGraphicsError
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation

public enum MIGraphicsError: Error {
        case objectAllocationFailure(String)    // class name
        case noImageFile(String)                // path of the file
        case convertFailed

        public var localizedDescription: String { get {
                let result: String
                switch self {
                case .objectAllocationFailure(let clsname):
                        result = "Failed to allocate \(clsname)"
                case .noImageFile(let path):
                        result = "No image file: \(path)"
                case .convertFailed:
                        result = "Failed to convert"
                }
                return result
        }}
}

