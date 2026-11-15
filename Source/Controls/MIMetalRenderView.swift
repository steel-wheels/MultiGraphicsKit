/*
 * @file MIMetalRenderView.swift
 * @description Define MIMetalRenderView class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import  MultiUIKit
import  MultiDataKit
import  MetalKit
#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)

open class MIMetalRenderView: MIMetalView
{
        private var mPipelineState:     MTLRenderPipelineState?         = nil
        private var mTexture:           MIScalableTexture?              = nil
        private var mImageBuffer:       MIImageBuffer?                  = nil
        private var mCommandEncoder:    MIImageCommandEncoder?          = nil
        private var mCurrentEncoder:    MTLRenderCommandEncoder?        = nil

        public func setup(resourceFile file: String) {
                do {
                        let mview = self.metalView
                        let srcimg = try loadImage(resourceFile: file)
                        let sclimg = MIScalableImage(image: srcimg)
                        mPipelineState  = try MIRenderPipelineState.allocateTextureRenderPipelineState(view: mview)
                        mTexture        = MIScalableTexture(device: self.device, image: sclimg)
                        mImageBuffer    = MIImageBuffer(device: self.device)
                        mCommandEncoder = MIImageCommandEncoder(view: mview)
                } catch {
                        NSLog("[Error] \(error.localizedDescription)")
                }
        }

        open override func contentSizeUpdated(pointSize ptsize: CGSize, pixelSize pxsize: CGSize) {
                guard let tex = mTexture, let imgbuf = mImageBuffer, let cmdenc = mCommandEncoder else {
                        NSLog("[Error] No texture")
                        return
                }
                do {
                        let _ = try tex.resize(to: pxsize)
                        let _ = try imgbuf.resize(to: pxsize)
                        let _ = cmdenc.resize(to: pxsize)
                        NSLog("drawablePixelSize: \(pxsize.width) x \(pxsize.height)")
                } catch {
                        NSLog("[Error] \(error.localizedDescription)")
                }
        }

        open override func draw(in view: MTKView) {
                guard let pstate = mPipelineState, let cmdenc = mCommandEncoder, let imgbuf = mImageBuffer,
                      let tex = mTexture, let drawable = view.currentDrawable else {
                        NSLog("[Error] No texture")
                        return
                }
                do {
                        let dev    = super.device
                        let cmdq   = try dev.makingCommandQueue()
                        let cmdbuf = try cmdq.makingCommandBuffer()
                        mCurrentEncoder = try cmdenc.allocate(pipelineState: pstate,
                                                              commandBuffer: cmdbuf,
                                                              imageBuffer: imgbuf,
                                                              texture: try tex.texture())
                        cmdbuf.present(drawable)
                        cmdbuf.commit()
                } catch {
                        NSLog("[Error] \(error.localizedDescription)")
                }
        }

        private func loadImage(resourceFile rfile: String) throws -> MIImage {
                guard let resdir = FileManager.default.resourceDirectory else {
                        NSLog("No resource directory")
                        throw MIGraphicsError.noImageFile(rfile)
                }
                let filepath = resdir.appendingPathComponent(rfile)
                if let img = MIImage(contentsOf: filepath) {
                        return img
                } else {
                        NSLog("Failed to load image from \(filepath.path())")
                        throw MIGraphicsError.noImageFile(filepath.path())
                }
        }
}

