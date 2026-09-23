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
        #if os(OSX)
        @IBOutlet weak var mMetalView: MTKView!
        #else
        @IBOutlet weak var mMetalView: MTKView!
        #endif

        open override func setup() {
                setup(coreView: mMetalView)
                if let dev = MTLCreateSystemDefaultDevice() {
                        mMetalView.device = dev
                } else {
                        NSLog("[Error] Failed to allocate device")
                }
        }

        public var device: MTLDevice { get {
                if let dev = mMetalView.device {
                        return dev
                } else {
                        fatalError("No metal device")
                }
        }}

        public var currentDrawable : CAMetalDrawable? { get {
                return mMetalView.currentDrawable
        }}

        public var colorPixelFormat: MTLPixelFormat { get {
                return mMetalView.colorPixelFormat
        }}

        public func setDelegate(delegate dlg: MTKViewDelegate) {
                mMetalView.delegate = dlg
        }

        public func setNeedsDisplay(_ needs: Bool) {
                mMetalView.enableSetNeedsDisplay = needs
        }
}

