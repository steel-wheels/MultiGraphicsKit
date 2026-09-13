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
        public typealias ButtonPressedCallback = MIButtonCore.ButtonPressedCallback

        public override func setup(frame frm: CGRect) {
                super.setup(nibName: "MIMetalCoreView", frameSize: frm.size, forClass: MIGraphicsView.self)

                let coreview = metalCoreView()
                coreview.setDelegate(delegate: self)
                coreview.setNeedsDisplay(true)
        }

        private func metalCoreView() -> MIMetalCoreView {
                if let core: MIMetalCoreView = super.coreView() {
                        return core
                } else {
                        fatalError("Failed to get core view")
                }
        }

        public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
                NSLog("*** drawableSizeWillChange")
        }

        public func draw(in view: MTKView) {
                NSLog("*** draw")
        }
}




