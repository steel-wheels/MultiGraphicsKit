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
import MetalKit
import Foundation

public class ImageTextureDrawer
{
        private var mView:              MTKView
        private var mDevice:            MTLDevice
        private var mTexture:           MTLTexture?
        private var mPipelineState:     MTLRenderPipelineState?

        public init(view: MTKView, device: MTLDevice) {
                self.mView              = view
                self.mDevice            = device
                self.mTexture           = nil
                self.mPipelineState     = nil
        }

        public func setup() {
                do {
                        let tex = try allocateTexture()
                        mTexture = tex

                        let descriptor = try allocateRenderPassDescriptot(texture: tex)
                        let sampler    = try allocateSamplerState()

                        let lib     = try mDevice.loadLibrary()
                        let vertex_main_func   = try lib.makeFunction(builtIn: .vertex_main)
                        let fragment_main_func = try lib.makeFunction(builtIn: .fragment_main)

                        descriptor.vertexFunction   = vertex_main_func
                        descriptor.fragmentFunction = fragment_main_func
                        descriptor.colorAttachments[0].pixelFormat = mView.colorPixelFormat
                        mPipelineState = try mDevice.makeRenderPipelineState(descriptor: descriptor)
                } catch {
                        NSLog("Failed to setup")
                }
        }

        private func allocateTexture() throws -> MTLTexture {
                guard let img = ImageTextureDrawer.loadImage() else {
                        NSLog("[Error] Failed to load image")
                        throw MIError.processError(message: "[Error] Failed to allocate image")
                }
                return try mDevice.makingTexture(image: img)
        }

        private func allocateRenderPassDescriptot(texture tex: MTLTexture) throws -> MTLRenderPassDescriptor {
                let desc = MTLRenderPassDescriptor()
                if let attach = desc.colorAttachments[0] {
                        attach.texture     = tex;
                        attach.loadAction  = .clear
                        attach.clearColor  = MTLClearColorMake(1.0, 0.0, 0.0, 1.0);
                        attach.storeAction = .store
                        return desc
                } else {
                        throw MIError.processError(message: "[Error] Failed to allocate render pass descriptor")
                }
        }

        private func allocateSamplerState() throws -> MTLSamplerState {
                let sampler = MTLSamplerDescriptor()
                sampler.minFilter    = .nearest
                sampler.magFilter    = .linear
                sampler.sAddressMode = .repeat
                sampler.tAddressMode = .repeat
                return try mDevice.makingSamplerState(descriptor: sampler)
        }

        public func draw() {
                do {
                        guard let drawable = self.mView.currentDrawable else {
                                NSLog("[Error] No drawable")
                                return
                        }
                        guard let texture = mTexture else {
                                NSLog("[Error] No texture")
                                return
                        }
                        guard let pstate = mPipelineState else {
                                NSLog("[Error] No pipeline")
                                return
                        }

                        let renderdesc   = MTLRenderPassDescriptor()
                        guard let attach = renderdesc.colorAttachments[0] else {
                                NSLog("[Error] No attachement")
                                return
                        }
                        attach.texture          = texture
                        attach.clearColor       = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
                        attach.storeAction      = .store

                        let cmdq   = try mDevice.makingCommandQueue()
                        let cmdbuf = try cmdq.makingCommandBuffer()
                        let cmdenc = try cmdbuf.makingRenderCommandEncoder(descriptor: renderdesc)
                        //cmdenc.setRenderPipelineState(pstate)
                        cmdenc.endEncoding()

                        cmdbuf.present(drawable)
                        cmdbuf.commit()

                        /*
                        let samplerdesc = MTLSamplerDescriptor()
                        samplerdesc.minFilter    = .nearest
                        samplerdesc.magFilter    = .linear
                        samplerdesc.sAddressMode = .repeat
                        samplerdesc.tAddressMode = .repeat
                        let sampler = try dev.makingSamplerState(descriptor: samplerdesc)
                         */
                } catch {
                        NSLog("Failed to execute")
                }
        }

        private static func loadImage() -> MIImage?
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
}

/*
public func imageTextureSample(view: MTKView, device dev: MTLDevice) -> Bool
{
        /* load PNG image */
        guard let img = loadImage() else {
                return false
        }


        return true
}



*/
