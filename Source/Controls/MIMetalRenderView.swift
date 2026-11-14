/*
 * @file MIMetalRenderView.swift
 * @description Define MIMetalRenderView class
 * @par Copyright
 *   Copyright (C) 2026 Steel Wheels Project
 */

import Foundation

open class MIMetalRenderView: MIMetalView
{
        open override func contentSizeUpdated(pointSize ptsize: CGSize, pixelSize pxsize: CGSize) {
                NSLog("drawablePixelSize: \(pxsize.width) x \(pxsize.height)")
        }
}

