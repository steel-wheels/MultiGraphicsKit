/*
 * @file MIGraphicsView.swift
 * @description Define MIGraphicsView class
 * @par Copyright
 *   Copyright (C) 2024 Steel Wheels Project
 */

import  MultiUIKit
#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)

open class MIGraphicsView: MIInterfaceView
{
        public typealias ButtonPressedCallback = MIButtonCore.ButtonPressedCallback

        public override func setup(frame frm: CGRect) {
                super.setup(nibName: "MIMetalViewCore", frameSize: frm.size)
        }

        private func coreGraphicsView() -> MIMetalViewCore {
                if let core: MIMetalViewCore = super.coreView() {
                        return core
                } else {
                        fatalError("Failed to get core view")
                }
        } 
}




