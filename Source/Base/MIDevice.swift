/*
 * @file MIDevice.swift
 * @description Extend MTLDevice class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiDataKit
import MultiUIKit
import Metal
import Foundation
#if os(OSX)
import AppKit
#else
import UIKit
#endif

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

        func makingTexture(image img: MIImage) throws -> MTLTexture {
                guard let cgimg = img.cgImage else {
                        throw MIError.processError(message: "[Error] Failed to convert image")
                }
                let desc  = MTLTextureDescriptor.textureImageDescriptor(image: cgimg)
                if let texture = self.makeTexture(descriptor: desc) {
                        texture.copy(image: cgimg)
                        return texture
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate texture")
                }
        }
}


