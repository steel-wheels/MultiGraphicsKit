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
        private var mPipelineState:     MTLRenderPipelineState? = nil
        private var mTexture:           MIScalableTexture?      = nil
        private var mBuffer:            MIImageBuffer?          = nil

        open override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
                do {
                        let mview = self.metalView
                        let srcimg = try loadImage(resourceFile: "Images/steel-wheels.png")
                        let sclimg = MIScalableImage(image: srcimg)
                        let mPipelineState = try MIRenderPipelineState.allocateTextureRenderPipelineState(view: mview)
                        mTexture = MIScalableTexture(device: self.device, image: sclimg)
                        mBuffer  = MIImageBuffer(device: self.device)
                } catch {
                        NSLog("[Error] \(error.localizedDescription)")
                }
        }

        open override func contentSizeUpdated(pointSize ptsize: CGSize, pixelSize pxsize: CGSize) {
                guard let tex = mTexture, let buf = mBuffer else {
                        NSLog("[Error] No texture")
                        return
                }
                do {
                        let _ = try tex.resize(to: pxsize)
                        let _ = try buf.resize(to: pxsize)
                        NSLog("drawablePixelSize: \(pxsize.width) x \(pxsize.height)")
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

