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

                /* notify the initial size*/
                mtkView(coreview.metalView, drawableSizeWillChange: coreview.frame.size)
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

        /* Delegate function */
        open func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
                NSLog("\(#file) drawablePointSize(\(size.width), \(size.height))")
                mDrawablePointSize = size
        }

        /* Delegate function */
        open func draw(in view: MTKView) {
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
                //NSLog("\(#file) draw")
        }
}

