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
        private var mCoreView:          MIBaseView?     = nil
        private var mTagValue:          Int             = MINullTagId

        open override func setup() {
                setup(coreView: MTKView())
        }
}

