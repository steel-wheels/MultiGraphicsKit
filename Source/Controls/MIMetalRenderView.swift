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
        private var mImage:     MIScalableImage?        = nil

        open override func setup(frame frm: CGRect) {
                super.setup(frame: frm)
                do {
                        let img = try loadImage(resourceFile: "Images/steel-wheels-2.png")
                        mImage = MIScalableImage(image: img)
                } catch {
                        NSLog("[Error] \(error.localizedDescription)")
                }
        }

        open override func contentSizeUpdated(pointSize ptsize: CGSize, pixelSize pxsize: CGSize) {
                NSLog("drawablePixelSize: \(pxsize.width) x \(pxsize.height)")
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

