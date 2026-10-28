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
        private var mDevice:            MTLDevice?          = nil

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
                NSLog("\(#file) drawableSizeWillChange(\(size.width), \(size.height))")
        }

        /* Delegate function */
        open func draw(in view: MTKView) {
                NSLog("\(#file) draw")
        }
}

