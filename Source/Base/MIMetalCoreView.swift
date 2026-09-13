/*
 * @file MIMetalCoreView.swift
 * @description Define MIMetalCoreView class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import MultiUIKit
import MetalKit
import Foundation

open class MIMetalCoreView: MICoreView
{
        private var mMetalView:         MTKView                 = MTKView()
        private var mDevice:            MTLDevice?              = nil

        public var device: MTLDevice { get {
                if let dev = mDevice {
                        return dev
                } else {
                        fatalError("No metal device")
                }
        }}

        open override func setup() {
                setup(coreView: mMetalView)
                mDevice = MTLCreateSystemDefaultDevice()
                if let dev = mDevice {
                        mMetalView.device = dev
                } else {
                        NSLog("[Error] Failed to allocate device")
                }
        }

        open override var backgroundColor: MIColor? {
                get {
                        return super.backgroundColor
                }
                set(colp){
                        let r, g, b, a: Double
                        if let col = colp {
                                r = col.redComponent ; g = col.greenComponent ; b = col.blueComponent
                        } else {
                                r = 0.0 ; g = 0.0 ; b = 0.0
                        }
                        a = 1.0
                        mMetalView.clearColor = MTLClearColorMake(r, g, b, a)
                        super.backgroundColor = colp
                }
        }

        public func setDelegate(delegate dlg: MTKViewDelegate) {
                mMetalView.delegate = dlg
        }

        public func setNeedsDisplay(_ needs: Bool) {
                mMetalView.enableSetNeedsDisplay = needs
        }
}

