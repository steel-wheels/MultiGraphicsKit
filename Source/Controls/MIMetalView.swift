/*
 * @file MIMetalView.swift
 * @description Define MIMetalView class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import  MultiUIKit
import  MultiDataKit
import  MetalKit
#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)

open class MIMetalView: MIInterfaceView, MTKViewDelegate
{
        private var mDevice:            MTLDevice?      = nil
        private var mDrawablePointSize: CGSize          = CGSize.zero
        private var mDrawablePixelSize: CGSize          = CGSize.zero

        open override func setup(frame frm: CGRect) {
                super.setup(nibName: "MIMetalCoreView", frameSize: frm.size, forClass: MIMetalView.self)

                let coreview = metalCoreView()
                coreview.setDelegate(delegate: self)
                mDevice = coreview.device
        }

        private func metalCoreView() -> MIMetalCoreView {
                if let core: MIMetalCoreView = super.coreView() {
                        return core
                } else {
                        fatalError("Failed to get core view")
                }
        }

        public var metalView: MTKView { get {
                return metalCoreView().metalView
        }}

        public var device: MTLDevice { get {
                if let dev = mDevice {
                        return dev
                } else {
                        fatalError("Failed to get device")
                }
        }}

        public var colorPixelFormat: MTLPixelFormat { get {
                return metalView.colorPixelFormat
        }}

        public func setNeedsDisplay(_ needs: Bool) {
                let coreview = metalCoreView()
                coreview.setNeedsDisplay(needs)
        }

        #if os(OSX)
        open override func viewDidMoveToWindow() {
                NSLog("viewDidMoveToWindow")
                /* notify the initial size*/
                let coreview = metalCoreView()
                mtkView(coreview.metalView, drawableSizeWillChange: coreview.frame.size)
        }
        #endif

        /* Delegate function */
        open func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
                NSLog("\(#file) drawablePointSize(\(size.width), \(size.height))")
                mDrawablePointSize = size

                #if os(OSX)
                if let win = view.window {
                        let ptrect  = CGRect(origin: CGPoint.zero, size: mDrawablePointSize)
                        let pixrect = win.convertToBacking(ptrect)
                        if pixrect.width != mDrawablePixelSize.width || pixrect.height != mDrawablePixelSize.height {
                                mDrawablePixelSize = pixrect.size
                                contentSizeUpdated(pointSize: mDrawablePointSize, pixelSize: mDrawablePixelSize)
                        }
                }
                #else
                NSLog("[Error] No drawablePixelSize")
                mDrawablePixelSize = mDrawablePointSize
                #endif
        }

        open func contentSizeUpdated(pointSize ptsize: CGSize, pixelSize pxsize: CGSize) {
        }

        /* Delegate function */
        open func draw(in view: MTKView) {
                /*
                #if os(OSX)
                if let win = view.window {
                        let ptrect  = CGRect(origin: CGPoint.zero, size: mDrawablePointSize)
                        let pixrect = win.convertToBacking(ptrect)
                        if pixrect.width != mDrawablePixelSize.width || pixrect.height != mDrawablePixelSize.height {
                                mDrawablePixelSize = pixrect.size
                                NSLog("drawablePixelSize: \(mDrawablePixelSize.width) x \(mDrawablePixelSize.height)")
                        }
                }
                #endif
                 */
                //NSLog("\(#file) draw")
        }
}

