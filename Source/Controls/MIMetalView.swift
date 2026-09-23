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
        private var mDevice:            MIMetalDevice?          = nil

        open override func setup(frame frm: CGRect) {
                super.setup(nibName: "MIMetalCoreView", frameSize: frm.size, forClass: MIMetalView.self)

                let coreview = metalCoreView()
                coreview.setDelegate(delegate: self)

                let dev = MIMetalDevice(device: coreview.device)
                mDevice = dev
        }

        private func metalCoreView() -> MIMetalCoreView {
                if let core: MIMetalCoreView = super.coreView() {
                        return core
                } else {
                        fatalError("Failed to get core view")
                }
        }

        public var device: MIMetalDevice { get {
                if let dev = mDevice {
                        return dev
                } else {
                        fatalError("[Error] No device")
                }
        }}

        public func setNeedsDisplay(_ needs: Bool) {
                let coreview = metalCoreView()
                coreview.setNeedsDisplay(needs)
        }

        /* Delegate function */
        public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
                NSLog("\(#file) drawableSizeWillChange")
        }

        /* Delegate function */
        open func draw(in view: MTKView) {
                NSLog("\(#file) draw")
        }
}

