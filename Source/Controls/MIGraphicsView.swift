/*
 * @file MIGraphicsView.swift
 * @description Define MIGraphicsView class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import  MultiUIKit
import  MetalKit
#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)

open class MIGraphicsView: MIInterfaceView, MTKViewDelegate
{
        private var mShaderLibrary: MIMetalShader?      = nil

        open override func setup(frame frm: CGRect) {
                super.setup(nibName: "MIMetalCoreView", frameSize: frm.size, forClass: MIGraphicsView.self)

                let coreview = metalCoreView()
                coreview.setDelegate(delegate: self)

                let device = coreview.device
                guard let lib = device.makeDefaultLibrary() else {
                        NSLog("[Error] Failed to allocate library")
                        return
                }
                mShaderLibrary = MIMetalShader(library: lib)
        }

        private func metalCoreView() -> MIMetalCoreView {
                if let core: MIMetalCoreView = super.coreView() {
                        return core
                } else {
                        fatalError("Failed to get core view")
                }
        }

        public func setNeedsDisplay(_ needs: Bool) {
                let coreview = metalCoreView()
                coreview.setNeedsDisplay(needs)
        }

        /* Delegate function */
        open func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
                NSLog("\(#file) drawableSizeWillChange")
        }

        /* Delegate function */
        public func draw(in view: MTKView) {
                let device   = metalCoreView().device
                let commandq = device.makeCommandQueue()
        }
}

