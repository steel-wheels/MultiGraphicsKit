/*
 * @file ImageTextureSample.swift
 * @description Sample program to draw image texture
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiGraphicsKit
import MultiDataKit
import MultiUIKit
import Metal
import AppKit
import Foundation

public func imageTextureSample(device dev: MTLDevice) -> Bool
{
        /* load PNG image */
        guard let img = loadImage() else {
                return false
        }
        do {
                let lib     = try dev.loadLibrary()

                let cmdq   = try dev.makingCommandQueue()
                let cmdbuf = try cmdq.makingCommandBuffer()

                let texture = try dev.makingTexture(image: img)

                let renderdesc   = MTLRenderPassDescriptor()
                guard let attach = renderdesc.colorAttachments[0] else {
                        NSLog("[Error] No attachement")
                        return false
                }
                attach.texture          = texture
                attach.clearColor       = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
                attach.storeAction      = .store

                let samplerdesc = MTLSamplerDescriptor()
                samplerdesc.minFilter    = .nearest
                samplerdesc.magFilter    = .linear
                samplerdesc.sAddressMode = .repeat
                samplerdesc.tAddressMode = .repeat
                let sampler = try dev.makingSamplerState(descriptor: samplerdesc)

                let cmdenc = cmdbuf.makeRenderCommandEncoder(descriptor: renderdesc)

        } catch {
                NSLog("Failed to execute")
                return false
        }

        return true
}

private func loadImage() -> MIImage?
{
        guard let resdir = FileManager.default.resourceDirectory else {
                NSLog("No resource directory")
                return nil
        }
        let filepath = resdir.appendingPathComponent("Images/steel-wheels.png")
        if let img = MIImage(contentsOf: filepath) {
                return img
        } else {
                NSLog("Failed to load image from \(filepath.path())")
                return nil
        }
}

